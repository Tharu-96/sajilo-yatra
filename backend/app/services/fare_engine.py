import math
from typing import List, Dict, Any

def calculate_fare(legs: List[Dict[str, Any]]) -> Dict[str, Any]:
    """
    Calculates the total fare for a trip consisting of multiple legs.
    fare_per_leg = 25 + 5 * ceil(max(0, leg_distance_km - 5) / 5)
    Total fare is the sum of fare_per_leg for each leg.
    """
    total_fare = 0
    breakdown = []
    
    for leg in legs:
        distance = leg.get("distance_km", 0.0)
        # 25 + 5 * ceil(max(0, leg_distance_km - 5) / 5)
        fare_per_leg = 25 + 5 * math.ceil(max(0.0, distance - 5.0) / 5.0)
        total_fare += fare_per_leg
        breakdown.append({
            "distance_km": distance,
            "fare": fare_per_leg
        })
        
    return {
        "total_fare": total_fare,
        "breakdown": breakdown
    }
