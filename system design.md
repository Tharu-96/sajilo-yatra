# Sajilo Yatra Comprehensive Architecture Analysis

This document outlines the core technical architecture, data structures, and operational flows of the Sajilo Yatra platform. The diagrams have been redesigned for maximum clarity and understanding.

## 1. System Architecture

The overarching system architecture separates the mobile frontend from the data-heavy spatial backend and database systems.

```mermaid
flowchart TD
    %% Define Styles
    classDef app fill:#e1f5fe,stroke:#0288d1,stroke-width:2px,color:#000
    classDef server fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px,color:#000
    classDef database fill:#e8f5e9,stroke:#388e3c,stroke-width:2px,color:#000
    classDef internal fill:#ffffff,stroke:#999,stroke-width:1px,color:#000
    classDef internet fill:#fff3e0,stroke:#f57c00,stroke-width:2px,color:#000

    App["📱 1. Mobile App (The Screen)<br/>Users search routes and view maps"]:::app

    subgraph Server ["🧠 2. The Server (The Brain)"]
        API["API Manager<br/>Receives requests from the app"]:::internal
        RoutingLogic["Routing Logic<br/>Prepares the trip request"]:::internal
        FareLogic["Fare Calculator<br/>Computes ticket prices"]:::internal
        
        API --> RoutingLogic
        RoutingLogic --> FareLogic
        FareLogic --> API
    end
    class Server server

    subgraph Database ["🗺️ 3. The Database (The Map Engine)"]
        Storage["Data Storage<br/>Stores Users, Routes, & Stops"]:::internal
        Spatial["Spatial Engine<br/>Finds physical stops near the user"]:::internal
        Pathfinder["Pathfinder Algorithm<br/>Calculates the absolute fastest route"]:::internal
        
        Storage -.- Spatial
        Spatial --> Pathfinder
    end
    class Database database
    
    Internet["🌐 4. External Services<br/>Provides map pictures"]:::internet

    %% Connections
    App -- "1. Sends 'Where do I go?'" --> API
    API -- "4. Sends Route + Price" --> App
    
    RoutingLogic -- "2. Asks for shortest path" --> Spatial
    Pathfinder -- "3. Returns exact route" --> RoutingLogic
    
    App -. "Downloads map images" .-> Internet
```

> [!NOTE]
> **How to explain this:** The user opens the **App** and asks for a route. The **API Manager** inside the Server receives this and hands it to the **Routing Logic**. The Routing Logic asks the Database's **Spatial Engine** to find the closest physical bus stops, and then the **Pathfinder Algorithm** computes the fastest way between them. Once the route is found, it is sent back to the Server where the **Fare Calculator** figures out the price. Finally, the API Manager sends the complete itinerary back to the user's phone.

---

## 2. Entity-Relationship (ER) Diagram

The database schema cleanly separates user data from transit routing graph data.

```mermaid
erDiagram
    %% Core Entities
    USER {
        string id PK
        string name
        string email
        string hashed_password
        string reset_otp_hash
        datetime reset_otp_expires_at
        string profile_image_filename
        datetime created_at
    }

    STOP {
        string id PK
        text name
        float latitude
        float longitude
        geometry geom "PostGIS Point (SRID 4326)"
    }

    ROUTE {
        string id PK
        text name
        text operator
        string vehicle_type
        string color
    }

    %% Relationship Entities
    ROUTE_STOP {
        int id PK
        string route_id FK
        string stop_id FK
        int stop_order
        float distance_from_prev_km
    }

    TRANSFER {
        int id PK
        string from_stop_id FK
        string to_stop_id FK
        int walking_time_min
        int walking_distance_m
    }

    %% Graph Theory Entities (pgRouting)
    ROUTING_NODE {
        int id PK
        string stop_id FK
        string route_id FK
        float lat
        float lon
    }

    ROUTING_EDGE {
        int id PK
        int source_node_id FK
        int target_node_id FK
        string route_id FK
        float cost_time
        float cost_transfers
        float distance_km
        int is_transfer
        float reverse_cost
    }

    %% PostGIS System Table
    SPATIAL_REF_SYS {
        int srid PK
        string auth_name
        int auth_srid
        string srtext
        string proj4text
    }

    %% Relationships
    ROUTE ||--o{ ROUTE_STOP : "contains"
    STOP ||--o{ ROUTE_STOP : "located at"
    STOP ||--o{ TRANSFER : "starts/ends at"
    
    STOP ||--o{ ROUTING_NODE : "mapped to graph node"
    ROUTE ||--o{ ROUTING_NODE : "operates through"
    
    ROUTING_NODE ||--o{ ROUTING_EDGE : "connected by"
    ROUTE ||--o{ ROUTING_EDGE : "traverses"

    SPATIAL_REF_SYS ||--o{ STOP : "defines CRS for geom"
```

---

## 3. Route Search & Graph Pathfinding Flow

How the system maps user coordinates to graph nodes and extracts human-readable itineraries using pgRouting.

```mermaid
sequenceDiagram
    autonumber
    actor User
    participant App as Mobile App
    participant API as FastAPI Router
    participant Engine as RoutingEngine
    participant DB as pgRouting (PostgreSQL)

    User->>App: Enter Origin & Destination coordinates
    App->>API: POST /search {origin, destination, preference}
    
    API->>Engine: find_routes()
    
    Note over Engine,DB: Phase 1: Coordinate Mapping
    Engine->>DB: ST_Distance (Find Nearest Stops)
    DB-->>Engine: Nearest physical Origin & Dest stops
    
    Note over Engine,DB: Phase 2: Dynamic Graph Build
    Engine->>Engine: Generate virtual walking edges from User coords to Nearest Stops
    
    Note over Engine,DB: Phase 3: Pathfinding Algorithm
    Engine->>DB: Execute `pgr_ksp` (K-Shortest Paths) with tuned costs
    DB-->>Engine: Return raw ordered Graph Edges
    
    Note over Engine: Phase 4: Itinerary Cleanup
    Engine->>Engine: Re-chain edges & Group into logical Legs (Walk / Bus)
    Engine->>Engine: Filter out micro-transfers (< 0.2km)
    Engine->>Engine: Deduplicate identical itineraries
    
    Engine->>API: Apply Fare Calculation (via FareEngine)
    API-->>App: JSON RouteSearchResult
    
    App->>User: Render Polylines & Turn-by-Turn Itinerary
```

---

## 4. Fare Calculation Engine Flow

The backend dynamically computes fares based on Nepal's transit distance rules.

```mermaid
flowchart TD
    Start(["Start Fare Calculation"]) --> ReceiveLegs["Receive Array of Transit Legs"]
    
    ReceiveLegs --> InitVars["Initialize total_fare = 0"]
    
    InitVars --> LoopStart{"Are there remaining legs?"}
    
    LoopStart -- Yes --> ExtractLeg["Extract distance_km for current leg"]
    
    ExtractLeg --> BaseFare["Base Fare: Rs 25 for first 5km"]
    
    BaseFare --> CalcExtra{"distance_km > 5?"}
    
    CalcExtra -- Yes --> ExtraFare["extra_fare = 5 * ceil((distance - 5) / 5)"]
    CalcExtra -- No --> NoExtra["extra_fare = 0"]
    
    ExtraFare --> LegTotal["leg_fare = 25 + extra_fare"]
    NoExtra --> LegTotal
    
    LegTotal --> AddToTotal["total_fare += leg_fare"]
    AddToTotal --> LoopStart
    
    LoopStart -- No --> ReturnFare(["Return total_fare and breakdown"])
```

> [!TIP]
> **Fare Logic Rule:** The algorithm applies a base fare of Rs 25 for the first 5 kilometers. For every additional 5 kilometers (or fraction thereof), an extra Rs 5 is added to the leg's fare. Transfers mean the fare resets for the next leg.

---

## 5. Authentication & Password Reset Flow

The secure JWT-based authentication system handles login, registration, and email-based OTP password resets.

```mermaid
sequenceDiagram
    actor User
    participant App as Mobile App
    participant Auth as FastAPI Auth Router
    participant DB as PostgreSQL
    participant SMTP as SMTP Server (Email)

    %% Login Flow
    rect rgb(24, 30, 40)
        Note over User,DB: Login Flow
        User->>App: Submits Email & Password
        App->>Auth: POST /login
        Auth->>DB: Query User by Email
        DB-->>Auth: User Record (Hashed Password)
        Auth->>Auth: Verify Bcrypt Hash
        Auth-->>App: Return JWT Access Token
    end

    %% Forgot Password Flow
    rect rgb(30, 24, 40)
        Note over User,SMTP: Password Reset Flow
        User->>App: Request Password Reset (Email)
        App->>Auth: POST /forgot-password
        Auth->>DB: Check if Email exists
        Auth->>Auth: Generate 6-digit OTP & Hash it
        Auth->>DB: Save OTP Hash & Expiry (15 mins)
        Auth->>SMTP: Send OTP via Email
        SMTP-->>User: Delivers Email with OTP
        Auth-->>App: Status 202 Accepted
    end

    %% Reset Action
    rect rgb(24, 40, 30)
        Note over User,DB: Execute Password Reset
        User->>App: Submit OTP + New Password
        App->>Auth: POST /reset-password
        Auth->>DB: Fetch User & OTP Hash
        Auth->>Auth: Validate OTP Hash & Expiry Time
        Auth->>Auth: Hash New Password (Bcrypt)
        Auth->>DB: Update Password, Clear OTP fields
        Auth-->>App: Status 200 OK (Password Updated)
    end
```

---

## 6. Saved Places Module Flow

The Saved Places module operates entirely client-side, persisting favorite locations (Home, Work, etc.) to local device storage using Riverpod providers.

```mermaid
flowchart LR
    subgraph UI ["User Interface (Flutter)"]
        SaveScreen[Save Location Screen]
        ListScreen[Saved Places Screen]
        MapSelect[Map Location Picker]
    end

    subgraph State ["Riverpod State Management"]
        Provider[SavedPlacesProvider]
        Notifier[StateNotifier]
    end

    subgraph Storage ["Local Device Storage"]
        Prefs[(Shared Preferences / Local DB)]
    end

    MapSelect -- "Select Lat/Lng" --> SaveScreen
    SaveScreen -- "1. Add Place (Name, Icon, Lat/Lng)" --> Provider
    
    ListScreen -- "3. Edit/Delete/View Places" --> Provider
    
    Provider -- "Update State" --> Notifier
    Notifier -- "2. Persist to Disk (JSON)" --> Prefs
    Prefs -- "Load on App Start" --> Notifier
    Notifier -- "Stream Updates" --> UI
```

> [!IMPORTANT]
> Saved Places are stored locally on the user's device and do not sync to the backend database. This ensures privacy for user locations and provides immediate offline access to favorite coordinates for routing.

---

## 7. Travel Time Calculation Flow

Travel time is calculated dynamically during the graph generation (`build_pgrouting_graph.py`) and routing phases based on assumed speeds for different modes of transportation.

```mermaid
flowchart TD
    Start(["Start Edge Cost Calculation"]) --> IdentifyEdgeType{"What type of travel?"}
    
    %% Bus Leg logic
    IdentifyEdgeType -- "Bus Route Edge" --> BusDistance["Get Distance between Stops"]
    BusDistance --> BusSpeed["Assume 20 km/h Average Speed"]
    BusSpeed --> BusCalc["Time (min) = (Distance / 20.0) * 60.0"]
    
    %% Walking Leg logic
    IdentifyEdgeType -- "Walking / User to Stop" --> WalkDistance["Get Straight-line Haversine Distance"]
    WalkDistance --> Manhattan["Multiply by Manhattan Factor (1.3)<br/>for urban street grids"]
    Manhattan --> WalkSpeed["Assume 5 km/h Walking Speed"]
    WalkSpeed --> WalkCalc["Time (min) = (Adjusted Distance / 5.0) * 60.0"]
    
    %% Transfer logic
    IdentifyEdgeType -- "Same-Stop Transfer" --> WaitPenalty["Apply fixed 3-minute Wait Time"]
    
    %% Output
    BusCalc --> Output(["Save cost_time to Graph Edge"])
    WalkCalc --> Output
    WaitPenalty --> Output
```

> [!NOTE]
> **Nuisance Penalty:** When sorting for the "shortest" route, the algorithm injects a hidden 3-minute penalty for every transfer to discourage the router from suggesting chaotic multi-bus itineraries just to save a few seconds. This penalty is only used for sorting and is omitted from the final displayed time.
