from app.database import SessionLocal
from app.services.routing_engine import find_routes, text
db = SessionLocal()
import math
origin_lat = 27.6725
origin_lng = 85.3140
dest_lat = 27.7032
dest_lng = 85.3121

stops = db.query(find_routes.__globals__['Stop']).all()
stop_distances_origin = []
stop_distances_dest = []
for stop in stops:
    d_orig = find_routes.__globals__['haversine_distance'](origin_lat, origin_lng, stop.latitude, stop.longitude)
    d_dest = find_routes.__globals__['haversine_distance'](dest_lat, dest_lng, stop.latitude, stop.longitude)
    stop_distances_origin.append((stop.id, d_orig, stop.name))
    stop_distances_dest.append((stop.id, d_dest, stop.name))
    
stop_distances_origin.sort(key=lambda x: x[1])
stop_distances_dest.sort(key=lambda x: x[1])

top_origin = stop_distances_origin[:3]
top_dest = stop_distances_dest[:3]

origin_stop_ids = [x[0] for x in top_origin]
dest_stop_ids = [x[0] for x in top_dest]

origin_nodes = db.query(find_routes.__globals__['RoutingNode']).filter(find_routes.__globals__['RoutingNode'].stop_id.in_(origin_stop_ids)).all()
dest_nodes = db.query(find_routes.__globals__['RoutingNode']).filter(find_routes.__globals__['RoutingNode'].stop_id.in_(dest_stop_ids)).all()

dynamic_edges = []
for node in origin_nodes:
    dist = next(d for s, d, n in top_origin if s == node.stop_id)
    time_min = dist / 5.0 * 60.0
    edge_id = -100 - node.id
    dynamic_edges.append(f"SELECT {edge_id} AS id, -1 AS source, {node.id} AS target, {time_min} AS cost_time, 0 AS cost_transfers, {dist} AS distance_km, 0 AS is_transfer, -1 AS reverse_cost, NULL::varchar AS route_id")
    
for node in dest_nodes:
    dist = next(d for s, d, n in top_dest if s == node.stop_id)
    time_min = dist / 5.0 * 60.0
    edge_id = -200 - node.id
    dynamic_edges.append(f"SELECT {edge_id} AS id, {node.id} AS source, -2 AS target, {time_min} AS cost_time, 0 AS cost_transfers, {dist} AS distance_km, 0 AS is_transfer, -1 AS reverse_cost, NULL::varchar AS route_id")

dynamic_edges_sql = " UNION ALL ".join(dynamic_edges)
cost_expr = "cost_time"
k_paths = 1

query = f"""
SELECT ksp.seq, ksp.path_id, ksp.path_seq, ksp.node, ksp.edge
FROM pgr_ksp(
    '
    SELECT id, source, target, {cost_expr} AS cost, reverse_cost FROM routing_edges
    UNION ALL
    SELECT id, source, target, {cost_expr} AS cost, reverse_cost FROM ({dynamic_edges_sql}) as dyn
    ',
    -1, -2, {k_paths}, directed:=true
) AS ksp
ORDER BY ksp.seq
"""
results = db.execute(text(query)).fetchall()
for r in results:
    print(dict(r._mapping))
