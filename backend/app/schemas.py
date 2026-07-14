from pydantic import BaseModel
from typing import List, Optional


class StopSchema(BaseModel):
    id: str
    name: str
    latitude: float
    longitude: float


class RouteMetaSchema(BaseModel):
    id: str
    name: str
    operator: Optional[str] = None
    vehicle_type: str = "bus"


class RouteLeg(BaseModel):
    mode: str
    route_id: Optional[str] = None
    route_name: Optional[str] = None
    from_stop: str
    to_stop: str
    stops: int
    duration_min: int
    distance_km: float
    fare_npr: int


class RouteSearchRequest(BaseModel):
    origin_lat: float
    origin_lng: float
    dest_lat: float
    dest_lng: float
    preference: str = "fastest"


class RouteSearchResult(BaseModel):
    id: str
    label: str
    operator_name: Optional[str] = None
    total_time_min: int
    total_fare_npr: int
    transfer_count: int
    walking_distance_km: float
    legs: List[RouteLeg]


class RouteSearchResponse(BaseModel):
    results: List[RouteSearchResult]
