"""Stress test: validate route-search invariants over many random stop pairs.

Invariants checked per suggested route:
  - no exception raised
  - every bus leg has ordered from/to stop ids
  - transfer_count == (#bus legs - 1)
  - results ranked by travel time (ascending)
  - no phantom sub-span (an earlier leg's line already reaching a later
    leg's alighting stop)
  - same operator on two legs => distinguishable line labels (line_from/to)
"""
import sys
import random
import traceback

sys.stdout.reconfigure(encoding="utf-8")
from sqlalchemy import text
from app.database import get_db
from app.services.routing_engine import find_routes, find_bus_options

random.seed(42)
N_PAIRS = 60


def build_reaches(db):
    rows = db.execute(text(
        "SELECT rs.route_id, rs.stop_id, rs.stop_order "
        "FROM route_stops rs"
    )).mappings().all()
    orders = {}
    for r in rows:
        orders.setdefault(r["route_id"], {})[r["stop_id"]] = r["stop_order"]

    def reaches(route_id, board_id, dest_id):
        stops = orders.get(route_id, {})
        b, d = stops.get(board_id), stops.get(dest_id)
        return b is not None and d is not None and d > b

    return reaches


def main():
    db = next(get_db())
    reaches = build_reaches(db)
    stops = db.execute(text("SELECT name, latitude, longitude FROM stops")).mappings().all()
    stops = [dict(s) for s in stops]

    pairs = []
    for _ in range(N_PAIRS):
        o, d = random.sample(stops, 2)
        pairs.append((o, d))

    failures = []
    total_routes = 0
    pairs_with_routes = 0

    for o, d in pairs:
        label = f"{o['name']} -> {d['name']}"
        try:
            routes = find_routes(db, o["latitude"], o["longitude"], d["latitude"], d["longitude"])
        except Exception:
            failures.append(f"[EXC] {label}\n{traceback.format_exc()}")
            continue
        if not routes:
            continue
        pairs_with_routes += 1
        total_routes += len(routes)

        times = [r["total_time_min"] for r in routes]
        if times != sorted(times):
            failures.append(f"[ORDER] {label}: times {times} not ascending")

        for ri, route in enumerate(routes, 1):
            bus_legs = [l for l in route["legs"] if l["mode"] == "bus"]
            for l in bus_legs:
                if not l.get("from_stop_id") or not l.get("to_stop_id"):
                    failures.append(f"[LEG] {label} R{ri}: missing stop id")
            if route["transfer_count"] != max(0, len(bus_legs) - 1):
                failures.append(f"[XFER] {label} R{ri}: count mismatch")

            # phantom sub-span (verified by stop id, not name)
            for i in range(len(bus_legs)):
                for j in range(i + 1, len(bus_legs)):
                    if reaches(bus_legs[i]["route_id"], bus_legs[i]["from_stop_id"], bus_legs[j]["to_stop_id"]):
                        failures.append(
                            f"[PHANTOM] {label} R{ri}: leg{i+1} line spans to leg{j+1} dest")

            # same-operator label disambiguation via best option per leg
            chosen = []
            for leg in bus_legs:
                opts = find_bus_options(db, leg["route_id"], route)
                chosen.append(min(opts, key=lambda x: x["fare"]) if opts else None)
            for a in range(len(chosen)):
                for b in range(a + 1, len(chosen)):
                    oa, ob = chosen[a], chosen[b]
                    if oa and ob and oa["operator_name"] == ob["operator_name"]:
                        if (oa.get("line_from"), oa.get("line_to")) == (ob.get("line_from"), ob.get("line_to")):
                            failures.append(
                                f"[LABEL] {label} R{ri}: same operator '{oa['operator_name']}' "
                                f"identical line on leg{a+1}&leg{b+1}")

    print(f"Tested {N_PAIRS} random pairs | {pairs_with_routes} returned routes | {total_routes} routes total")
    if failures:
        print(f"\n{len(failures)} INVARIANT VIOLATION(S):")
        for f in failures:
            print("  -", f)
        sys.exit(1)
    else:
        print("\nALL INVARIANTS HOLD across every route in every pair.")
    db.close()


if __name__ == "__main__":
    main()
