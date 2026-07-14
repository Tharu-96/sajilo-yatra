from fastapi import APIRouter, Depends, Query
from typing import List
from sqlalchemy.orm import Session
from sqlalchemy import text
from ..database import get_db
from ..schemas import StopSchema

router = APIRouter()

@router.get("/nearby", response_model=List[StopSchema])
def get_nearby_stops(
    lat: float, 
    lng: float, 
    radius_meters: int = Query(100, description="Search radius in meters"),
    db: Session = Depends(get_db)
):
    if radius_meters not in [100, 200, 300, 400, 500]:
        radius_meters = 100
        
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
            longitude=row.longitude
        ) for row in results
    ]
