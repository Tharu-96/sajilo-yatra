from pydantic import BaseModel, Field, EmailStr
from typing import List, Optional, Literal


class UserCreate(BaseModel):
    name: str = Field(min_length=1, max_length=120)
    email: EmailStr
    password: str = Field(min_length=6, max_length=128)


class UserLogin(BaseModel):
    email: EmailStr
    password: str = Field(min_length=1, max_length=128)


class UserOut(BaseModel):
    id: str
    name: str
    email: EmailStr


class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user: UserOut


class ForgotPasswordRequest(BaseModel):
    email: EmailStr


class ResetPasswordRequest(BaseModel):
    email: EmailStr
    otp: str = Field(min_length=4, max_length=10)
    new_password: str = Field(min_length=6, max_length=128)


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


class StopDetailSchema(BaseModel):
    id: str
    name: str
    latitude: float
    longitude: float
    routes: List[RouteMetaSchema]


class RouteLeg(BaseModel):
    mode: str
    route_id: Optional[str] = None
    route_name: Optional[str] = None
    from_stop: str
    to_stop: str
    # Names are display data and are not unique in the stop catalogue.  Keep
    # the graph's stop IDs so downstream choices can match the exact segment.
    from_stop_id: Optional[str] = None
    to_stop_id: Optional[str] = None
    stops: int
    duration_min: int
    distance_km: float
    fare_npr: int


class RouteSearchRequest(BaseModel):
    origin_lat: float
    origin_lng: float
    dest_lat: float
    dest_lng: float
    preference: Literal["shortest", "fewer_transfers", "least_walking"] = "shortest"


class RouteSearchResult(BaseModel):
    id: str
    label: str
    origin_lat: float
    origin_lng: float
    dest_lat: float
    dest_lng: float
    origin_lat: float
    origin_lng: float
    dest_lat: float
    dest_lng: float
    operator_name: Optional[str] = None
    total_time_min: int
    total_fare_npr: int
    transfer_count: int
    walking_distance_km: float
    legs: List[RouteLeg]


class RouteSearchResponse(BaseModel):
    results: List[RouteSearchResult]


class BusOptionsRequest(BaseModel):
    route_id: str
    route: RouteSearchResult


class FeedbackRequest(BaseModel):
    subject: str = Field(min_length=1, max_length=100)
    message: str = Field(min_length=1, max_length=5000)
