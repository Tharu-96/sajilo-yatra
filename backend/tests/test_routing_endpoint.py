import unittest
from fastapi.testclient import TestClient
from app.main import app


class TestRoutingEndpoint(unittest.TestCase):
    def setUp(self):
        self.client = TestClient(app)
        self.url = "/api/routes/search"
        self.req_shortest = {
            "origin_lat": 27.7058,
            "origin_lng": 85.3148,
            "dest_lat": 27.6931,
            "dest_lng": 85.2811,
            "preference": "shortest"
        }
        self.req_transfers = {
            "origin_lat": 27.7058,
            "origin_lng": 85.3148,
            "dest_lat": 27.6931,
            "dest_lng": 85.2811,
            "preference": "fewer_transfers"
        }
        self.req_walking = {
            "origin_lat": 27.7058,
            "origin_lng": 85.3148,
            "dest_lat": 27.6931,
            "dest_lng": 85.2811,
            "preference": "least_walking"
        }

    def _post(self, payload):
        response = self.client.post(self.url, json=payload)
        return response.status_code, response.json()

    def test_search_shortest(self):
        status, data = self._post(self.req_shortest)
        self.assertEqual(status, 200, f"Error: {data}")
        self.assertIn("results", data)
        if len(data["results"]) > 0:
            res1 = data["results"][0]
            self.assertIn("operator_name", res1)
            self.assertIn("total_time_min", res1)
            self.assertIn("total_fare_npr", res1)
            self.assertIn("transfer_count", res1)
            self.assertIn("walking_distance_km", res1)
            self.assertIn("legs", res1)

    def test_search_fewer_transfers(self):
        status, data = self._post(self.req_transfers)
        self.assertEqual(status, 200, f"Error: {data}")

    def test_search_least_walking(self):
        status, data = self._post(self.req_walking)
        self.assertEqual(status, 200, f"Error: {data}")


if __name__ == '__main__':
    unittest.main()
