import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/api_service.dart';

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
          const SizedBox(width: 8), const Text('Bus Lists', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
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
                const SizedBox(height: 8),
                _viewFullMapButton(context, optionGroups),
                const SizedBox(height: 20),
              ],
            );
          },
        )),
      ])),
    );
  }

  // ─────────────────────────────────────────────────────────
  // View full map: opens the route preview with all bus options
  // ─────────────────────────────────────────────────────────
  Widget _viewFullMapButton(BuildContext context, List<List<dynamic>> optionGroups) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => context.push('/route-preview', extra: {
          'route': route,
          'optionGroups': optionGroups,
        }),
        icon: const Icon(Icons.map_outlined, size: 20, color: Colors.white),
        label: const Text('View Full Route Map',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF006495),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
        ),
      ),
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

    return Container(
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
          Row(children: const [
            Icon(Icons.route, size: 16, color: Color(0xFF006495)),
            SizedBox(width: 6),
            Text('Trip Overview', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF006495))),
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
    return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(11), border: Border.all(color: const Color(0xFFE5EAF1))),
        child: Column(children: [
          Row(children: [
            Container(width: 30, height: 30, decoration: const BoxDecoration(color: Color(0xFFE7EEF7), shape: BoxShape.circle), child: const Icon(Icons.directions_bus, color: Color(0xFF5F6F80), size: 18)),
            const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(vehicle['operator_name'], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              if (vehicle['line_from'] != null && vehicle['line_to'] != null) ...[
                const SizedBox(height: 2),
                Row(children: [
                  const Icon(Icons.alt_route, size: 11, color: Color(0xFF8A94A6)),
                  const SizedBox(width: 3),
                  Flexible(child: Text('${vehicle['line_from']} – ${vehicle['line_to']}',
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF8A94A6)))),
                ]),
              ],
              const SizedBox(height: 3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(border: Border.all(color: const Color(0xFF006495)), borderRadius: BorderRadius.circular(9)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Text('Board  ', style: TextStyle(color: Color(0xFF006495), fontSize: 10, fontWeight: FontWeight.w700)),
                  Flexible(child: Text(vehicle['direction'], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF006495), fontSize: 10))),
                ]),
              ),
              const SizedBox(height: 3),
              Text('${vehicle['duration']} min', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: Color(0xFF5D6876))),
            ])), const SizedBox(width: 8), Column(mainAxisSize: MainAxisSize.min, children: [
              Text('Rs ${vehicle['fare']}', style: const TextStyle(color: Color(0xFF005F8D), fontWeight: FontWeight.w700)),
            ]),
          ]),
          const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider(height: 1)),
          Row(children: [Icon(Icons.compare_arrows, size: 15, color: transfers > 0 ? Colors.red : const Color(0xFF596979)), Text(' $transfers ${transfers == 1 ? 'Transfer' : 'Transfers'}', style: TextStyle(fontSize: 10, color: transfers > 0 ? Colors.red : const Color(0xFF596979))), const SizedBox(width: 15), const Icon(Icons.directions_walk, size: 15), Text(' ${vehicle['walk_time_min']}m walk', style: const TextStyle(fontSize: 10))]),
        ]),
    );
  }
}
