import unittest
from app.services.fare_engine import calculate_fare

class TestFareEngine(unittest.TestCase):

    def test_fare_direct_trip(self):
        # No transfer, 1 leg, distance 12km
        # Calculation: 25 + 5 * ceil((12 - 5)/5) = 25 + 5 * ceil(1.4) = 25 + 5 * 2 = 35
        legs = [{"distance_km": 12.0}]
        result = calculate_fare(legs)
        self.assertEqual(result["total_fare"], 35)
        self.assertEqual(len(result["breakdown"]), 1)
        self.assertEqual(result["breakdown"][0]["fare"], 35)

    def test_fare_one_transfer(self):
        # 1 transfer, 2 legs. Leg 1: 4km, Leg 2: 7.5km
        # Leg 1: 25 + 5 * ceil(max(0, 4-5)/5) = 25 + 0 = 25
        # Leg 2: 25 + 5 * ceil((7.5-5)/5) = 25 + 5 * ceil(0.5) = 25 + 5 * 1 = 30
        # Total = 55
        legs = [{"distance_km": 4.0}, {"distance_km": 7.5}]
        result = calculate_fare(legs)
        self.assertEqual(result["total_fare"], 55)
        self.assertEqual(len(result["breakdown"]), 2)
        self.assertEqual(result["breakdown"][0]["fare"], 25)
        self.assertEqual(result["breakdown"][1]["fare"], 30)

    def test_fare_two_transfers(self):
        # 2 transfers, 3 legs. Leg 1: 8km, Leg 2: 15km, Leg 3: 2km
        # Leg 1: 25 + 5 * ceil((8-5)/5) = 25 + 5 * 1 = 30
        # Leg 2: 25 + 5 * ceil((15-5)/5) = 25 + 5 * 2 = 35
        # Leg 3: 25 + 5 * ceil(max(0, 2-5)/5) = 25 + 0 = 25
        # Total = 30 + 35 + 25 = 90
        legs = [{"distance_km": 8.0}, {"distance_km": 15.0}, {"distance_km": 2.0}]
        result = calculate_fare(legs)
        self.assertEqual(result["total_fare"], 90)
        self.assertEqual(len(result["breakdown"]), 3)
        self.assertEqual(result["breakdown"][0]["fare"], 30)
        self.assertEqual(result["breakdown"][1]["fare"], 35)
        self.assertEqual(result["breakdown"][2]["fare"], 25)

if __name__ == '__main__':
    unittest.main()
