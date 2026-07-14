from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from .config import settings
from .routers import route_finder, stops
from .seed import seed_db

app = FastAPI(title="Sajilo Yatra API", description="Transit API for Kathmandu")

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(route_finder.router, prefix="/api/routes", tags=["Route Finder"])
app.include_router(stops.router, prefix="/api/stops", tags=["Stops"])

@app.on_event("startup")
def startup_event():
    print("Initializing database and seeding...")
    seed_db()
    print("Startup complete.")
