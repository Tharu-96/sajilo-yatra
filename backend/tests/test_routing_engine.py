import pytest
from fastapi.testclient import TestClient
from app.main import app
from app.database import SessionLocal

client = TestClient(app)

# Coordinates for testing (e.g., origin: near Jawalakhel, dest: near RNAC)
# Jawalakhel roughly: 27.6725, 85.3140
# RNAC roughly: 27.7032, 85.3121
ORIGIN_LAT = 27.6725
ORIGIN_LNG = 85.3140
DEST_LAT = 27.7032
DEST_LNG = 85.3121

def verify_response_structure(response_data):
    """Asserts that the response matches the expected structure and has 3 options."""
    assert "results" in response_data, "Response missing 'results' key"
    results = response_data["results"]
    assert len(results) > 0, "No routes found, expected 3"
    assert len(results) <= 3, f"Expected up to 3 routes, got {len(results)}"
    
    for route in results:
        assert "id" in route
        assert "label" in route
        assert "operator_name" in route
        assert "total_time_min" in route
        assert "total_fare_npr" in route
        assert "transfer_count" in route
        assert "walking_distance_km" in route
        assert "legs" in route
        assert len(route["legs"]) > 0
        
        for leg in route["legs"]:
            assert "mode" in leg
            assert leg["mode"] in ["walk", "bus"]
            assert "from_stop" in leg
            assert "to_stop" in leg
            assert "duration_min" in leg
            assert "distance_km" in leg
            
            if leg["mode"] == "walk":
                assert leg["route_id"] is None
            else:
                assert leg["route_id"] is not None
                assert leg["route_name"] is not None
                assert leg["fare_npr"] is not None

def test_fastest_route():
    req = {
        "origin_lat": ORIGIN_LAT,
        "origin_lng": ORIGIN_LNG,
        "dest_lat": DEST_LAT,
        "dest_lng": DEST_LNG,
        "preference": "fastest"
    }
    response = client.post("/api/routes/search", json=req)
    assert response.status_code == 200
    data = response.json()
    verify_response_structure(data)
    assert data["results"][0]["label"] == "Fastest"

def test_fewest_transfers_route():
    req = {
        "origin_lat": ORIGIN_LAT,
        "origin_lng": ORIGIN_LNG,
        "dest_lat": DEST_LAT,
        "dest_lng": DEST_LNG,
        "preference": "fewest_transfers"
    }
    response = client.post("/api/routes/search", json=req)
    assert response.status_code == 200
    data = response.json()
    verify_response_structure(data)
    assert data["results"][0]["label"] == "Fewest Transfers"

def test_least_walking_route():
    req = {
        "origin_lat": ORIGIN_LAT,
        "origin_lng": ORIGIN_LNG,
        "dest_lat": DEST_LAT,
        "dest_lng": DEST_LNG,
        "preference": "least_walking"
    }
    response = client.post("/api/routes/search", json=req)
    assert response.status_code == 200
    data = response.json()
    verify_response_structure(data)
    assert data["results"][0]["label"] == "Least Walking"
    
    # Check that it's actually sorted by walking distance
    walk_dists = [r["walking_distance_km"] for r in data["results"]]
    assert walk_dists == sorted(walk_dists), "Results not sorted by walking distance"
