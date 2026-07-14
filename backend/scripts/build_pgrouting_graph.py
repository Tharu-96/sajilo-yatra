"""
Build routing_nodes and routing_edges tables for pgRouting.
"""

import sys
import os
import logging
import math

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

from sqlalchemy import text
from app.database import engine, SessionLocal, Base
from app.models import Stop, Route, RouteStop, RoutingNode, RoutingEdge

logging.basicConfig(level=logging.INFO, format="%(levelname)s: %(message)s")
logger = logging.getLogger(__name__)

def haversine_distance(lat1: float, lon1: float, lat2: float, lon2: float) -> float:
    R = 6371.0
    dlat = math.radians(lat2 - lat1)
    dlon = math.radians(lon2 - lon1)
    a = (math.sin(dlat / 2)**2 + 
         math.cos(math.radians(lat1)) * math.cos(math.radians(lat2)) * math.sin(dlon / 2)**2)
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
    return R * c

def build_graph():
    db = SessionLocal()
    try:
        # Create the new tables if they don't exist
        Base.metadata.create_all(bind=engine)
        
        # Clear existing routing data
        db.execute(text("TRUNCATE routing_edges, routing_nodes RESTART IDENTITY CASCADE"))
        db.commit()

        stops = {s.id: s for s in db.query(Stop).all()}
        routes = db.query(Route).all()

        # Build nodes for every (stop, route)
        logger.info("Building nodes...")
        stop_to_routes = {}
        node_map = {} # (stop_id, route_id) -> node_id
        
        nodes_to_insert = []
        for route in routes:
            for rs in route.route_stops:
                stop_id = rs.stop_id
                if (stop_id, route.id) not in node_map:
                    stop = stops[stop_id]
                    node = RoutingNode(
                        stop_id=stop_id,
                        route_id=route.id,
                        lat=stop.latitude,
                        lon=stop.longitude
                    )
                    db.add(node)
                    db.flush() # get ID
                    node_map[(stop_id, route.id)] = node.id
                    stop_to_routes.setdefault(stop_id, []).append(route.id)

        logger.info(f"Created {len(node_map)} nodes.")

        # Build route edges
        logger.info("Building route edges...")
        edges_to_insert = []
        for route in routes:
            r_stops = sorted(route.route_stops, key=lambda rs: rs.stop_order)
            for i in range(len(r_stops) - 1):
                curr_rs = r_stops[i]
                next_rs = r_stops[i + 1]

                source_id = node_map[(curr_rs.stop_id, route.id)]
                target_id = node_map[(next_rs.stop_id, route.id)]

                dist = next_rs.distance_from_prev_km
                if not dist:
                    s1 = stops[curr_rs.stop_id]
                    s2 = stops[next_rs.stop_id]
                    dist = haversine_distance(s1.latitude, s1.longitude, s2.latitude, s2.longitude)

                time_min = dist / 20.0 * 60.0

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

        # Build transfer edges (cliques at each stop)
        logger.info("Building transfer edges...")
        for stop_id, r_ids in stop_to_routes.items():
            for i in range(len(r_ids)):
                for j in range(len(r_ids)):
                    if i != j:
                        source_id = node_map[(stop_id, r_ids[i])]
                        target_id = node_map[(stop_id, r_ids[j])]
                        
                        edges_to_insert.append(RoutingEdge(
                            source=source_id,
                            target=target_id,
                            route_id=None,
                            cost_time=3.0,
                            cost_transfers=1,
                            distance_km=0.0,
                            is_transfer=1,
                            reverse_cost=-1.0
                        ))

        db.add_all(edges_to_insert)
        db.commit()
        logger.info(f"Inserted {len(edges_to_insert)} edges.")

    except Exception as e:
        db.rollback()
        logger.error(f"Failed to build graph: {e}", exc_info=True)
    finally:
        db.close()

if __name__ == "__main__":
    build_graph()
