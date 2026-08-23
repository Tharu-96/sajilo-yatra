from fastapi import APIRouter, Depends, HTTPException, Query
from typing import List
from sqlalchemy import text
from sqlalchemy.orm import Session
from ..schemas import BusOptionsRequest, RouteSearchRequest, RouteSearchResponse, RouteSearchResult, RouteLeg
from ..database import get_db
from ..services.routing_engine import find_bus_options, find_routes

router = APIRouter()

@router.post("/search", response_model=RouteSearchResponse)
def search_routes(request: RouteSearchRequest, db: Session = Depends(get_db)):
    results = find_routes(
        db=db,
        origin_lat=request.origin_lat,
        origin_lng=request.origin_lng,
        dest_lat=request.dest_lat,
        dest_lng=request.dest_lng,
    )
    
    return RouteSearchResponse(
        results=results
    )


@router.post("/options")
def bus_options(request: BusOptionsRequest, db: Session = Depends(get_db)):
    return {"vehicles": find_bus_options(db, request.route_id, request.route.model_dump())}


@router.get("/{route_id}/geometry")
def route_geometry(
    route_id: str,
    from_stop: str = Query(...),
    to_stop: str = Query(...),
    db: Session = Depends(get_db),
):
    """Return the selected bus segment as its ordered stop coordinates.

    routing_edges has no geometry column, so route_stops/stops is the
    authoritative geometry source for the client polyline.
    """
    # Stop names can recur on a route. Select the shortest forward occurrence
    # rather than combining the first origin with the last destination, which
    # previously drew an unrelated loop segment on the map.
    bounds = db.execute(text("""
        SELECT origin.stop_order AS start_order, destination.stop_order AS end_order
        FROM route_stops origin
        JOIN stops origin_stop ON origin_stop.id = origin.stop_id
        JOIN route_stops destination ON destination.route_id = origin.route_id
          AND destination.stop_order >= origin.stop_order
        JOIN stops destination_stop ON destination_stop.id = destination.stop_id
        WHERE origin.route_id = :route_id
          AND origin_stop.name = :from_stop
          AND destination_stop.name = :to_stop
        ORDER BY destination.stop_order - origin.stop_order, origin.stop_order
        LIMIT 1
    """), {"route_id": route_id, "from_stop": from_stop, "to_stop": to_stop}).mappings().one_or_none()

    if bounds is None:
        raise HTTPException(status_code=404, detail="Route segment not found")

    points = db.execute(text("""
        SELECT s.name, s.latitude, s.longitude, rs.stop_order
        FROM route_stops rs
        JOIN stops s ON s.id = rs.stop_id
        WHERE rs.route_id = :route_id
          AND rs.stop_order BETWEEN :start_order AND :end_order
        ORDER BY rs.stop_order
    """), {
        "route_id": route_id,
        "start_order": bounds["start_order"],
        "end_order": bounds["end_order"],
    }).mappings().all()
    return {"points": [dict(point) for point in points]}
