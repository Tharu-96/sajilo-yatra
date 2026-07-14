"""Quick verification of the imported data."""
import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

from sqlalchemy import text
from app.database import SessionLocal

db = SessionLocal()

# Sample stops with geometry
print("=== Sample stops ===")
rows = db.execute(text("SELECT id, name, ST_AsText(geom), latitude, longitude FROM stops LIMIT 5"))
for row in rows:
    print(row)

# Check GiST index
print("\n=== Indexes on stops ===")
rows = db.execute(text("SELECT indexname, indexdef FROM pg_indexes WHERE tablename = 'stops'"))
for row in rows:
    print(row)

# Counts
print("\n=== Row counts ===")
for table in ["stops", "routes", "route_stops"]:
    count = db.execute(text(f"SELECT COUNT(*) FROM {table}")).scalar()
    print(f"  {table}: {count}")

db.close()
