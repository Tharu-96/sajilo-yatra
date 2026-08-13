# 🚌 Sajilo Yatra - An intelligent mobile App

Welcome to **Sajilo Yatra**, a comprehensive public transit and routing application that simplifies your daily commute. With an interactive map interface, intelligent route finding, fare calculations, and a secure backend, Sajilo Yatra provides a seamless and cinematic transit experience for everyday commuters.

## 🚀 Key Features

*   **Intelligent Route Finder**: Discover the most optimal bus and transit routes from your origin to destination.
*   **Interactive Maps**: Powered by OpenStreetMap (OSRM & Nominatim) and Leaflet (`flutter_map`), featuring panning, and zoom support.
*   **Nearby Stops**: Instantly find bus stops near your current location using geospatial querying.
*   **Saved Places**: Securely save your home, work, and favorite places for quick route planning.
*   **Secure Authentication**: robust JWT-based user authentication (Signup, Login, Profile Management).
*   **Dynamic Fare Calculation**: Automatically computes your trip's fare based on route distance and local transit rules.

## 🛠️ Tech Stack

### Frontend (Mobile App)
*   **Framework**: [Flutter](https://flutter.dev/) (Dart)
*   **State Management**: Riverpod
*   **Maps & Routing**: `flutter_map`, `latlong2`, `geolocator`, OpenStreetMap (OSRM & Nominatim)
*   **Local Storage**: Secure Storage & Shared Preferences

### Backend (API Server)
*   **Framework**: [FastAPI](https://fastapi.tiangolo.com/) (Python)
*   **Database**: PostgreSQL with PostGIS & pgRouting (via GeoAlchemy2)
*   **ORM**: SQLAlchemy & Pydantic
*   **Authentication**: OAuth2 with JWT (`python-jose`, `passlib`)

## 📦 Getting Started

To run this project locally, you will need to set up both the backend server and the Flutter mobile application.

### Prerequisites
*   Flutter SDK (v3.0.0+)
*   Python (3.9+)
*   PostgreSQL (with PostGIS and pgRouting extensions enabled)

---

### 1. Backend Setup

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```
2. Create a virtual environment and activate it:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```
3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
4. **Environment Variables**: Create a `.env` file in the `backend` directory. **(Do not use real production secrets here!)**
   ```env
   # .env
   DATABASE_URL=postgresql://<db_user>:<db_password>@localhost:5432/database_name
   SECRET_KEY=generate_a_random_secret_string_here
   ALGORITHM=HS256
   ACCESS_TOKEN_EXPIRE_MINUTES=30
   ```
5. Run the database seeders or migrations (if applicable) and start the FastAPI server:
   ```bash
   uvicorn app.main:app --reload
   ```
   The API will be available at `http://127.0.0.1:8000`. You can view the interactive Swagger docs at `http://127.0.0.1:8000/docs`.

---

### 2. Mobile Setup

1. Navigate to the mobile directory:
   ```bash
   cd mobile
   ```
2. Fetch Flutter packages:
   ```bash
   flutter pub get
   ```
3. **Environment Variables**: Create a `.env` file in the `mobile` directory to point to your backend API.
   ```env
   # .env
   # Use 10.0.2.2 for Android Emulator, or your local IP (e.g., 192.168.x.x) for physical devices
   API_BASE_URL=http://127.0.0.1:8000
   MAPTILER_API_KEY= Your API key
   ```
4. Run the app on your connected device or emulator:
   ```bash
   flutter run
   ```
   
## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.
