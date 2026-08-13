from sqlalchemy import Column, String, Text, Float, Integer, ForeignKey, DateTime
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from geoalchemy2 import Geometry
from .database import Base


class User(Base):
    __tablename__ = "users"
    id = Column(String(36), primary_key=True)
    name = Column(String(120), nullable=False)
    email = Column(String(255), unique=True, index=True, nullable=False)
    hashed_password = Column(String(255), nullable=False)
    reset_otp_hash = Column(String(255), nullable=True)
    reset_otp_expires_at = Column(DateTime(timezone=True), nullable=True)
    profile_image_filename = Column(String(255), nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())


class Stop(Base):
    __tablename__ = "stops"
    id = Column(String(100), primary_key=True)
    name = Column(Text, nullable=False)
    latitude = Column(Float, nullable=False)
    longitude = Column(Float, nullable=False)
    geom = Column(Geometry(geometry_type="POINT", srid=4326), nullable=True)

    route_stops = relationship("RouteStop", back_populates="stop")


class Route(Base):
    __tablename__ = "routes"
    id = Column(String(100), primary_key=True)
    name = Column(Text, nullable=False)
    operator = Column(Text)
    vehicle_type = Column(String(20), default="bus")
    color = Column(String(7))

    route_stops = relationship("RouteStop", back_populates="route", order_by="RouteStop.stop_order")


class RouteStop(Base):
    __tablename__ = "route_stops"
    id = Column(Integer, primary_key=True, autoincrement=True)
    route_id = Column(String(100), ForeignKey("routes.id"), nullable=False)
    stop_id = Column(String(100), ForeignKey("stops.id"), nullable=False)
    stop_order = Column(Integer, nullable=False)
    distance_from_prev_km = Column(Float, default=0.0)

    route = relationship("Route", back_populates="route_stops")
    stop = relationship("Stop", back_populates="route_stops")


class Transfer(Base):
    __tablename__ = "transfers"
    id = Column(Integer, primary_key=True, autoincrement=True)
    from_stop_id = Column(String(100), ForeignKey("stops.id"), nullable=False)
    to_stop_id = Column(String(100), ForeignKey("stops.id"), nullable=False)
    walking_time_min = Column(Integer, default=3)
    walking_distance_m = Column(Integer, default=200)


class RoutingNode(Base):
    __tablename__ = "routing_nodes"
    id = Column(Integer, primary_key=True, autoincrement=True)
    stop_id = Column(String(100), ForeignKey("stops.id"), nullable=False)
    route_id = Column(String(100), ForeignKey("routes.id"), nullable=True)
    lat = Column(Float, nullable=False)
    lon = Column(Float, nullable=False)


class RoutingEdge(Base):
    __tablename__ = "routing_edges"
    id = Column(Integer, primary_key=True, autoincrement=True)
    source = Column(Integer, ForeignKey("routing_nodes.id"), nullable=False)
    target = Column(Integer, ForeignKey("routing_nodes.id"), nullable=False)
    route_id = Column(String(100), ForeignKey("routes.id"), nullable=True)
    cost_time = Column(Float, nullable=False)
    cost_transfers = Column(Float, nullable=False)
    distance_km = Column(Float, nullable=False)
    is_transfer = Column(Integer, default=0)
    reverse_cost = Column(Float, default=-1.0)
