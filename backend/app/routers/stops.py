from fastapi import APIRouter, Depends, HTTPException, Query
from typing import List
from sqlalchemy.orm import Session
from sqlalchemy import text, func
from ..database import get_db
from ..models import Stop, RouteStop
from ..schemas import StopSchema, StopDetailSchema, RouteMetaSchema

router = APIRouter()


@router.get("/resolve", response_model=StopSchema)
def resolve_stop(name: str, db: Session = Depends(get_db)):
    """Return a stop only when its name exists in the transit database."""
    normalized_name = name.strip()
    if not normalized_name:
        raise HTTPException(status_code=404, detail="Stop not found")

    stop = (
        db.query(Stop)
        .filter(Stop.name.ilike(normalized_name))
        .first()
    )

    if stop is None:
        raise HTTPException(status_code=404, detail="Stop not found")

    return StopSchema(
        id=stop.id,
        name=stop.name,
        latitude=stop.latitude,
        longitude=stop.longitude,
    )

@router.get("/nearby", response_model=List[StopSchema])
def get_nearby_stops(
    lat: float, 
    lng: float, 
    radius_meters: int = Query(100, description="Search radius in meters"),
    db: Session = Depends(get_db)
):
    radius_meters = max(50, min(radius_meters, 5000))
        
    query = text("""
        SELECT id, name, latitude, longitude
        FROM stops
        WHERE ST_DWithin(
            geom::geography, 
            ST_SetSRID(ST_MakePoint(:lng, :lat), 4326)::geography, 
            :radius
        )
    """)
    
    results = db.execute(query, {"lng": lng, "lat": lat, "radius": radius_meters}).fetchall()
    
    return [
        StopSchema(
            id=row.id,
            name=row.name,
            latitude=row.latitude,
            longitude=row.longitude,
        ) for row in results
    ]


@router.get("/search", response_model=List[StopSchema])
def search_stops(
    q: str = Query(..., min_length=1, description="Prefix to search for"),
    limit: int = Query(10, description="Max results to return"),
    db: Session = Depends(get_db)
):
    query_text = q.lower().strip()
    
    stops = (
        db.query(Stop)
        .filter(func.lower(Stop.name).like(f"{query_text}%"))
        .limit(limit)
        .all()
    )
    
    return [
        StopSchema(
            id=stop.id,
            name=stop.name,
            latitude=stop.latitude,
            longitude=stop.longitude
        ) for stop in stops
    ]


@router.get("/{stop_id}", response_model=StopDetailSchema)
def get_stop_detail(stop_id: str, db: Session = Depends(get_db)):
    """Return a stop with every route that serves it."""
    stop = db.query(Stop).filter(Stop.id == stop_id).first()
    if stop is None:
        raise HTTPException(status_code=404, detail="Stop not found")

    seen: set = set()
    unique_routes: list = []
    for rs in db.query(RouteStop).filter(RouteStop.stop_id == stop_id).all():
        if rs.route and rs.route.id not in seen:
            seen.add(rs.route.id)
            r = rs.route
            unique_routes.append(RouteMetaSchema(
                id=r.id,
                name=r.name,
                operator=r.operator,
                vehicle_type=r.vehicle_type,
            ))

    return StopDetailSchema(
        id=stop.id,
        name=stop.name,
        latitude=stop.latitude,
        longitude=stop.longitude,
        routes=unique_routes,
    )
