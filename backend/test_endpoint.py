import asyncio
from app.schemas import RouteSearchRequest
from app.routers.route_finder import search_routes
from app.database import get_db

req = RouteSearchRequest(
    origin_lat=27.7058,
    origin_lng=85.3148,
    dest_lat=27.6931,
    dest_lng=85.2811,
    preference="fastest"
)

db = next(get_db())
try:
    res = search_routes(req, db)
    print("Success")
except Exception as e:
    import traceback
    traceback.print_exc()
