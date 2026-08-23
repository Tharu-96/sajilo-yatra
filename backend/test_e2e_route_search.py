"""End-to-end sanity test for the route search module.

For several origin/destination pairs it verifies:
  1. Route suggestions are returned and each bus leg is well-formed & ordered.
  2. Bus options are found per leg, and when the SAME operator serves two legs
     the line labels (line_from/line_to) differ so they are distinguishable.
  3. The map geometry endpoint returns a real, ordered polyline for each leg.
"""
import traceback
import sys

sys.stdout.reconfigure(encoding="utf-8")
from app.database import get_db
from app.services.routing_engine import find_routes, find_bus_options
from app.routers.route_finder import route_geometry

CASES = [
    ("Kupondole/Jwagal -> Kalanki", 27.6862, 85.3155, 27.6931, 85.2811),
    ("Ratnapark -> Kalanki",        27.7058, 85.3148, 27.6931, 85.2811),
    ("Koteshwor -> Kalanki",        27.6786, 85.3487, 27.6931, 85.2811),
    ("Baneshwor -> Balaju",         27.6922, 85.3331, 27.7361, 85.3020),
    ("Lagankhel -> Bhaktapur",      27.6667, 85.3247, 27.6710, 85.4298),
]


def best_option(options):
    return min(options, key=lambda o: o["fare"]) if options else None


def run_case(db, name, olat, olng, dlat, dlng):
    print(f"\n{'='*70}\nCASE: {name}\n{'='*70}")
    failures = []
    routes = find_routes(db, olat, olng, dlat, dlng)
    print(f"  Route suggestions returned: {len(routes)}")
    if not routes:
        failures.append("No routes suggested")
        return failures

    for r_idx, route in enumerate(routes, 1):
        bus_legs = [l for l in route["legs"] if l["mode"] == "bus"]
        seg = " => ".join(f"{l['from_stop']}->{l['to_stop']}" for l in bus_legs)
        print(f"\n  Route {r_idx}: {route['total_time_min']}min  Rs{route['total_fare_npr']}  "
              f"transfers={route['transfer_count']}")
        print(f"    Legs: {seg}")

        # (1) leg well-formedness
        for l in bus_legs:
            if not l.get("from_stop_id") or not l.get("to_stop_id"):
                failures.append(f"R{r_idx}: leg missing stop ids")
        if route["transfer_count"] != max(0, len(bus_legs) - 1):
            failures.append(f"R{r_idx}: transfer_count mismatch")

        # (2) bus options per leg + label disambiguation
        chosen_per_leg = []
        for l_idx, leg in enumerate(bus_legs, 1):
            options = find_bus_options(db, leg["route_id"], route)
            if not options:
                failures.append(f"R{r_idx} leg{l_idx}: no bus options")
                chosen_per_leg.append(None)
                continue
            for o in options:
                line = f"{o.get('line_from')} -> {o.get('line_to')}"
                print(f"      leg{l_idx} option: {o['operator_name']:<14} "
                      f"line[{line}]  board[{o['direction']}]  Rs{o['fare']}")
            chosen_per_leg.append(best_option(options))

        # Same operator on adjacent legs must carry a DIFFERENT line label.
        for a in range(len(chosen_per_leg)):
            for b in range(a + 1, len(chosen_per_leg)):
                oa, ob = chosen_per_leg[a], chosen_per_leg[b]
                if not oa or not ob:
                    continue
                if oa["operator_name"] == ob["operator_name"]:
                    la = (oa.get("line_from"), oa.get("line_to"))
                    lb = (ob.get("line_from"), ob.get("line_to"))
                    tag = f"R{r_idx}: same operator '{oa['operator_name']}' on leg{a+1}&leg{b+1}"
                    if la == lb:
                        failures.append(f"{tag} has IDENTICAL line label {la}")
                    else:
                        print(f"    OK  {tag} distinguished: {la}  vs  {lb}")

        # (3) map geometry for each chosen option
        for l_idx, (leg, chosen) in enumerate(zip(bus_legs, chosen_per_leg), 1):
            if not chosen:
                continue
            try:
                geo = route_geometry(chosen["route_id"], leg["from_stop"], leg["to_stop"], db)
                pts = geo["points"]
                orders = [p["stop_order"] for p in pts]
                if len(pts) < 2:
                    failures.append(f"R{r_idx} leg{l_idx}: geometry has <2 points")
                elif orders != sorted(orders):
                    failures.append(f"R{r_idx} leg{l_idx}: geometry not ordered")
                else:
                    print(f"      leg{l_idx} map: {len(pts)} ordered stops "
                          f"({pts[0]['name']} .. {pts[-1]['name']})")
            except Exception as ex:
                failures.append(f"R{r_idx} leg{l_idx}: geometry error {ex}")

    return failures


def main():
    db = next(get_db())
    all_failures = {}
    try:
        for name, olat, olng, dlat, dlng in CASES:
            try:
                fails = run_case(db, name, olat, olng, dlat, dlng)
            except Exception:
                traceback.print_exc()
                fails = ["unhandled exception"]
            if fails:
                all_failures[name] = fails

        print(f"\n\n{'#'*70}\nSUMMARY\n{'#'*70}")
        for name, *_ in CASES:
            if name in all_failures:
                print(f"  FAIL  {name}")
                for f in all_failures[name]:
                    print(f"          - {f}")
            else:
                print(f"  PASS  {name}")
        print(f"\n{len(CASES) - len(all_failures)}/{len(CASES)} cases passed cleanly.")
    finally:
        db.close()


if __name__ == "__main__":
    main()
