import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/api_service.dart';
import '../../shared/widgets/elevated_card.dart';

class BusOptionsScreen extends StatelessWidget {
  final Map<String, dynamic> route;
  const BusOptionsScreen({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    final allLegs = route['legs'] as List? ?? [];
    final busLegs = allLegs.where((leg) => leg['mode'] == 'bus').toList();
    if (busLegs.isEmpty) return const Scaffold(body: Center(child: Text('No bus service is available for this route.')));
    final optionsForLegs = Future.wait(busLegs.map((leg) => ApiService.getBusOptions(
          routeId: leg['route_id'].toString(),
          route: route,
        )));
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: SafeArea(child: Column(children: [
        Padding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 20), child: Row(children: [
          IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back, size: 20)),
          const SizedBox(width: 8), const Text('Choose your bus', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        ])),
        Expanded(child: FutureBuilder<List<List<dynamic>>>(
          future: optionsForLegs,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            if (snapshot.hasError) return const Center(child: Text('Unable to load bus options.'));
            final optionGroups = snapshot.data ?? const <List<dynamic>>[];
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              children: [
                // ── Trip strip: tappable chip row of all stops ──
                _tripStrip(context, allLegs, busLegs, -1, optionGroups),
                const SizedBox(height: 16),
                for (var index = 0; index < busLegs.length; index++) ...[
                  // ── Leg pill badge ──
                  _legBadge(busLegs, index),
                  const SizedBox(height: 8),
                  if (optionGroups[index].isEmpty)
                    const Padding(padding: EdgeInsets.only(bottom: 16), child: Text('No matching buses for this leg.'))
                  else ...[
                    ..._cardsForVehicles(context, optionGroups[index]),
                    const SizedBox(height: 8),
                  ],
                ],
              ],
            );
          },
        )),
      ])),
    );
  }

  // ─────────────────────────────────────────────────────────
  // Trip strip: horizontal row of stop chips, current leg highlighted
  // ─────────────────────────────────────────────────────────
  Widget _tripStrip(BuildContext context, List allLegs, List busLegs,
      int highlightLegIndex, List<List<dynamic>> optionGroups) {
    // Build ordered list of stop names from all legs (bus + walk)
    final stops = <String>[];
    for (final leg in allLegs) {
      final from = leg['from_stop'] as String? ?? '';
      if (stops.isEmpty || stops.last != from) stops.add(from);
      final to = leg['to_stop'] as String? ?? '';
      if (stops.last != to) stops.add(to);
    }
    if (stops.isEmpty) return const SizedBox();

    // Determine which stops are bus-leg endpoints for accent highlighting
    final busEndpoints = <String>{};
    for (final leg in busLegs) {
      busEndpoints.add(leg['from_stop'] as String? ?? '');
      busEndpoints.add(leg['to_stop'] as String? ?? '');
    }

    return GestureDetector(
      onTap: () => context.push('/route-preview', extra: {
        'route': route,
        'optionGroups': optionGroups,
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFD5DCE5)),
          boxShadow: const [BoxShadow(color: Color(0x10006495), blurRadius: 6, offset: Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Icon(Icons.route, size: 16, color: Color(0xFF006495)),
              const SizedBox(width: 6),
              const Text('Trip Overview', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF006495))),
              const Spacer(),
              const Icon(Icons.map_outlined, size: 14, color: Color(0xFF006495)),
              const SizedBox(width: 4),
              const Text('View full map', style: TextStyle(fontSize: 10, color: Color(0xFF006495), fontWeight: FontWeight.w600)),
            ]),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var i = 0; i < stops.length; i++) ...[
                    if (i > 0) const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      child: Icon(Icons.chevron_right, size: 14, color: Color(0xFFB0B8C4)),
                    ),
                    _stopChip(stops[i], busEndpoints.contains(stops[i])),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stopChip(String name, bool isAccent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isAccent ? const Color(0xFFE0F0FF) : const Color(0xFFF2F4F7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isAccent ? const Color(0xFF006495) : const Color(0xFFD5DCE5), width: isAccent ? 1.5 : 1),
      ),
      child: Text(
        name,
        style: TextStyle(
          fontSize: 10,
          fontWeight: isAccent ? FontWeight.w700 : FontWeight.w500,
          color: isAccent ? const Color(0xFF005F8D) : const Color(0xFF667085),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // Leg badge: pill showing "Leg X of Y • from → to"
  // ─────────────────────────────────────────────────────────
  Widget _legBadge(List busLegs, int index) {
    final leg = busLegs[index];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF006495), Color(0xFF0088CC)]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.25), borderRadius: BorderRadius.circular(10)),
          child: Text('Leg ${index + 1} of ${busLegs.length}',
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white)),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text('${leg['from_stop']} → ${leg['to_stop']}',
              maxLines: 1, overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white)),
        ),
      ]),
    );
  }

  // ─────────────────────────────────────────────────────────
  // Operator cards
  // ─────────────────────────────────────────────────────────
  List<Widget> _cardsForVehicles(BuildContext context, List<dynamic> vehicles) {
    final lowestFare = vehicles.map((v) => (v['fare'] as num).toDouble()).reduce((a, b) => a < b ? a : b);
    final best = vehicles.where((v) => (v['fare'] as num).toDouble() == lowestFare).reduce(
      (a, b) => (a['transfer_count'] as num) <= (b['transfer_count'] as num) ? a : b,
    );
    return vehicles.map((vehicle) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: _vehicleCard(context, vehicle as Map<String, dynamic>, identical(vehicle, best)),
    )).toList();
  }

  Widget _vehicleCard(BuildContext context, Map<String, dynamic> vehicle, bool isBest) {
    final transfers = vehicle['transfer_count'] as num;
    return InkWell(
      borderRadius: BorderRadius.circular(11),
      onTap: () {
        // ── FIX: pass only the tapped leg's data to route_detail ──
        // Extract the specific bus leg from confirmed_route that matches
        // this operator's route_id. If no match is found, fail loudly so
        // we catch data mismatches immediately instead of silently
        // rendering the wrong segment on the map.
        final confirmedRoute = vehicle['confirmed_route'] as Map<String, dynamic>;
        final confirmedLegs = confirmedRoute['legs'] as List;
        final vehicleRouteId = vehicle['route_id'];
        final thisLeg = confirmedLegs.cast<Map<String, dynamic>>().firstWhere(
          (l) => l['route_id'] == vehicleRouteId,
          orElse: () => throw StateError(
            'BusOptionsScreen: confirmed_route has no leg with '
            'route_id=$vehicleRouteId. Legs: '
            '${confirmedLegs.map((l) => l['route_id']).toList()}',
          ),
        );
        // Build a single-leg route object so RouteDetailScreen shows
        // this specific leg's from/to, fare, and duration on its map.
        final legRoute = Map<String, dynamic>.from(confirmedRoute);
        legRoute['legs'] = [thisLeg];
        legRoute['total_fare_npr'] = thisLeg['fare_npr'];
        legRoute['total_time_min'] = thisLeg['duration_min'];
        context.push('/route-detail', extra: legRoute);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: isBest ? const Color(0xFFE5F2FB) : Colors.white, borderRadius: BorderRadius.circular(11), border: Border.all(color: isBest ? const Color(0xFF006495) : const Color(0xFFE5EAF1))),
        child: Column(children: [
          Row(children: [
            Container(width: 30, height: 30, decoration: const BoxDecoration(color: Color(0xFFE7EEF7), shape: BoxShape.circle), child: Icon(Icons.directions_bus, color: isBest ? const Color(0xFF006495) : const Color(0xFF5F6F80), size: 18)),
            const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(vehicle['operator_name'], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              const SizedBox(height: 3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(border: Border.all(color: const Color(0xFF006495)), borderRadius: BorderRadius.circular(9)),
                child: Text(vehicle['direction'], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF006495), fontSize: 10)),
              ),
              const SizedBox(height: 3),
              Text('${vehicle['duration']} min${isBest ? ' (Best Value)' : ''}', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 10, color: isBest ? const Color(0xFF006495) : const Color(0xFF5D6876))),
            ])), const SizedBox(width: 8), Column(mainAxisSize: MainAxisSize.min, children: [
              Text('Rs ${vehicle['fare']}', style: const TextStyle(color: Color(0xFF005F8D), fontWeight: FontWeight.w700)),
              if (isBest) const Padding(padding: EdgeInsets.only(top: 4), child: Icon(Icons.check_circle, color: Color(0xFF006495), size: 17)),
            ]),
          ]),
          const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider(height: 1)),
          Row(children: [Icon(Icons.compare_arrows, size: 15, color: transfers > 0 ? Colors.red : const Color(0xFF596979)), Text(' $transfers ${transfers == 1 ? 'Transfer' : 'Transfers'}', style: TextStyle(fontSize: 10, color: transfers > 0 ? Colors.red : const Color(0xFF596979))), const SizedBox(width: 15), const Icon(Icons.directions_walk, size: 15), Text(' ${vehicle['walk_time_min']}m walk', style: const TextStyle(fontSize: 10))]),
        ]),
      ),
    );
  }

  Widget _legacyBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Buses'),
        backgroundColor: Colors.transparent,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: GestureDetector(
              onTap: () => context.push('/route-detail', extra: route),
              child: ElevatedCard(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.directions_bus, color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${route['operator_name'] ?? 'Bus'} ${4567 + index}', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 4),
                          Text(
                            'Arriving in ${2 + index * 5} mins',
                            style: TextStyle(color: Theme.of(context).colorScheme.primary),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.outline),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
