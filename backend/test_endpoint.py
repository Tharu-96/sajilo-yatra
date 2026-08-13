import traceback
from app.schemas import RouteSearchRequest, BusOptionsRequest
from app.routers.route_finder import search_routes, bus_options
from app.database import get_db

req = RouteSearchRequest(
    origin_lat=27.7058,
    origin_lng=85.3148,
    dest_lat=27.6931,
    dest_lng=85.2811,
    preference="shortest"
)

db = next(get_db())
try:
    print("--- Testing Route Search (Dedup) ---")
    res = search_routes(req, db)
    
    signatures = []
    for route in res.results:
        sig = "||".join(f"{leg.from_stop_id}->{leg.to_stop_id}" for leg in route.legs if leg.mode == "bus")
        signatures.append(sig)
        print(f"Route: {route.id} | Label: {route.label} | Time: {route.total_time_min} | Fare: {route.total_fare_npr}")
        print(f"  Signature: {sig}")
        
    print(f"\nUnique signatures: {len(set(signatures))} out of {len(signatures)} routes returned")
    if len(set(signatures)) != len(signatures):
        print("FAIL: Duplicate route signatures found!")
    else:
        print("PASS: Route search dedup working.")

    if res.results:
        print("\n--- Testing Bus Options (Dedup) ---")
        first_route = res.results[0]
        # find the first bus leg to get its route_id
        bus_leg = next((leg for leg in first_route.legs if leg.mode == "bus"), None)
        
        if bus_leg:
            bus_req = BusOptionsRequest(
                route_id=bus_leg.route_id,
                route=first_route
            )
            options = bus_options(bus_req, db)
            
            operators = []
            for vehicle in options.get("vehicles", []):
                op = vehicle.get("operator_name")
                operators.append(op)
                print(f"Option: {op} | Fare: {vehicle.get('fare')} | Time: {vehicle.get('duration')}")
                
            print(f"\nUnique operators: {len(set(operators))} out of {len(operators)} options returned")
            if len(set(operators)) != len(operators):
                print("FAIL: Duplicate operators found in bus options!")
            else:
                print("PASS: Bus options dedup working.")
        else:
            print("No bus leg found in route, skipping bus options test.")
        
except Exception as e:
    traceback.print_exc()
