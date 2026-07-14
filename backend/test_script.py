import sys
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.services.routing_engine import find_routes

engine = create_engine('sqlite:///d:/Saas product/sajilo-yatra/backend/sajilo_yatra.db')
Session = sessionmaker(bind=engine)
db = Session()

import json
try:
    results = find_routes(
        db=db,
        origin_lat=27.7058,
        origin_lng=85.3148,
        dest_lat=27.6931,
        dest_lng=85.2811,
        preference="fastest"
    )
    print("Success")
    print(json.dumps(results, indent=2))
except Exception as e:
    import traceback
    traceback.print_exc()
