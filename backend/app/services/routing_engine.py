import math
from typing import List, Dict, Any, Tuple
from sqlalchemy.orm import Session
from sqlalchemy import text
from app.models import Stop, Route, RouteStop, RoutingNode
from app.services.fare_engine import calculate_fare

def find_routes(db: Session, origin_lat: float, origin_lng: float, dest_lat: float, dest_lng: float, preference: str):
    # Security requirement: explicitly cast to float to prevent SQL injection in UNION ALL string
    origin_lat = float(origin_lat)
    origin_lng = float(origin_lng)
    dest_lat = float(dest_lat)
    dest_lng = float(dest_lng)
    
    top_origin = db.execute(text("""
        SELECT id, ST_Distance(geom::geography, ST_SetSRID(ST_MakePoint(:lng, :lat), 4326)::geography) / 1000.0 as dist, name 
        FROM stops 
        ORDER BY dist LIMIT 3
    """), {"lng": origin_lng, "lat": origin_lat}).fetchall()
    
    top_dest = db.execute(text("""
        SELECT id, ST_Distance(geom::geography, ST_SetSRID(ST_MakePoint(:lng, :lat), 4326)::geography) / 1000.0 as dist, name 
        FROM stops 
        ORDER BY dist LIMIT 3
    """), {"lng": dest_lng, "lat": dest_lat}).fetchall()
    
    origin_stop_ids = [x[0] for x in top_origin]
    dest_stop_ids = [x[0] for x in top_dest]
    
    origin_nodes = db.query(RoutingNode).filter(RoutingNode.stop_id.in_(origin_stop_ids)).all()
    dest_nodes = db.query(RoutingNode).filter(RoutingNode.stop_id.in_(dest_stop_ids)).all()
    
    dynamic_edges = []
    
    for node in origin_nodes:
        dist = next(d for s, d, n in top_origin if s == node.stop_id)
        time_min = dist / 5.0 * 60.0
        edge_id = -100 - node.id
        dynamic_edges.append(f"SELECT {edge_id} AS id, -1 AS source, {node.id} AS target, {time_min} AS cost_time, 0 AS cost_transfers, {dist} AS distance_km, 0 AS is_transfer, -1 AS reverse_cost, NULL AS route_id")
        
    for node in dest_nodes:
        dist = next(d for s, d, n in top_dest if s == node.stop_id)
        time_min = dist / 5.0 * 60.0
        edge_id = -200 - node.id
        dynamic_edges.append(f"SELECT {edge_id} AS id, {node.id} AS source, -2 AS target, {time_min} AS cost_time, 0 AS cost_transfers, {dist} AS distance_km, 0 AS is_transfer, -1 AS reverse_cost, NULL AS route_id")
        
    dynamic_edges_sql = " UNION ALL ".join(dynamic_edges)
    if not dynamic_edges_sql:
        return []
        
    if preference == 'fewest_transfers':
        cost_expr = 'cost_time + (15 * is_transfer)'
    else:
        cost_expr = 'cost_time'
        
    k_paths = 15 if preference != 'least_walking' else 30
    
    query = f"""
    WITH all_edges AS (
        SELECT id, source, target, cost_time, cost_transfers, distance_km, is_transfer, reverse_cost, route_id FROM routing_edges
        UNION ALL
        {dynamic_edges_sql}
    )
    SELECT ksp.seq, ksp.path_id, ksp.path_seq, ksp.node, ksp.edge, ksp.cost, ksp.agg_cost,
           e.is_transfer, e.distance_km, e.cost_time,
           rn.route_id, rn.stop_id, s.name as stop_name,
           r.name as route_name
    FROM pgr_ksp(
        '
        SELECT id, source, target, {cost_expr} AS cost, reverse_cost FROM routing_edges
        UNION ALL
        SELECT id, source, target, {cost_expr} AS cost, reverse_cost FROM ({dynamic_edges_sql}) as dyn
        ',
        -1, -2, {k_paths}, directed:=true
    ) AS ksp
    LEFT JOIN all_edges e ON ksp.edge = e.id
    LEFT JOIN routing_nodes rn ON ksp.node = rn.id
    LEFT JOIN stops s ON rn.stop_id = s.id
    LEFT JOIN routes r ON e.route_id = r.id
    ORDER BY ksp.seq
    """
    
    results = db.execute(text(query)).fetchall()
    
    paths = {}
    for row in results:
        pid = row.path_id
        if pid not in paths:
            paths[pid] = []
        paths[pid].append(row)
        
    operators = ["Sajha Yatayat", "Nepal Yatayat", "Ridhi Siddhi"]
    seen_bus_patterns = set()
    evaluated_paths = []
    
    for path_id, rows in paths.items():
        walking_distance_km = 0.0
        transfer_count = 0
        total_time_min = 0.0
        legs = []
        
        current_bus_leg = None
        bus_pattern = []
        
        for i in range(len(rows) - 1):
            curr = rows[i]
            nxt = rows[i+1]
            
            is_walk = (curr.edge < 0)
            is_transfer = (curr.is_transfer == 1)
            dist_km = curr.distance_km or 0.0
            time_min = curr.cost_time or 0.0
            
            total_time_min += time_min
            transfer_count += (1 if is_transfer else 0)
            
            if is_walk:
                walking_distance_km += dist_km
                
                from_name = "Origin" if curr.node == -1 else curr.stop_name
                to_name = "Destination" if nxt.node == -2 else nxt.stop_name
                
                legs.append({
                    "mode": "walk",
                    "route_id": None,
                    "route_name": "Walking",
                    "from_stop": from_name,
                    "to_stop": to_name,
                    "stops": 0,
                    "duration_min": int(math.ceil(time_min)),
                    "distance_km": round(dist_km, 2),
                    "fare_npr": 0
                })
            elif is_transfer:
                if current_bus_leg:
                    legs.append(current_bus_leg)
                    current_bus_leg = None
            else:
                if not current_bus_leg:
                    current_bus_leg = {
                        "mode": "bus",
                        "route_id": curr.route_id,
                        "route_name": curr.route_name,
                        "from_stop": curr.stop_name,
                        "to_stop": nxt.stop_name,
                        "stops": 1,
                        "duration_min": time_min,
                        "distance_km": dist_km,
                        "fare_npr": 0
                    }
                    bus_pattern.append(curr.route_id)
                else:
                    current_bus_leg['to_stop'] = nxt.stop_name
                    current_bus_leg['stops'] += 1
                    current_bus_leg['duration_min'] += time_min
                    current_bus_leg['distance_km'] += dist_km
                    
        if current_bus_leg:
            legs.append(current_bus_leg)
            
        pattern_tuple = tuple(bus_pattern)
        if not pattern_tuple or pattern_tuple in seen_bus_patterns:
            continue
        seen_bus_patterns.add(pattern_tuple)
        
        bus_legs_for_fare = [{"distance_km": l["distance_km"]} for l in legs if l["mode"] == "bus"]
        fare_result = calculate_fare(bus_legs_for_fare)
        
        fare_idx = 0
        for l in legs:
            if l["mode"] == "bus":
                l["fare_npr"] = fare_result["breakdown"][fare_idx]["fare"]
                l["duration_min"] = int(math.ceil(l["duration_min"]))
                l["distance_km"] = round(l["distance_km"], 2)
                fare_idx += 1
                
        evaluated_paths.append({
            "id": f"route-opt-{len(seen_bus_patterns)}",
            "label": preference.replace("_", " ").title(),
            "operator_name": operators[(len(seen_bus_patterns) - 1) % 3],
            "total_time_min": int(math.ceil(total_time_min)),
            "total_fare_npr": fare_result["total_fare"],
            "transfer_count": transfer_count,
            "walking_distance_km": round(walking_distance_km, 2),
            "legs": legs
        })
        
        if preference != 'least_walking' and len(evaluated_paths) >= 3:
            break
            
    if preference == 'least_walking':
        evaluated_paths.sort(key=lambda x: x['walking_distance_km'])
        evaluated_paths = evaluated_paths[:3]
        
    return evaluated_paths
