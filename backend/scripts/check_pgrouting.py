import sys
import os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
from app.database import SessionLocal
from sqlalchemy import text

db = SessionLocal()
try:
    db.execute(text("CREATE EXTENSION IF NOT EXISTS pgrouting;"))
    db.commit()
    print("pgrouting extension created or already exists")
except Exception as e:
    print(f"Failed to create pgrouting extension: {e}")
finally:
    db.close()
