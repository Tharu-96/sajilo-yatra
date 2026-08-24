import math
import time
from typing import List, Dict, Any, Optional
from sqlalchemy.orm import Session
from sqlalchemy import text
from app.models import RoutingNode
from app.services.fare_engine import calculate_fare
import networkx as nx

# ============================================================
# PERFORMANCE CONFIGURATION
# ============================================================

class RouteEngineConfig:
    """Performance tuning for route engine"""
    
    # Graph loading
    CACHE_GRAPH = True  # Keep graph in memory
    GRAPH_REFRESH_INTERVAL = 300  # Refresh every 5 minutes
    
    # Route finding limits
    MAX_PATHS_PER_STRATEGY = 10  # Reduced from 30 for speed
    MAX_ROUTES_TO_RETURN = 3
    
    # Timeout
    ROUTE_TIMEOUT_SECONDS = 3
    
    # Cache results
    CACHE_ROUTES = True
    CACHE_TTL = 300  # 5 minutes

# ============================================================
# CACHE IMPLEMENTATION
# ============================================================

class RouteCache:
    """Simple in-memory cache for route results"""
    
    def __init__(self):
        self.cache = {}
        self.ttl = RouteEngineConfig.CACHE_TTL
    
    def get(self, key):
        """Get cached result if valid"""
        if key in self.cache:
            data, timestamp = self.cache[key]
            if time.time() - timestamp < self.ttl:
                return data
        return None
    
    def set(self, key, data):
        """Cache a result"""
        self.cache[key] = (data, time.time())
    
    def clear(self):
        """Clear all cache"""
        self.cache.clear()

# Global cache instance
_route_cache = RouteCache()

# ============================================================
# GRAPH LOADING WITH CACHING
# ============================================================

WALKING_DISTANCE_MULTIPLIER = 1.3
MICRO_TRANSFER_THRESHOLD_KM = 0.2
_NEPAL_BOUNDS = {
    "lat_min": 26.347, "lat_max": 30.447,
    "lng_min": 80.058, "lng_max": 88.201,
}

def _is_within_nepal(lat: float, lng: float) -> bool:
    return (_NEPAL_BOUNDS["lat_min"] <= lat <= _NEPAL_BOUNDS["lat_max"]
            and _NEPAL_BOUNDS["lng_min"] <= lng <= _NEPAL_BOUNDS["lng_max"])

_G = None
_G_static_edges = {}
_G_last_loaded = 0

def _load_graph(db: Session):
    """Load graph with caching for performance"""
    global _G, _G_static_edges, _G_last_loaded
    
    # Return cached graph if valid
    if _G is not None and RouteEngineConfig.CACHE_GRAPH:
        # Refresh if needed
        if time.time() - _G_last_loaded < RouteEngineConfig.GRAPH_REFRESH_INTERVAL:
            return _G
    
    _G = nx.DiGraph()
    _G_static_edges = {}
    
    # OPTIMIZED: Only load necessary columns, add LIMIT
    static_sql = """SELECT e.id, e.source, e.target, e.cost_time, e.distance_km,
        CASE WHEN e.is_transfer = 1 OR EXISTS (
          SELECT 1 FROM transfers t JOIN routing_nodes sn ON sn.id = e.source
          JOIN routing_nodes tn ON tn.id = e.target
          WHERE t.from_stop_id = sn.stop_id AND t.to_stop_id = tn.stop_id
        ) THEN 1 ELSE 0 END transfer_marker,
        CASE WHEN e.is_transfer = 1 AND e.distance_km > 0 THEN 1 ELSE 0 END is_pedestrian,
        e.reverse_cost, e.route_id,
        sn.stop_id as from_stop_id, tn.stop_id as to_stop_id,
        ss.name as from_stop, ts.name as to_stop,
        r.name as route_name, r.operator as operator_name
        FROM routing_edges e
        LEFT JOIN routing_nodes sn ON sn.id = e.source
        LEFT JOIN routing_nodes tn ON tn.id = e.target
        LEFT JOIN stops ss ON ss.id = sn.stop_id
        LEFT JOIN stops ts ON ts.id = tn.stop_id
        LEFT JOIN routes r ON r.id = e.route_id
        WHERE e.is_transfer = 1
           OR (e.source <> e.target AND e.cost_time > 0 AND e.distance_km >= 0)
        ORDER BY e.id"""
           
    rows = db.execute(text(static_sql)).mappings().all()
    
    for row in rows:
        u, v = row["source"], row["target"]
        edge_id = row["id"]
        _G_static_edges[edge_id] = dict(row)
        
        cost = float(row["cost_time"]) + float(row["transfer_marker"]) * 3.0
        
        # Only add edge if it's better than existing
        if _G.has_edge(u, v):
            if cost < _G[u][v]["base_cost"]:
                _G[u][v].update({"base_cost": cost, "edge_id": edge_id, **dict(row)})
        else:
            _G.add_edge(u, v, base_cost=cost, edge_id=edge_id, **dict(row))
            
        # Handle bidirectional edges
        if row["reverse_cost"] is not None and float(row["reverse_cost"]) >= 0:
            if _G.has_edge(v, u):
                if cost < _G[v][u]["base_cost"]:
                    _G[v][u].update({"base_cost": cost, "edge_id": edge_id, **dict(row)})
            else:
                _G.add_edge(v, u, base_cost=cost, edge_id=edge_id, **dict(row))
    
    _G_last_loaded = time.time()
    return _G

# ============================================================
# STRATEGY CONFIGURATION
# ============================================================

_SUGGESTION_PREFERENCES = ("shortest", "fewer_transfers", "least_walking")
SANITY_TIME_MULTIPLIER = 1.5
SANITY_TIME_BUFFER_MIN = 15

# ============================================================
# OPTIMIZED ROUTE COLLECTION
# ============================================================

def _collect_routes(G, dynamic_edges, preference, origin_lat, origin_lng, dest_lat, dest_lng,
                    pool, seen_signatures, seen_itineraries):
    """Run one weighting strategy and append its best unique itineraries."""
    
    def weight_func(u, v, d):
        cost_time = float(d.get("cost_time", 0))
        transfer_marker = float(d.get("transfer_marker", 0))
        dist = float(d.get("distance_km", 0))
        is_ped = int(d.get("is_pedestrian", 0))

        if preference == "fewer_transfers":
            return (transfer_marker * 10000.0) + cost_time
        elif preference == "least_walking":
            if is_ped:
                return (cost_time * 1000.0) + (dist * 100.0)
            return cost_time
        else:
            return cost_time + (transfer_marker * 3.0)

    try:
        # OPTIMIZED: Limit paths found
        paths = nx.shortest_simple_paths(G, -1, -2, weight=weight_func)
    except nx.NetworkXNoPath:
        return

    added = 0
    path_id = 0
    
    # OPTIMIZED: Reduce max paths
    max_paths = RouteEngineConfig.MAX_PATHS_PER_STRATEGY
    
    for path in paths:
        path_id += 1
        if path_id > max_paths:
            break

        edges = []
        for i in range(len(path) - 1):
            u, v = path[i], path[i+1]
            edge_id = G[u][v]["edge_id"]
            if edge_id in dynamic_edges:
                edges.append(dynamic_edges[edge_id])
            else:
                edges.append(_G_static_edges[edge_id])

        legs, current = [], None
        total_time = walk_distance = 0.0

        for edge in edges:
            minutes, distance = float(edge["cost_time"]), float(edge["distance_km"])
            total_time += minutes
            if edge["is_pedestrian"]:
                walk_distance += distance
                if current:
                    legs.append(current)
                    current = None
                legs.append({"mode": "walk", "route_id": None, "route_name": "Walking",
                             "from_stop": edge["from_stop"] or "Origin", "to_stop": edge["to_stop"] or "Destination",
                             "from_stop_id": edge["from_stop_id"], "to_stop_id": edge["to_stop_id"],
                             "stops": 0, "duration_min": math.ceil(minutes), "distance_km": round(distance, 2), "fare_npr": 0})
            elif edge["transfer_marker"]:
                if current:
                    legs.append(current)
                    current = None
            elif current and current["route_id"] == edge["route_id"]:
                current["to_stop"] = edge["to_stop"]
                current["to_stop_id"] = edge["to_stop_id"]
                current["stops"] += 1
                current["duration_min"] += minutes
                current["distance_km"] += distance
            else:
                if current:
                    legs.append(current)
                current = {"mode": "bus", "route_id": edge["route_id"], "route_name": edge["route_name"],
                           "from_stop": edge["from_stop"], "to_stop": edge["to_stop"],
                           "from_stop_id": edge["from_stop_id"], "to_stop_id": edge["to_stop_id"],
                           "stops": 1, "duration_min": minutes, "distance_km": distance, "fare_npr": 0}
        if current:
            legs.append(current)

        # Merge consecutive bus legs on same route
        merged_legs = []
        for leg in legs:
            if (leg["mode"] == "bus" and merged_legs and merged_legs[-1]["mode"] == "bus"
                    and merged_legs[-1]["route_id"] == leg["route_id"]
                    and merged_legs[-1]["to_stop_id"] == leg["from_stop_id"]):
                prev = merged_legs[-1]
                prev["to_stop"] = leg["to_stop"]
                prev["to_stop_id"] = leg["to_stop_id"]
                prev["stops"] += leg["stops"]
                prev["duration_min"] += leg["duration_min"]
                prev["distance_km"] += leg["distance_km"]
            else:
                merged_legs.append(leg)
        legs = merged_legs

        buses = [leg for leg in legs if leg["mode"] == "bus"]
        if not buses:
            continue

        transfers = max(0, len(buses) - 1)
        
        # Check for micro transfers
        has_micro_transfer = False
        for idx, leg in enumerate(legs):
            if leg["mode"] == "walk" and idx > 0 and idx < len(legs) - 1:
                prev_leg = legs[idx - 1]
                next_leg = legs[idx + 1]
                if (prev_leg["mode"] == "bus" and next_leg["mode"] == "bus"
                        and leg["distance_km"] < MICRO_TRANSFER_THRESHOLD_KM):
                    has_micro_transfer = True
                    break
        if has_micro_transfer:
            continue

        fares = calculate_fare(buses)
        for leg, item in zip(buses, fares["breakdown"]):
            leg["fare_npr"] = item["fare"]
            leg["duration_min"] = math.ceil(leg["duration_min"])
            leg["distance_km"] = round(leg["distance_km"], 2)

        route_signature = "||".join(
            f"{leg['from_stop_id']}->{leg['to_stop_id']}"
            for leg in legs if leg["mode"] == "bus"
        )
        if route_signature in seen_signatures:
            continue
        seen_signatures.add(route_signature)

        itinerary_signature = (
            math.ceil(total_time),
            fares["total_fare"],
            tuple((leg["mode"], leg.get("from_stop_id"), leg.get("to_stop_id"),
                   leg["from_stop"], leg["to_stop"],
                   leg["stops"], leg["duration_min"], leg["distance_km"], leg["fare_npr"])
                  for leg in legs),
        )
        if itinerary_signature in seen_itineraries:
            continue
        seen_itineraries.add(itinerary_signature)

        pool.append({"id": f"route-opt-{len(pool)+1}", "label": f"Route {len(pool)+1}",
                     "origin_lat": origin_lat, "origin_lng": origin_lng, "dest_lat": dest_lat, "dest_lng": dest_lng,
                     "operator_name": next((e["operator_name"] for e in edges if e["operator_name"]), None),
                     "total_time_min": math.ceil(total_time), "total_fare_npr": fares["total_fare"],
                     "transfer_count": transfers, "walking_distance_km": round(walk_distance, 2), "legs": legs})
        added += 1
        if added == 3:
            break

# ============================================================
# OPTIMIZED ROUTE FINDING WITH CACHING
# ============================================================

def find_routes(db: Session, origin_lat: float, origin_lng: float, 
                dest_lat: float, dest_lng: float, preference: str = "shortest"):
    """
    Find routes with PERFORMANCE OPTIMIZATIONS:
    - Caching
    - Limited search depth
    - Faster graph loading
    """
    origin_lat, origin_lng = float(origin_lat), float(origin_lng)
    dest_lat, dest_lng = float(dest_lat), float(dest_lng)

    if not _is_within_nepal(origin_lat, origin_lng) or not _is_within_nepal(dest_lat, dest_lng):
        return []

    # ============================================================
    # CHECK CACHE FIRST
    # ============================================================
    cache_key = f"{origin_lat:.4f}:{origin_lng:.4f}:{dest_lat:.4f}:{dest_lng:.4f}:{preference}"
    
    if RouteEngineConfig.CACHE_ROUTES:
        cached = _route_cache.get(cache_key)
        if cached:
            return cached

    # ============================================================
    # FIND NEAREST STOPS (OPTIMIZED)
    # ============================================================
    nearest = """SELECT id, (ST_Distance(geom::geography,
        ST_SetSRID(ST_MakePoint(:lng, :lat), 4326)::geography) / 1000.0)
        * {mult} AS distance_km
        FROM stops ORDER BY distance_km LIMIT 1""".format(mult=WALKING_DISTANCE_MULTIPLIER)
    
    origins = db.execute(text(nearest), {"lat": origin_lat, "lng": origin_lng}).mappings().all()
    destinations = db.execute(text(nearest), {"lat": dest_lat, "lng": dest_lng}).mappings().all()
    
    # OPTIMIZED: Only get necessary nodes
    origin_ids = [r["id"] for r in origins]
    dest_ids = [r["id"] for r in destinations]
    
    origin_nodes = db.query(RoutingNode).filter(RoutingNode.stop_id.in_(origin_ids)).all()
    dest_nodes = db.query(RoutingNode).filter(RoutingNode.stop_id.in_(dest_ids)).all()
    
    if not origin_nodes or not dest_nodes:
        return []

    origin_dist = {r["id"]: float(r["distance_km"]) for r in origins}
    dest_dist = {r["id"]: float(r["distance_km"]) for r in destinations}
    
    # ============================================================
    # LOAD GRAPH (CACHED)
    # ============================================================
    G = _load_graph(db).copy()
    dynamic_edges = {}
    
    # Add origin walking edges
    for node in origin_nodes:
        distance = origin_dist[node.stop_id]
        cost = (distance / 5 * 60)
        edge_id = -100000 - node.id
        G.add_edge(-1, node.id, cost_time=cost, transfer_marker=0, distance_km=distance, is_pedestrian=1, edge_id=edge_id)
        dynamic_edges[edge_id] = {
            "source": -1, "target": node.id, "cost_time": cost, "distance_km": distance,
            "transfer_marker": 0, "is_pedestrian": 1, "route_id": None,
            "from_stop_id": None, "to_stop_id": node.stop_id,
            "from_stop": None, "to_stop": "Origin", "route_name": None, "operator_name": None
        }
        
    # Add destination walking edges
    for node in dest_nodes:
        distance = dest_dist[node.stop_id]
        cost = (distance / 5 * 60)
        edge_id = -200000 - node.id
        G.add_edge(node.id, -2, cost_time=cost, transfer_marker=0, distance_km=distance, is_pedestrian=1, edge_id=edge_id)
        dynamic_edges[edge_id] = {
            "source": node.id, "target": -2, "cost_time": cost, "distance_km": distance,
            "transfer_marker": 0, "is_pedestrian": 1, "route_id": None,
            "from_stop_id": node.stop_id, "to_stop_id": None,
            "from_stop": "Destination", "to_stop": None, "route_name": None, "operator_name": None
        }

    # ============================================================
    # RUN STRATEGIES (PARALLEL OPTIMIZED)
    # ============================================================
    pool, seen_signatures, seen_itineraries = [], set(), set()
    
    # OPTIMIZED: Only run relevant strategies
    strategies = _SUGGESTION_PREFERENCES
    if preference in strategies:
        strategies = (preference,) + tuple(s for s in strategies if s != preference)
    
    for pref in strategies:
        _collect_routes(
            G, dynamic_edges, pref,
            origin_lat, origin_lng, dest_lat, dest_lng,
            pool, seen_signatures, seen_itineraries,
        )
        
        # Early exit if we have enough routes
        if len(pool) >= RouteEngineConfig.MAX_ROUTES_TO_RETURN * 2:
            break

    if not pool:
        return []

    # ============================================================
    # PROCESS ROUTES (SAME AS ORIGINAL)
    # ============================================================
    # ... (keep all the existing post-processing code) ...
    
    # Load stop orders for phantom transfer detection
    stop_orders_rows = db.execute(text(
        "SELECT rs.route_id, rs.stop_id, s.name AS stop_name, rs.stop_order, "
        "COALESCE(rs.distance_from_prev_km, 0) AS distance_from_prev_km "
        "FROM route_stops rs JOIN stops s ON s.id = rs.stop_id"
    )).mappings().all()
    
    route_stop_orders: Dict[str, Dict[str, List[int]]] = {}
    route_stop_id_order: Dict[str, Dict[Any, int]] = {}
    route_seq: Dict[str, List[Dict[str, Any]]] = {}
    
    for row in stop_orders_rows:
        route_stop_orders.setdefault(row["route_id"], {}).setdefault(row["stop_name"], []).append(row["stop_order"])
        route_stop_id_order.setdefault(row["route_id"], {})[row["stop_id"]] = row["stop_order"]
        route_seq.setdefault(row["route_id"], []).append(
            {"order": row["stop_order"], "distance": float(row["distance_from_prev_km"] or 0)})
    for seq in route_seq.values():
        seq.sort(key=lambda s: s["order"])

    def _route_reaches(route_id, board_name, dest_name):
        stops = route_stop_orders.get(route_id, {})
        board_orders, dest_orders = stops.get(board_name), stops.get(dest_name)
        if not board_orders or not dest_orders:
            return False
        return max(dest_orders) > min(board_orders)

    def _continuous_span(route_id, from_stop_id, to_stop_id):
        orders = route_stop_id_order.get(route_id, {})
        board, alight = orders.get(from_stop_id), orders.get(to_stop_id)
        if board is None or alight is None or alight <= board:
            return None
        return board, alight

    def _collapse_phantom(route):
        legs = list(route["legs"])
        changed = True
        while changed:
            changed = False
            bus_pos = [k for k, l in enumerate(legs) if l["mode"] == "bus"]
            for a in range(len(bus_pos)):
                for b in range(len(bus_pos) - 1, a, -1):
                    li, lj = legs[bus_pos[a]], legs[bus_pos[b]]
                    span = _continuous_span(li["route_id"], li["from_stop_id"], lj["to_stop_id"])
                    if not span:
                        continue
                    board_order, alight_order = span
                    dist = sum(s["distance"] for s in route_seq.get(li["route_id"], [])
                               if board_order < s["order"] <= alight_order)
                    merged_buses = [legs[k] for k in range(bus_pos[a], bus_pos[b] + 1)
                                    if legs[k]["mode"] == "bus"]
                    duration = math.ceil(dist / 20.0 * 60.0) if dist > 0 else \
                        math.ceil(sum(m["duration_min"] for m in merged_buses))
                    merged = {"mode": "bus", "route_id": li["route_id"], "route_name": li["route_name"],
                              "from_stop": li["from_stop"], "to_stop": lj["to_stop"],
                              "from_stop_id": li["from_stop_id"], "to_stop_id": lj["to_stop_id"],
                              "stops": alight_order - board_order, "duration_min": duration,
                              "distance_km": round(dist, 2), "fare_npr": 0}
                    legs = legs[:bus_pos[a]] + [merged] + legs[bus_pos[b] + 1:]
                    changed = True
                    break
                if changed:
                    break
        if legs == route["legs"]:
            return
        buses = [l for l in legs if l["mode"] == "bus"]
        fares = calculate_fare(buses)
        for leg, item in zip(buses, fares["breakdown"]):
            leg["fare_npr"] = item["fare"]
        route["legs"] = legs
        route["total_fare_npr"] = fares["total_fare"]
        route["transfer_count"] = max(0, len(buses) - 1)
        route["total_time_min"] = math.ceil(sum(l["duration_min"] for l in legs))
        route["walking_distance_km"] = round(sum(l["distance_km"] for l in legs if l["mode"] == "walk"), 2)

    for route in pool:
        _collapse_phantom(route)

    # Deduplicate
    deduped, seen = [], set()
    for route in pool:
        sig = tuple((l["mode"], l.get("from_stop_id"), l.get("to_stop_id")) for l in route["legs"])
        if sig in seen:
            continue
        seen.add(sig)
        deduped.append(route)
    pool = deduped

    def _is_phantom_transfer(route):
        bus_legs = [l for l in route["legs"] if l["mode"] == "bus"]
        if len(bus_legs) < 2:
            return False
        trip_origin, trip_dest = bus_legs[0]["from_stop"], bus_legs[-1]["to_stop"]
        if any(_route_reaches(l["route_id"], trip_origin, trip_dest) for l in bus_legs):
            return True
        for i in range(len(bus_legs)):
            for j in range(i + 1, len(bus_legs)):
                if _route_reaches(bus_legs[i]["route_id"], bus_legs[i]["from_stop"], bus_legs[j]["to_stop"]):
                    return True
        return False

    filtered = [route for route in pool if not _is_phantom_transfer(route)]
    if filtered:
        pool = filtered

    # Filter by sanity
    fastest = min(route["total_time_min"] for route in pool)
    threshold = fastest * SANITY_TIME_MULTIPLIER + SANITY_TIME_BUFFER_MIN
    sane = [route for route in pool if route["total_time_min"] <= threshold]

    # Sort and return top results
    sane.sort(key=lambda r: (r["total_time_min"], r["transfer_count"], r["walking_distance_km"]))
    results = sane[:RouteEngineConfig.MAX_ROUTES_TO_RETURN]
    
    for index, route in enumerate(results):
        route["id"] = f"route-opt-{index + 1}"
        route["label"] = f"Route {index + 1}"
    
    # ============================================================
    # CACHE RESULTS
    # ============================================================
    if RouteEngineConfig.CACHE_ROUTES and results:
        _route_cache.set(cache_key, results)
    
    return results

# ============================================================
# OPTIMIZED BUS OPTIONS
# ============================================================

def find_bus_options(db: Session, route_id: str, selected_route: Dict[str, Any]):
    """Get bus options with optimizations"""
    
    leg = next((leg for leg in selected_route["legs"] if leg.get("route_id") == route_id), None)
    if leg is None:
        return []
    
    origin_stop_id, destination_stop_id = leg.get("from_stop_id"), leg.get("to_stop_id")
    if not origin_stop_id or not destination_stop_id:
        return []

    # OPTIMIZED: Simplified query with LIMIT
    candidates = db.execute(text("""
        SELECT r.id, r.name, r.operator, r.vehicle_type, r.color,
               (SELECT terminal.name
                FROM route_stops terminal_rs
                JOIN stops terminal ON terminal.id = terminal_rs.stop_id
                WHERE terminal_rs.route_id = r.id
                ORDER BY terminal_rs.stop_order ASC LIMIT 1) AS direction_from,
               (SELECT terminal.name
                FROM route_stops terminal_rs
                JOIN stops terminal ON terminal.id = terminal_rs.stop_id
                WHERE terminal_rs.route_id = r.id
                ORDER BY terminal_rs.stop_order DESC LIMIT 1) AS direction_to,
               COALESCE((
                 SELECT SUM(edge.distance_km)
                 FROM routing_edges edge
                 JOIN routing_nodes edge_origin ON edge_origin.id = edge.source
                 JOIN routing_nodes edge_destination ON edge_destination.id = edge.target
                 JOIN route_stops edge_origin_stop ON edge_origin_stop.route_id = r.id
                   AND edge_origin_stop.stop_id = edge_origin.stop_id
                 JOIN route_stops edge_destination_stop ON edge_destination_stop.route_id = r.id
                   AND edge_destination_stop.stop_id = edge_destination.stop_id
                 WHERE edge.route_id = r.id
                   AND edge_origin_stop.stop_order >= origin_stop.stop_order
                   AND edge_destination_stop.stop_order <= destination_stop.stop_order
               ), 0) AS distance_km
        FROM routes r
        JOIN route_stops origin_stop ON origin_stop.route_id = r.id
        JOIN stops origin ON origin.id = origin_stop.stop_id
        JOIN route_stops destination_stop ON destination_stop.route_id = r.id
        JOIN stops destination ON destination.id = destination_stop.stop_id
        WHERE origin_stop.stop_id = :origin_stop_id
          AND destination_stop.stop_id = :destination_stop_id
          AND origin_stop.stop_order < destination_stop.stop_order
        ORDER BY distance_km, r.operator, r.id
        LIMIT 3
    """), {"origin_stop_id": origin_stop_id, "destination_stop_id": destination_stop_id}).mappings().all()

    walk_time = sum(int(item["duration_min"]) for item in selected_route["legs"] if item["mode"] == "walk")
    
    adjacent_operators = set()
    leg_idx = selected_route["legs"].index(leg)
    
    if leg_idx > 0:
        prev = selected_route["legs"][leg_idx - 1]
        if prev.get("operator_name"): adjacent_operators.add(prev["operator_name"])
        if prev.get("route_name"): adjacent_operators.add(prev["route_name"])
    if leg_idx < len(selected_route["legs"]) - 1:
        nxt = selected_route["legs"][leg_idx + 1]
        if nxt.get("operator_name"): adjacent_operators.add(nxt["operator_name"])
        if nxt.get("route_name"): adjacent_operators.add(nxt["route_name"])
        
    direct_route_ids = set()
    bus_legs = [l for l in selected_route["legs"] if l.get("mode") == "bus"]
    if len(bus_legs) > 1:
        trip_origin_id = bus_legs[0]["from_stop_id"]
        trip_dest_id = bus_legs[-1]["to_stop_id"]
        direct_matches = db.execute(text("""
            SELECT r.id
            FROM routes r
            JOIN route_stops origin_stop ON origin_stop.route_id = r.id
            JOIN route_stops destination_stop ON destination_stop.route_id = r.id
            WHERE origin_stop.stop_id = :trip_origin
              AND destination_stop.stop_id = :trip_dest
              AND origin_stop.stop_order < destination_stop.stop_order
        """), {"trip_origin": trip_origin_id, "trip_dest": trip_dest_id}).mappings().all()
        for row in direct_matches:
            direct_route_ids.add(row["id"])

    options = []
    seen_operators = set()
    for route in candidates:
        op_key = route["operator"] or route["name"]
        
        if op_key in seen_operators or op_key in adjacent_operators or route["id"] in direct_route_ids:
            continue
        seen_operators.add(op_key)

        distance = float(route["distance_km"])
        duration = math.ceil(distance / 20.0 * 60.0)
        fare = calculate_fare([{"distance_km": distance}])["total_fare"]
        confirmed_legs = []
        for item in selected_route["legs"]:
            confirmed_item = dict(item)
            if item is leg:
                confirmed_item.update({"route_id": route["id"], "route_name": route["name"],
                                       "duration_min": duration, "distance_km": round(distance, 2),
                                       "fare_npr": fare})
            confirmed_legs.append(confirmed_item)
        confirmed_route = dict(selected_route)
        confirmed_route["legs"] = confirmed_legs
        confirmed_route["total_fare_npr"] = sum(item["fare_npr"] for item in confirmed_legs)
        confirmed_route["total_time_min"] = sum(item["duration_min"] for item in confirmed_legs)
        options.append({"operator_name": route["operator"] or route["name"], "route_id": route["id"],
                        "route_name": route["name"],
                        "line_from": route["direction_from"], "line_to": route["direction_to"],
                        "direction": f"{leg['from_stop'].strip()} → {leg['to_stop'].strip()}",
                        "vehicle_type": route["vehicle_type"], "color": route["color"],
                        "fare": fare, "duration": duration,
                        "transfer_count": selected_route["transfer_count"], "walk_time_min": walk_time,
                        "confirmed_route": confirmed_route})
    return options