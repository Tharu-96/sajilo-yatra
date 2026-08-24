"""
Build routing_nodes and routing_edges tables for pgRouting.
Enhanced with:
1. Direction-aware pedestrian walking edges
2. Route-aware transfer edges (prevents unnecessary transfers)
3. Road crossing penalties
"""

import sys
import os
import logging
import math
from typing import Optional, Dict, List, Set, Tuple, Any

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

from sqlalchemy import text
from app.database import engine, SessionLocal, Base
from app.models import Stop, Route, RouteStop, RoutingNode, RoutingEdge

# ============================================================
# CONFIGURATION - Fine-tune these parameters
# ============================================================

class RoutingConfig:
    """Configuration parameters for graph building"""
    
    # Walking parameters
    WALKING_SPEED_KMPH = 5.0  # Average walking speed (km/h)
    MAX_WALK_TRANSFER_KM = 0.25  # Maximum walking distance for transfer (250m)
    MAX_NEARBY_STOPS = 5  # Number of nearby stops to consider
    
    # Direction penalty parameters
    DIRECTION_PENALTY_KM = 0.15  # Max extra distance for wrong direction (150m)
    DIRECTION_TIME_PENALTY_MIN = 3.0  # Max extra time for wrong direction (3 min)
    DIRECTION_PENALTY_EXPONENT = 1.5  # Exponential factor for direction penalty
    
    # Road crossing parameters
    ROAD_CROSSING_THRESHOLD_KM = 0.05  # 50m - assume road crossing beyond this
    ROAD_CROSSING_PENALTY_KM = 0.03  # Extra distance for road crossing (30m)
    ROAD_CROSSING_TIME_PENALTY_MIN = 0.5  # Time penalty for road crossing (30 sec)
    ROAD_CROSSING_PENALTY_FACTOR = 1.5  # Multiplier for road crossing penalty
    
    # Transfer parameters
    TRANSFER_TIME_MIN = 3.0  # Time for same-stop transfer (minutes)
    TRANSFER_COST = 1  # Transfer count cost
    UNNECESSARY_TRANSFER_PENALTY = 15.0  # Penalty for transferring off a direct route
    
    # Route parameters
    BUS_SPEED_KMPH = 20.0  # Average bus speed (km/h)
    
    # Debug/Logging
    LOG_LEVEL = logging.INFO
    ENABLE_DEBUG_LOGGING = False

# ============================================================
# SETUP LOGGING
# ============================================================

logging.basicConfig(
    level=RoutingConfig.LOG_LEVEL,
    format="%(levelname)s: %(message)s"
)
logger = logging.getLogger(__name__)

# ============================================================
# UTILITY FUNCTIONS
# ============================================================

def haversine_distance(lat1: float, lon1: float, lat2: float, lon2: float) -> float:
    """
    Calculate the great-circle distance between two points on Earth.
    Returns distance in kilometers.
    """
    R = 6371.0  # Earth's radius in kilometers
    dlat = math.radians(lat2 - lat1)
    dlon = math.radians(lon2 - lon1)
    a = (math.sin(dlat / 2)**2 + 
         math.cos(math.radians(lat1)) * math.cos(math.radians(lat2)) * 
         math.sin(dlon / 2)**2)
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
    return R * c

def calculate_bearing(lat1: float, lon1: float, lat2: float, lon2: float) -> float:
    """
    Calculate the bearing (direction) from point 1 to point 2.
    Returns bearing in radians (0 = North, π/2 = East, π = South, 3π/2 = West)
    """
    lat1_rad = math.radians(lat1)
    lat2_rad = math.radians(lat2)
    dlon = math.radians(lon2 - lon1)
    
    x = math.sin(dlon) * math.cos(lat2_rad)
    y = math.cos(lat1_rad) * math.sin(lat2_rad) - \
        math.sin(lat1_rad) * math.cos(lat2_rad) * math.cos(dlon)
    
    bearing = math.atan2(x, y)
    return bearing

def calculate_direction_score(
    source_lat: float, 
    source_lon: float, 
    target_lat: float, 
    target_lon: float,
    dest_lat: float, 
    dest_lon: float
) -> float:
    """
    Calculate how well a target stop is aligned with the destination direction.
    
    Returns:
        float: Score between 0 (perfect direction) and 1 (opposite direction)
    """
    # Bearing from source to destination
    dest_bearing = calculate_bearing(source_lat, source_lon, dest_lat, dest_lon)
    
    # Bearing from source to target stop
    stop_bearing = calculate_bearing(source_lat, source_lon, target_lat, target_lon)
    
    # Calculate angular difference
    angle_diff = abs(dest_bearing - stop_bearing)
    if angle_diff > math.pi:
        angle_diff = 2 * math.pi - angle_diff
    
    # Normalize to 0-1 (0 = perfect direction, 1 = opposite)
    direction_score = angle_diff / math.pi
    
    return direction_score

def calculate_direction_penalty(direction_score: float) -> Tuple[float, float]:
    """
    Calculate the penalty for going in the wrong direction.
    Uses exponential scaling to heavily penalize completely wrong directions.
    
    Returns:
        Tuple[float, float]: (distance_penalty_km, time_penalty_min)
    """
    # Apply exponential scaling to make wrong directions more costly
    weighted_score = direction_score ** RoutingConfig.DIRECTION_PENALTY_EXPONENT
    
    # Calculate distance penalty (km)
    distance_penalty = weighted_score * RoutingConfig.DIRECTION_PENALTY_KM
    
    # Calculate time penalty (minutes)
    time_penalty = weighted_score * RoutingConfig.DIRECTION_TIME_PENALTY_MIN
    
    return distance_penalty, time_penalty

def calculate_road_crossing_penalty(
    source_stop: Stop,
    target_stop: Stop
) -> Tuple[float, float]:
    """
    Calculate penalties for road crossing between two stops.
    
    Returns:
        Tuple[float, float]: (distance_penalty_km, time_penalty_min)
    """
    distance = haversine_distance(
        source_stop.latitude, source_stop.longitude,
        target_stop.latitude, target_stop.longitude
    )
    
    # If stops are close, assume no road crossing needed
    if distance < RoutingConfig.ROAD_CROSSING_THRESHOLD_KM:
        return 0.0, 0.0
    
    # Check if stops are on opposite sides of a road
    # Simple heuristic: if distance is significant, assume road crossing
    # More sophisticated: use actual road data
    
    # Distance penalty for detour to crossing point
    distance_penalty = RoutingConfig.ROAD_CROSSING_PENALTY_KM * \
                      RoutingConfig.ROAD_CROSSING_PENALTY_FACTOR
    
    # Time penalty for waiting and crossing
    time_penalty = RoutingConfig.ROAD_CROSSING_TIME_PENALTY_MIN * \
                  RoutingConfig.ROAD_CROSSING_PENALTY_FACTOR
    
    return distance_penalty, time_penalty

def validate_stop_coordinates(stop: Stop) -> bool:
    """
    Validate that a stop has valid coordinates.
    """
    if stop.latitude is None or stop.longitude is None:
        return False
    if not (-90 <= stop.latitude <= 90) or not (-180 <= stop.longitude <= 180):
        return False
    return True

def get_destination_coordinates() -> Tuple[float, float]:
    """
    Get destination coordinates.
    In production, this would come from the user's input or API request.
    """
    # Default: Koteshwor, Kathmandu coordinates
    return 27.6805, 85.3387

def is_route_direct_to_destination(
    route_id: int, 
    current_stop_id: int, 
    destination_stop_id: int, 
    route_stop_map: Dict[int, List[RouteStop]]
) -> bool:
    """
    Check if a route goes directly from current stop to destination
    without needing to transfer.
    
    Args:
        route_id: ID of the route
        current_stop_id: Current stop ID
        destination_stop_id: Destination stop ID
        route_stop_map: Map of route_id -> list of RouteStop objects
    
    Returns:
        bool: True if the route goes directly to destination
    """
    route_stops = route_stop_map.get(route_id, [])
    
    # Get positions
    current_pos = None
    dest_pos = None
    
    for rs in route_stops:
        if rs.stop_id == current_stop_id:
            current_pos = rs.stop_order
        if rs.stop_id == destination_stop_id:
            dest_pos = rs.stop_order
    
    # Destination must be AFTER current stop on this route
    if current_pos is not None and dest_pos is not None:
        return dest_pos > current_pos
    
    return False

# ============================================================
# MAIN GRAPH BUILDING FUNCTION
# ============================================================

def build_graph(
    destination_lat: Optional[float] = None,
    destination_lon: Optional[float] = None,
    destination_stop_id: Optional[int] = None
) -> Dict[str, Any]:
    """
    Build the routing graph with:
    1. Direction-aware walking edges
    2. Route-aware transfer edges (prevents unnecessary transfers)
    3. Road crossing penalties
    
    Args:
        destination_lat: Destination latitude (optional)
        destination_lon: Destination longitude (optional)
        destination_stop_id: Destination stop ID (optional)
    
    Returns:
        Dict with statistics about the built graph
    """
    
    # Statistics tracking
    stats = {
        'total_stops': 0,
        'total_routes': 0,
        'total_nodes': 0,
        'route_edges': 0,
        'transfer_edges': 0,
        'pedestrian_edges': 0,
        'total_edges': 0,
        'walking_candidates': 0,
        'walking_connections': 0,
        'direction_penalties_applied': 0,
        'road_crossing_penalties_applied': 0,
        'unnecessary_transfers_prevented': 0
    }
    
    db = SessionLocal()
    
    try:
        # ============================================================
        # STEP 0: SETUP AND DATA LOADING
        # ============================================================
        
        # Create the new tables if they don't exist
        Base.metadata.create_all(bind=engine)
        
        # Clear existing routing data
        logger.info("Clearing existing routing data...")
        db.execute(text("TRUNCATE routing_edges, routing_nodes RESTART IDENTITY CASCADE"))
        db.commit()
        
        # Fetch data
        stops = {s.id: s for s in db.query(Stop).all()}
        routes = db.query(Route).all()
        
        stats['total_stops'] = len(stops)
        stats['total_routes'] = len(routes)
        
        logger.info(f"Loaded {len(stops)} stops and {len(routes)} routes")
        
        # Determine destination
        if destination_stop_id and destination_stop_id in stops:
            dest_stop = stops[destination_stop_id]
            dest_lat, dest_lon = dest_stop.latitude, dest_stop.longitude
            logger.info(f"Using destination stop: ID={destination_stop_id}")
        elif destination_lat is not None and destination_lon is not None:
            dest_lat, dest_lon = destination_lat, destination_lon
            dest_stop = None
            logger.info(f"Using destination coordinates: ({dest_lat:.4f}, {dest_lon:.4f})")
        else:
            dest_lat, dest_lon = get_destination_coordinates()
            dest_stop = None
            logger.info(f"Using default destination: ({dest_lat:.4f}, {dest_lon:.4f})")
        
        # ============================================================
        # STEP 1: BUILD NODES
        # ============================================================
        logger.info("Building nodes...")
        stop_to_routes = {}
        node_map = {}  # (stop_id, route_id) -> node_id
        route_stop_map = {}  # route_id -> list of RouteStop objects
        
        for route in routes:
            r_stops = sorted(route.route_stops, key=lambda rs: rs.stop_order)
            route_stop_map[route.id] = r_stops
            
            for rs in r_stops:
                stop_id = rs.stop_id
                if (stop_id, route.id) not in node_map:
                    stop = stops.get(stop_id)
                    if not stop or not validate_stop_coordinates(stop):
                        logger.warning(f"Skipping stop {stop_id} - invalid coordinates")
                        continue
                    
                    node = RoutingNode(
                        stop_id=stop_id,
                        route_id=route.id,
                        lat=stop.latitude,
                        lon=stop.longitude
                    )
                    db.add(node)
                    db.flush()  # get ID
                    node_map[(stop_id, route.id)] = node.id
                    stop_to_routes.setdefault(stop_id, []).append(route.id)
        
        stats['total_nodes'] = len(node_map)
        logger.info(f"Created {len(node_map)} nodes.")
        
        # ============================================================
        # STEP 2: BUILD ROUTE EDGES
        # ============================================================
        logger.info("Building route edges...")
        edges_to_insert = []
        
        for route in routes:
            r_stops = sorted(route.route_stops, key=lambda rs: rs.stop_order)
            for i in range(len(r_stops) - 1):
                curr_rs = r_stops[i]
                next_rs = r_stops[i + 1]
                
                # Skip duplicate adjacent stops
                if curr_rs.stop_id == next_rs.stop_id:
                    logger.debug(f"Skipping duplicate edge on route {route.id}")
                    continue
                
                source_id = node_map.get((curr_rs.stop_id, route.id))
                target_id = node_map.get((next_rs.stop_id, route.id))
                
                if source_id is None or target_id is None:
                    logger.warning(f"Skipping edge - missing node on route {route.id}")
                    continue
                
                # Calculate distance
                dist = next_rs.distance_from_prev_km
                if not dist or dist <= 0:
                    s1 = stops.get(curr_rs.stop_id)
                    s2 = stops.get(next_rs.stop_id)
                    if s1 and s2:
                        dist = haversine_distance(
                            s1.latitude, s1.longitude, 
                            s2.latitude, s2.longitude
                        )
                    else:
                        dist = 0.1  # Default fallback
                
                # Calculate travel time
                time_min = dist / RoutingConfig.BUS_SPEED_KMPH * 60.0
                
                edges_to_insert.append(RoutingEdge(
                    source=source_id,
                    target=target_id,
                    route_id=route.id,
                    cost_time=time_min,
                    cost_transfers=0,
                    distance_km=dist,
                    is_transfer=0,
                    reverse_cost=-1.0
                ))
                stats['route_edges'] += 1
        
        logger.info(f"Created {stats['route_edges']} route edges.")
        
        # ============================================================
        # STEP 3: BUILD SMART TRANSFER EDGES (Route-Aware)
        # ============================================================
        logger.info("Building transfer edges with route awareness...")
        
        for stop_id, r_ids in stop_to_routes.items():
            for i in range(len(r_ids)):
                for j in range(len(r_ids)):
                    if i != j:
                        source_route = r_ids[i]
                        target_route = r_ids[j]
                        
                        source_id = node_map.get((stop_id, source_route))
                        target_id = node_map.get((stop_id, target_route))
                        
                        if source_id is None or target_id is None:
                            continue
                        
                        # ============================================================
                        # SMART LOGIC: Check if transfer is necessary
                        # ============================================================
                        
                        # Check if source route can reach destination directly
                        direct_to_dest = False
                        if dest_stop:
                            direct_to_dest = is_route_direct_to_destination(
                                source_route, 
                                stop_id,
                                dest_stop.id,
                                route_stop_map
                            )
                        
                        # If source route goes directly to destination
                        if direct_to_dest:
                            # Transferring away from a direct route is bad!
                            # Penalize heavily to prevent unnecessary transfers
                            transfer_cost = RoutingConfig.UNNECESSARY_TRANSFER_PENALTY
                            transfer_count = 0  # Don't count as a transfer
                            stats['unnecessary_transfers_prevented'] += 1
                            
                            if RoutingConfig.ENABLE_DEBUG_LOGGING:
                                logger.debug(
                                    f"Penalizing transfer from direct route {source_route} "
                                    f"to {target_route} at stop {stop_id}"
                                )
                        else:
                            # Normal transfer
                            transfer_cost = RoutingConfig.TRANSFER_TIME_MIN
                            transfer_count = RoutingConfig.TRANSFER_COST
                        
                        edges_to_insert.append(RoutingEdge(
                            source=source_id,
                            target=target_id,
                            route_id=None,
                            cost_time=transfer_cost,
                            cost_transfers=transfer_count,
                            distance_km=0.0,
                            is_transfer=1,
                            reverse_cost=-1.0
                        ))
                        stats['transfer_edges'] += 1
        
        logger.info(f"Created {stats['transfer_edges']} transfer edges.")
        logger.info(f"Prevented {stats['unnecessary_transfers_prevented']} unnecessary transfers.")
        
        # ============================================================
        # STEP 4: BUILD SMART WALKING EDGES (Direction & Road Aware)
        # ============================================================
        logger.info("Building pedestrian transfer edges with direction and road awareness...")
        logger.info(f"Max walk distance: {RoutingConfig.MAX_WALK_TRANSFER_KM}km")
        logger.info(f"Max nearby stops: {RoutingConfig.MAX_NEARBY_STOPS}")
        
        for source_stop in stops.values():
            if not validate_stop_coordinates(source_stop):
                continue
            
            candidates = []
            
            for target_stop in stops.values():
                if target_stop.id == source_stop.id:
                    continue
                
                if not validate_stop_coordinates(target_stop):
                    continue
                
                # Calculate physical distance
                raw_distance = haversine_distance(
                    source_stop.latitude, source_stop.longitude,
                    target_stop.latitude, target_stop.longitude
                )
                
                # Skip if too far
                if raw_distance > RoutingConfig.MAX_WALK_TRANSFER_KM:
                    continue
                
                stats['walking_candidates'] += 1
                
                # Calculate direction score
                direction_score = calculate_direction_score(
                    source_stop.latitude, source_stop.longitude,
                    target_stop.latitude, target_stop.longitude,
                    dest_lat, dest_lon
                )
                
                # Calculate direction penalties
                direction_distance_penalty, direction_time_penalty = \
                    calculate_direction_penalty(direction_score)
                
                # Apply direction penalties if significant
                if direction_score > 0.3:  # More than 30% wrong direction
                    stats['direction_penalties_applied'] += 1
                
                # Calculate road crossing penalties
                road_distance_penalty, road_time_penalty = \
                    calculate_road_crossing_penalty(source_stop, target_stop)
                
                if road_distance_penalty > 0:
                    stats['road_crossing_penalties_applied'] += 1
                
                # Calculate effective distance (for sorting)
                effective_distance = (
                    raw_distance + 
                    direction_distance_penalty + 
                    road_distance_penalty
                )
                
                # Calculate total walking time
                walking_time = (
                    (raw_distance / RoutingConfig.WALKING_SPEED_KMPH * 60.0) +
                    direction_time_penalty +
                    road_time_penalty
                )
                
                candidates.append({
                    'target_stop': target_stop,
                    'raw_distance': raw_distance,
                    'direction_score': direction_score,
                    'direction_penalty_km': direction_distance_penalty,
                    'direction_penalty_min': direction_time_penalty,
                    'road_penalty_km': road_distance_penalty,
                    'road_penalty_min': road_time_penalty,
                    'effective_distance': effective_distance,
                    'walking_time': walking_time
                })
            
            # Sort by effective distance (lower is better)
            candidates.sort(key=lambda x: x['effective_distance'])
            
            # Select top N stops
            for candidate in candidates[:RoutingConfig.MAX_NEARBY_STOPS]:
                target_stop = candidate['target_stop']
                raw_distance = candidate['raw_distance']
                direction_score = candidate['direction_score']
                walking_time = candidate['walking_time']
                
                # Ensure minimum distance to avoid zero-cost edges
                distance = max(raw_distance, 0.01)
                
                # Debug logging
                if RoutingConfig.ENABLE_DEBUG_LOGGING and direction_score > 0.5:
                    logger.debug(
                        f"Stop {source_stop.id} -> {target_stop.id}: "
                        f"dist={raw_distance:.3f}km, "
                        f"dir_score={direction_score:.2f}, "
                        f"walk_time={walking_time:.1f}min"
                    )
                
                # Create walking edges between all route combinations
                source_routes = stop_to_routes.get(source_stop.id, [])
                target_routes = stop_to_routes.get(target_stop.id, [])
                
                for source_route in source_routes:
                    for target_route in target_routes:
                        source_id = node_map.get((source_stop.id, source_route))
                        target_id = node_map.get((target_stop.id, target_route))
                        
                        if source_id is None or target_id is None:
                            continue
                        
                        edges_to_insert.append(RoutingEdge(
                            source=source_id,
                            target=target_id,
                            route_id=None,
                            cost_time=walking_time,
                            cost_transfers=RoutingConfig.TRANSFER_COST,
                            distance_km=distance,
                            is_transfer=1,
                            reverse_cost=-1.0,
                        ))
                        stats['pedestrian_edges'] += 1
                        stats['walking_connections'] += 1
        
        # ============================================================
        # STEP 5: COMMIT TO DATABASE
        # ============================================================
        logger.info(f"Inserting {len(edges_to_insert)} total edges...")
        db.add_all(edges_to_insert)
        db.commit()
        
        stats['total_edges'] = len(edges_to_insert)
        
        # ============================================================
        # STEP 6: LOG STATISTICS
        # ============================================================
        logger.info("=" * 60)
        logger.info("GRAPH BUILDING COMPLETE")
        logger.info("=" * 60)
        logger.info(f"Stops processed: {stats['total_stops']}")
        logger.info(f"Routes processed: {stats['total_routes']}")
        logger.info(f"Nodes created: {stats['total_nodes']}")
        logger.info(f"Route edges: {stats['route_edges']}")
        logger.info(f"Transfer edges: {stats['transfer_edges']}")
        logger.info(f"Pedestrian edges: {stats['pedestrian_edges']}")
        logger.info(f"Total edges: {stats['total_edges']}")
        logger.info(f"Walking candidates considered: {stats['walking_candidates']}")
        logger.info(f"Walking connections created: {stats['walking_connections']}")
        logger.info(f"Direction penalties applied: {stats['direction_penalties_applied']}")
        logger.info(f"Road crossing penalties applied: {stats['road_crossing_penalties_applied']}")
        logger.info(f"Unnecessary transfers prevented: {stats['unnecessary_transfers_prevented']}")
        logger.info("=" * 60)
        
    except Exception as e:
        db.rollback()
        logger.error(f"Failed to build graph: {e}", exc_info=True)
        raise
    finally:
        db.close()
    
    return stats

# ============================================================
# COMMAND LINE EXECUTION
# ============================================================

if __name__ == "__main__":
    import argparse
    
    parser = argparse.ArgumentParser(description='Build routing graph for pgRouting')
    parser.add_argument('--dest-lat', type=float, help='Destination latitude')
    parser.add_argument('--dest-lon', type=float, help='Destination longitude')
    parser.add_argument('--dest-stop', type=int, help='Destination stop ID')
    parser.add_argument('--debug', action='store_true', help='Enable debug logging')
    parser.add_argument('--max-walk', type=float, default=0.25, 
                       help='Maximum walking distance in km (default: 0.25)')
    parser.add_argument('--max-stops', type=int, default=5,
                       help='Maximum nearby stops to consider (default: 5)')
    
    args = parser.parse_args()
    
    # Update configuration if provided
    if args.debug:
        RoutingConfig.LOG_LEVEL = logging.DEBUG
        RoutingConfig.ENABLE_DEBUG_LOGGING = True
        logging.basicConfig(level=logging.DEBUG)
    
    if args.max_walk:
        RoutingConfig.MAX_WALK_TRANSFER_KM = args.max_walk
    
    if args.max_stops:
        RoutingConfig.MAX_NEARBY_STOPS = args.max_stops
    
    # Build the graph
    stats = build_graph(
        destination_lat=args.dest_lat,
        destination_lon=args.dest_lon,
        destination_stop_id=args.dest_stop
    )
    
    # Print final stats
    print("\n" + "=" * 60)
    print("GRAPH BUILT SUCCESSFULLY!")
    print("=" * 60)
    print(f"Total nodes: {stats['total_nodes']}")
    print(f"Total edges: {stats['total_edges']}")
    print(f"  - Route edges: {stats['route_edges']}")
    print(f"  - Transfer edges: {stats['transfer_edges']}")
    print(f"  - Pedestrian edges: {stats['pedestrian_edges']}")
    print(f"Unnecessary transfers prevented: {stats['unnecessary_transfers_prevented']}")
    print("=" * 60)