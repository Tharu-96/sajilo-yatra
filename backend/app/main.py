from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from .config import settings
from .routers import auth, feedback, route_finder, stops
from .seed import seed_db

app = FastAPI(title="Sajilo Yatra API", description="Transit API for Kathmandu")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], # Render/Vercel safe
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/health", tags=["System"])
def health_check():
    return {"status": "ok", "message": "Sajilo Yatra API is running"}

app.include_router(route_finder.router, prefix="/api/routes", tags=["Route Finder"])
app.include_router(stops.router, prefix="/api/stops", tags=["Stops"])
app.include_router(feedback.router, prefix="/api/feedback", tags=["Feedback"])
app.include_router(auth.router, prefix="/api/auth", tags=["Authentication"])

@app.on_event("startup")
def startup_event():
    print("Initializing database and seeding...")
    seed_db()
    print("Startup complete.")
