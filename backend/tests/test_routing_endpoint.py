import unittest
import json
import urllib.request
import urllib.error

class TestRoutingEndpoint(unittest.TestCase):
    def setUp(self):
        self.url = "http://127.0.0.1:8000/api/routes/search"
        self.headers = {'Content-Type': 'application/json'}
        self.req_fastest = {
            "origin_lat": 27.7058,
            "origin_lng": 85.3148,
            "dest_lat": 27.6931,
            "dest_lng": 85.2811,
            "preference": "fastest"
        }
        self.req_transfers = {
            "origin_lat": 27.7058,
            "origin_lng": 85.3148,
            "dest_lat": 27.6931,
            "dest_lng": 85.2811,
            "preference": "fewest_transfers"
        }
        self.req_walking = {
            "origin_lat": 27.7058,
            "origin_lng": 85.3148,
            "dest_lat": 27.6931,
            "dest_lng": 85.2811,
            "preference": "least_walking"
        }

    def _post(self, payload):
        req = urllib.request.Request(self.url, data=json.dumps(payload).encode('utf-8'), headers=self.headers)
        try:
            with urllib.request.urlopen(req) as response:
                return response.status, json.loads(response.read().decode('utf-8'))
        except urllib.error.HTTPError as e:
            raw = e.read().decode('utf-8')
            try:
                return e.code, json.loads(raw)
            except:
                return e.code, raw

    def test_search_fastest(self):
        status, data = self._post(self.req_fastest)
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

    def test_search_fewest_transfers(self):
        status, data = self._post(self.req_transfers)
        self.assertEqual(status, 200, f"Error: {data}")

    def test_search_least_walking(self):
        status, data = self._post(self.req_walking)
        self.assertEqual(status, 200, f"Error: {data}")

if __name__ == '__main__':
    unittest.main()
