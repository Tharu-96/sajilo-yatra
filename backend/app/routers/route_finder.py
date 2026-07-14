from fastapi import APIRouter, Depends
from typing import List
from sqlalchemy.orm import Session
from ..schemas import RouteSearchRequest, RouteSearchResponse, RouteSearchResult, RouteLeg
from ..database import get_db
from ..services.routing_engine import find_routes

router = APIRouter()

@router.post("/search", response_model=RouteSearchResponse)
def search_routes(request: RouteSearchRequest, db: Session = Depends(get_db)):
    results = find_routes(
        db=db,
        origin_lat=request.origin_lat,
        origin_lng=request.origin_lng,
        dest_lat=request.dest_lat,
        dest_lng=request.dest_lng,
        preference=request.preference
    )
    
    return RouteSearchResponse(
        results=results
    )
