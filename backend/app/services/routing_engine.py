import math
from typing import List, Dict, Any, Tuple
from sqlalchemy.orm import Session
from sqlalchemy import text
from app.models import Stop, Route, RouteStop, RoutingNode
from app.services.fare_engine import calculate_fare


# Manhattan distance multiplier: straight-line distances are multiplied by
# this factor to approximate real city-block walking paths.  1.3 is the
# standard urban planning heuristic.
WALKING_DISTANCE_MULTIPLIER = 1.3

# Minimum walking distance (km) between consecutive bus legs.  Transfers
# shorter than this are considered "micro-transfers" and discarded because
# they indicate the algorithm is hopping between overlapping routes for a
# negligible time saving.
MICRO_TRANSFER_THRESHOLD_KM = 0.2


def _preference_cost(preference: str) -> str:
    """All preferences use pgr_ksp; only the cost expression differs."""
    costs = {
        # cost_time captures transit, walking, and transfer duration. Fare is
        # deliberately excluded from routing decisions.
        # A small nuisance penalty (+3 min per transfer) prevents the
        # algorithm from suggesting chaotic multi-bus trips just to save
        # a few seconds over a simpler itinerary.
        "shortest": "cost_time + (transfer_marker * 3.0)",
        "fewer_transfers": "(transfer_marker * 10000.0) + cost_time",
        "least_walking": "CASE WHEN is_pedestrian = 1 THEN (cost_time * 1000.0) + (distance_km * 100.0) ELSE cost_time END",
    }
    return costs.get(preference, costs["shortest"])


# Nepal bounding box — coordinates outside this region are rejected
# immediately to avoid wasting database resources on nonsensical queries.
_NEPAL_BOUNDS = {
    "lat_min": 26.347,
    "lat_max": 30.447,
    "lng_min": 80.058,
    "lng_max": 88.201,
}


def _is_within_nepal(lat: float, lng: float) -> bool:
    """Return True if the coordinate falls inside Nepal's bounding box."""
    return (_NEPAL_BOUNDS["lat_min"] <= lat <= _NEPAL_BOUNDS["lat_max"]
            and _NEPAL_BOUNDS["lng_min"] <= lng <= _NEPAL_BOUNDS["lng_max"])


def find_routes(db: Session, origin_lat: float, origin_lng: float, dest_lat: float, dest_lng: float, preference: str):
    origin_lat, origin_lng = float(origin_lat), float(origin_lng)
    dest_lat, dest_lng = float(dest_lat), float(dest_lng)

    # Reject coordinates outside Nepal early.
    if not _is_within_nepal(origin_lat, origin_lng) or not _is_within_nepal(dest_lat, dest_lng):
        return []
    nearest = """SELECT id, (ST_Distance(geom::geography,
        ST_SetSRID(ST_MakePoint(:lng, :lat), 4326)::geography) / 1000.0)
        * {mult} AS distance_km
        FROM stops ORDER BY distance_km LIMIT 1""".format(mult=WALKING_DISTANCE_MULTIPLIER)
    origins = db.execute(text(nearest), {"lat": origin_lat, "lng": origin_lng}).mappings().all()
    destinations = db.execute(text(nearest), {"lat": dest_lat, "lng": dest_lng}).mappings().all()
    origin_nodes = db.query(RoutingNode).filter(RoutingNode.stop_id.in_([r["id"] for r in origins])).all()
    dest_nodes = db.query(RoutingNode).filter(RoutingNode.stop_id.in_([r["id"] for r in destinations])).all()
    if not origin_nodes or not dest_nodes:
        return []

    origin_dist = {r["id"]: float(r["distance_km"]) for r in origins}
    dest_dist = {r["id"]: float(r["distance_km"]) for r in destinations}
    dynamic_edges = []
    for node in origin_nodes:
        distance = origin_dist[node.stop_id]  # already multiplied by Manhattan factor via SQL
        dynamic_edges.append(f"SELECT {-100000-node.id} id, -1 source, {node.id} target, {distance / 5 * 60} cost_time, {distance} distance_km, 0 transfer_marker, 1 is_pedestrian, -1.0 reverse_cost, NULL::varchar route_id")
    for node in dest_nodes:
        distance = dest_dist[node.stop_id]  # already multiplied by Manhattan factor via SQL
        dynamic_edges.append(f"SELECT {-200000-node.id} id, {node.id} source, -2 target, {distance / 5 * 60} cost_time, {distance} distance_km, 0 transfer_marker, 1 is_pedestrian, -1.0 reverse_cost, NULL::varchar route_id")
    dynamic_sql = " UNION ALL ".join(dynamic_edges)
    # transfers identifies real cross-stop walk transfers, while is_transfer
    # retains the same-stop route-change edges built in the graph.
    static_sql = """SELECT e.id, e.source, e.target, e.cost_time, e.distance_km,
        CASE WHEN e.is_transfer = 1 OR EXISTS (
          SELECT 1 FROM transfers t JOIN routing_nodes sn ON sn.id = e.source
          JOIN routing_nodes tn ON tn.id = e.target
          WHERE t.from_stop_id = sn.stop_id AND t.to_stop_id = tn.stop_id
        ) THEN 1 ELSE 0 END transfer_marker,
        -- A same-stop route change has no physical walking distance.  Only
        -- cross-stop transfer edges are pedestrian movement; treating every
        -- transfer as walking made least_walking optimise transfer wait time.
        CASE WHEN e.is_transfer = 1 AND e.distance_km > 0 THEN 1 ELSE 0 END is_pedestrian,
        e.reverse_cost, e.route_id FROM routing_edges e
        WHERE e.is_transfer = 1
           OR (e.source <> e.target AND e.cost_time > 0 AND e.distance_km >= 0)"""
    graph_sql = f"{static_sql} UNION ALL {dynamic_sql}"
    cost = _preference_cost(preference)
    # pgr_ksp may yield several graph-level variations that collapse to the
    # same user-facing itinerary.  Request a larger candidate set, then keep
    # only distinct rendered itineraries below.
    candidate_path_count = 30
    query = f"""
      SELECT k.path_id, k.path_seq, e.source, e.target, e.cost_time, e.distance_km, e.transfer_marker, e.is_pedestrian,
             e.route_id, ss.id from_stop_id, ts.id to_stop_id,
             ss.name from_stop, ts.name to_stop, r.name route_name, r.operator operator_name
      FROM pgr_ksp($$SELECT id, source, target, {cost} cost, reverse_cost FROM ({graph_sql}) graph$$,
                   -1, -2, {candidate_path_count}, directed := true) k
      JOIN ({graph_sql}) e ON e.id = k.edge
      LEFT JOIN routing_nodes sn ON sn.id = e.source
      LEFT JOIN routing_nodes tn ON tn.id = e.target
      LEFT JOIN stops ss ON ss.id = sn.stop_id
      LEFT JOIN stops ts ON ts.id = tn.stop_id
      LEFT JOIN routes r ON r.id = e.route_id
      ORDER BY k.path_id, k.path_seq
    """
    rows = db.execute(text(query)).mappings().all()
    grouped = {}
    for row in rows:
        grouped.setdefault(row["path_id"], []).append(row)

    results, seen_signatures, seen_itineraries = [], set(), set()
    for path_edges in grouped.values():
        # pgr_ksp's edge rows are not guaranteed to be emitted in travel order
        # when the graph includes the synthetic start/end nodes. Re-chain them.
        edges, remaining, node = [], list(path_edges), -1
        while remaining:
            index = next((i for i, edge in enumerate(remaining) if edge["source"] == node), None)
            if index is None:
                edges.extend(remaining)
                break
            edge = remaining.pop(index)
            edges.append(edge)
            node = edge["target"]
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
                # Same-stop vehicle changes are transfers, not a bus leg and
                # not physical walking.  Keep the count but omit the phantom
                # route_id=None leg from the response.
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
        buses = [leg for leg in legs if leg["mode"] == "bus"]
        if not buses:
            continue

        # --- Fix 2: Derive transfer count from actual bus legs, not graph
        # markers.  This eliminates double-counting at complex junctions
        # where the graph encodes a cross-stop walk AND a route-change as
        # two separate transfer_marker = 1 edges.
        transfers = max(0, len(buses) - 1)

        # --- Fix 4: Reject micro-transfers.  If the itinerary contains a
        # walk leg shorter than the threshold sandwiched between two bus
        # legs, the route is an impractical "hop-off-hop-on" artifact of
        # the graph and should be discarded.
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

        # Primary dedup: route_signature collapses paths that traverse the
        # same ordered sequence of bus-leg stop pairs regardless of the
        # underlying pgr_ksp edge set.
        route_signature = "||".join(
            f"{leg['from_stop_id']}->{leg['to_stop_id']}"
            for leg in legs if leg["mode"] == "bus"
        )
        if route_signature in seen_signatures:
            continue
        seen_signatures.add(route_signature)

        # Secondary guard: filters alternate edge encodings that happen to
        # produce identical rendered itineraries.
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
        results.append({"id": f"route-opt-{len(results)+1}", "label": preference.replace("_", " ").title(), "origin_lat": origin_lat, "origin_lng": origin_lng, "dest_lat": dest_lat, "dest_lng": dest_lng, "operator_name": next((e["operator_name"] for e in edges if e["operator_name"]), None), "total_time_min": math.ceil(total_time), "total_fare_npr": fares["total_fare"], "transfer_count": transfers, "walking_distance_km": round(walk_distance, 2), "legs": legs})
        if len(results) == 3:
            break
    return results[:3]


def find_bus_options(db: Session, route_id: str, selected_route: Dict[str, Any]):
    """Find every real operator route that serves the selected directed leg."""
    leg = next((leg for leg in selected_route["legs"] if leg.get("route_id") == route_id), None)
    if leg is None:
        return []
    origin_stop_id, destination_stop_id = leg.get("from_stop_id"), leg.get("to_stop_id")
    # Older clients did not send the IDs.  Returning no alternatives is safer
    # than matching identically named but unrelated stops.
    if not origin_stop_id or not destination_stop_id:
        return []

    # Matching both ordered stops finds all services across operators that cover
    # the selected stop-pair/segment, rather than only the KSP-selected route.
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
    options = []
    seen_operators = set()
    for route in candidates:
        # Deduplicate by operator: keep only the first (shortest-distance)
        # entry per operator covering this stop pair.
        op_key = route["operator"] or route["name"]
        if op_key in seen_operators:
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
                        "direction": f"{leg['from_stop'].strip()} → {leg['to_stop'].strip()}",
                        "vehicle_type": route["vehicle_type"], "color": route["color"],
                        "fare": fare, "duration": duration,
                        "transfer_count": selected_route["transfer_count"], "walk_time_min": walk_time,
                        "confirmed_route": confirmed_route})
    return options
