from .database import SessionLocal, engine, Base
from .models import Stop, Route, RouteStop
from sqlalchemy import inspect, text
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def seed_db():
    logger.info("Creating tables...")
    Base.metadata.create_all(bind=engine)

    # create_all does not add new columns to existing tables. Keep this small
    # compatibility migration here until a dedicated migration tool is added.
    with engine.begin() as connection:
        columns = {column["name"] for column in inspect(engine).get_columns("users")}
        if "profile_image_filename" not in columns:
            connection.execute(
                text("ALTER TABLE users ADD COLUMN profile_image_filename VARCHAR(255)")
            )
    
    db = SessionLocal()
    
    try:
        logger.info("Creating indexes...")
        db.execute(text("CREATE INDEX IF NOT EXISTS idx_stops_name_lower ON stops(lower(name));"))
        db.commit()

        if db.query(Stop).first():
            logger.info("Database already seeded. Skipping.")
            return

        logger.info("Seeding stops...")
        stops = [
            Stop(id="S1", name="Ratnapark", latitude=27.7058, longitude=85.3148),
            Stop(id="S2", name="Tripureshwor", latitude=27.6946, longitude=85.3143),
            Stop(id="S3", name="Kalimati", latitude=27.6974, longitude=85.2974),
            Stop(id="S4", name="Kalanki", latitude=27.6931, longitude=85.2811),
            Stop(id="S5", name="Koteshwor", latitude=27.6811, longitude=85.3442),
            Stop(id="S6", name="Baneshwor", latitude=27.6922, longitude=85.3331),
            Stop(id="S7", name="Maitighar", latitude=27.6931, longitude=85.3217),
            Stop(id="S8", name="Putalisadak", latitude=27.7032, longitude=85.3214),
            Stop(id="S9", name="Jamal", latitude=27.7083, longitude=85.3150),
            Stop(id="S10", name="Lainchaur", latitude=27.7161, longitude=85.3148),
        ]
        db.add_all(stops)

        logger.info("Seeding routes...")
        routes = [
            Route(id="R1", name="Ring Road Express", operator="Mahanagar", vehicle_type="bus", color="#00E5B0"),
            Route(id="R2", name="City Core", operator="Sajha Yatayat", vehicle_type="bus", color="#6EFFCE"),
        ]
        db.add_all(routes)

        logger.info("Seeding route stops...")
        route_stops = [
            # R1: Ring Road
            RouteStop(route_id="R1", stop_id="S4", stop_order=1, distance_from_prev_km=0),
            RouteStop(route_id="R1", stop_id="S5", stop_order=2, distance_from_prev_km=8.5),
            
            # R2: City Core
            RouteStop(route_id="R2", stop_id="S1", stop_order=1, distance_from_prev_km=0),
            RouteStop(route_id="R2", stop_id="S2", stop_order=2, distance_from_prev_km=1.2),
            RouteStop(route_id="R2", stop_id="S3", stop_order=3, distance_from_prev_km=1.8),
            RouteStop(route_id="R2", stop_id="S4", stop_order=4, distance_from_prev_km=2.1),
        ]
        db.add_all(route_stops)

        db.commit()
        logger.info("Seeding complete.")
    
    except Exception as e:
        logger.error(f"Error seeding database: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    seed_db()
