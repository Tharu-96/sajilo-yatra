import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../core/theme/app_theme.dart';
import '../../core/api_service.dart';
import '../../core/osrm_service.dart';
import '../../core/widgets/app_tile_layer.dart';

/// Distinct polyline colors for each leg (up to 6 legs; wraps around).
const _legColors = <Color>[
  Color(0xFF006495), // blue
  Color(0xFFE67E22), // orange
  Color(0xFF27AE60), // green
  Color(0xFF8E44AD), // purple
  Color(0xFFC0392B), // red
  Color(0xFF16A085), // teal
];

/// Full-trip preview showing ALL legs on one map with distinct colored
/// polylines, a legend, and a fare/duration footer.
class RoutePreviewScreen extends StatefulWidget {
  final Map<String, dynamic> route;
  final List<List<dynamic>>? optionGroups;

  const RoutePreviewScreen({
    super.key,
    required this.route,
    this.optionGroups,
  });

  @override
  State<RoutePreviewScreen> createState() => _RoutePreviewScreenState();
}

class _RoutePreviewScreenState extends State<RoutePreviewScreen> {
  late Future<_PreviewData> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = _loadData();
  }

  Future<_PreviewData> _loadData() async {
    final segments = await _loadAllSegments();
    final walkingSegments = await _buildWalkingSegments(segments);
    return _PreviewData(segments, walkingSegments);
  }

  Future<List<_LegSegment>> _loadAllSegments() async {
    final legs = (widget.route['legs'] as List? ?? [])
        .whereType<Map>()
        .where((leg) => leg['mode'] == 'bus' && leg['route_id'] != null)
        .toList();
    final segments = <_LegSegment>[];
    for (var i = 0; i < legs.length; i++) {
      final leg = legs[i];
      // Determine operator: use best-value from optionGroups if available.
      String operator = _bestOperatorForLeg(i, leg);
      final routeId = _bestRouteIdForLeg(i, leg);
      final rawPoints = await ApiService.getRouteGeometry(
        routeId: routeId,
        fromStop: leg['from_stop'].toString(),
        toStop: leg['to_stop'].toString(),
      );
      final waypoints = rawPoints.map((p) => LatLng(
        (p['latitude'] as num).toDouble(),
        (p['longitude'] as num).toDouble(),
      )).toList();
      final detailedRoute = await OsrmService.getRoute(waypoints, mode: 'driving');

      segments.add(_LegSegment(
        legIndex: i,
        leg: leg.cast<String, dynamic>(),
        latLngs: detailedRoute,
        rawStops: rawPoints,
        color: _legColors[i % _legColors.length],
        operatorName: operator,
      ));
    }
    return segments;
  }

  /// Returns the best (lowest fare) operator name for leg at [index].
  String _bestOperatorForLeg(int index, Map leg) {
    final groups = widget.optionGroups;
    if (groups != null && index < groups.length && groups[index].isNotEmpty) {
      final options = groups[index];
      final best = options.reduce((a, b) =>
          (a['fare'] as num) <= (b['fare'] as num) ? a : b);
      return best['operator_name'] as String? ?? leg['route_name'] ?? 'Bus';
    }
    return leg['route_name'] as String? ?? 'Bus';
  }

  /// Returns the route_id to use for geometry. Prefers the best option's route.
  String _bestRouteIdForLeg(int index, Map leg) {
    final groups = widget.optionGroups;
    if (groups != null && index < groups.length && groups[index].isNotEmpty) {
      final options = groups[index];
      final best = options.reduce((a, b) =>
          (a['fare'] as num) <= (b['fare'] as num) ? a : b);
      return best['route_id']?.toString() ?? leg['route_id'].toString();
    }
    return leg['route_id'].toString();
  }

  @override
  Widget build(BuildContext context) {
    final allLegs = widget.route['legs'] as List? ?? [];
    final busLegs = allLegs.where((l) => l['mode'] == 'bus').toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: FutureBuilder<_PreviewData>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data;
          if (data == null) return const Center(child: Text('Route map is unavailable.'));
          
          final segments = data.segments;
          final walkingSegments = data.walkingSegments;
          
          final allPoints = segments.expand((s) => s.latLngs).toList();
          if (allPoints.length < 2 && walkingSegments.isEmpty) {
            return const Center(child: Text('Route map is unavailable.'));
          }

          // Calculate total fare and duration across best operators per leg
          int totalFare = 0;
          int totalDuration = 0;
          for (var i = 0; i < busLegs.length; i++) {
            final groups = widget.optionGroups;
            if (groups != null && i < groups.length && groups[i].isNotEmpty) {
              final best = groups[i].reduce((a, b) =>
                  (a['fare'] as num) <= (b['fare'] as num) ? a : b);
              totalFare += (best['fare'] as num).toInt();
              totalDuration += (best['duration'] as num).toInt();
            } else {
              totalFare += (busLegs[i]['fare_npr'] as num? ?? 0).toInt();
              totalDuration += (busLegs[i]['duration_min'] as num? ?? 0).toInt();
            }
          }
          // Add walking time
          for (final leg in allLegs) {
            if (leg['mode'] == 'walk') {
              totalDuration += (leg['duration_min'] as num? ?? 0).toInt();
            }
          }

          return Stack(children: [
            Positioned.fill(child: _PreviewMap(
              segments: segments,
              walkingSegments: walkingSegments,
            )),

            // Back button
            SafeArea(child: Padding(
              padding: const EdgeInsets.all(12),
              child: IconButton.filledTonal(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back),
              ),
            )),

            // Bottom sheet with legend + totals
            DraggableScrollableSheet(
              initialChildSize: 0.30,
              minChildSize: 0.18,
              maxChildSize: 0.60,
              builder: (context, controller) => Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [BoxShadow(color: Color(0x20000000), blurRadius: 12, offset: Offset(0, -4))],
                ),
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
                  children: [
                    Center(child: Container(
                      width: 40, height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    )),
                    const SizedBox(height: 14),

                    // Trip total card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF006495), Color(0xFF0088CC)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(children: [
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Total Fare', style: TextStyle(color: Color(0xCCFFFFFF), fontSize: 12)),
                            const SizedBox(height: 2),
                            Text('Rs $totalFare', style: const TextStyle(
                              color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700,
                            )),
                          ],
                        )),
                        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                          const Text('Duration', style: TextStyle(color: Color(0xCCFFFFFF), fontSize: 12)),
                          const SizedBox(height: 2),
                          Text('$totalDuration min', style: const TextStyle(
                            color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700,
                          )),
                        ]),
                      ]),
                    ),
                    const SizedBox(height: 16),

                    const Text('Step-by-step directions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),

                    ..._buildDirectionSteps(allLegs, segments),
                  ],
                ),
              ),
            ),
          ]);
        },
      ),
    );
  }

  /// Builds an ordered, turn-by-turn guide from the legs in travel order.
  List<Widget> _buildDirectionSteps(List allLegs, List<_LegSegment> segments) {
    final steps = <Widget>[];
    var busIndex = 0;
    var stepNo = 1;

    for (final rawLeg in allLegs) {
      final leg = rawLeg as Map;
      final from = (leg['from_stop'] ?? '').toString();
      final to = (leg['to_stop'] ?? '').toString();

      if (leg['mode'] == 'walk') {
        final mins = (leg['duration_min'] as num?)?.toInt() ?? 0;
        if (mins <= 0) continue;
        final label = (from == 'Origin')
            ? 'Walk to your first bus stop ($mins min)'
            : (to == 'Destination')
                ? 'Walk to your destination ($mins min)'
                : 'Walk from $from to $to ($mins min)';
        steps.add(_stepTile(
          number: stepNo++,
          color: const Color(0xFF667085),
          icon: Icons.directions_walk,
          title: label,
          subtitle: null,
        ));
      } else {
        final segment = busIndex < segments.length ? segments[busIndex] : null;
        final operator = segment?.operatorName ?? (leg['route_name'] ?? 'Bus').toString();
        final color = segment?.color ?? const Color(0xFF006495);
        final stopsCount = (leg['stops'] as num?)?.toInt() ?? 0;
        steps.add(_stepTile(
          number: stepNo++,
          color: color,
          icon: Icons.directions_bus,
          title: 'Board $operator at $from',
          subtitle: 'Ride ${stopsCount > 0 ? '$stopsCount stops ' : ''}and get off at $to',
        ));
        if (busIndex < segments.length - 1) {
          steps.add(_stepTile(
            number: stepNo++,
            color: const Color(0xFFAA3C1A),
            icon: Icons.compare_arrows,
            title: 'Transfer at $to',
            subtitle: 'Change to your next bus',
          ));
        }
        busIndex++;
      }
    }

    steps.add(_stepTile(
      number: stepNo,
      color: const Color(0xFF16806B),
      icon: Icons.flag,
      title: 'Arrive at your destination',
      subtitle: null,
    ));
    return steps;
  }

  Widget _stepTile({
    required int number,
    required Color color,
    required IconData icon,
    required String title,
    String? subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 30, height: 30,
          decoration: BoxDecoration(color: color.withValues(alpha: 0.15), shape: BoxShape.circle),
          child: Center(child: Text('$number', style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 13))),
        ),
        const SizedBox(width: 12),
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF1A2530))),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF667085))),
          ],
        ])),
      ]),
    );
  }

  /// Builds walking connection lines between bus segments.
  Future<List<List<LatLng>>> _buildWalkingSegments(List<_LegSegment> busSegments) async {
    final legs = widget.route['legs'] as List? ?? [];
    final result = <List<LatLng>>[];
    var nextBusIndex = 0;
    for (final rawLeg in legs) {
      final leg = rawLeg as Map;
      if (leg['mode'] == 'bus') {
        nextBusIndex++;
        continue;
      }
      final distance = (leg['distance_km'] as num?)?.toDouble() ?? 0;
      if (distance < 0.015) continue;

      final previousBus = nextBusIndex > 0 ? busSegments[nextBusIndex - 1] : null;
      final followingBus = nextBusIndex < busSegments.length ? busSegments[nextBusIndex] : null;
      final from = previousBus?.latLngs.last ?? _routePoint('origin');
      final to = followingBus?.latLngs.first ?? _routePoint('dest');
      if (from != null && to != null) {
        final walkingRoute = await OsrmService.getRoute([from, to], mode: 'foot');
        result.add(walkingRoute);
      }
    }
    return result;
  }

  LatLng? _routePoint(String prefix) {
    final lat = widget.route['${prefix}_lat'];
    final lng = widget.route['${prefix}_lng'];
    if (lat is! num || lng is! num) return null;
    return LatLng(lat.toDouble(), lng.toDouble());
  }
}

class _PreviewData {
  final List<_LegSegment> segments;
  final List<List<LatLng>> walkingSegments;
  _PreviewData(this.segments, this.walkingSegments);
}

// ─────────────────────────────────────────────────────────
// Data model for a leg's geometry + metadata
// ─────────────────────────────────────────────────────────
class _LegSegment {
  const _LegSegment({
    required this.legIndex,
    required this.leg,
    required this.latLngs,
    required this.rawStops,
    required this.color,
    required this.operatorName,
  });
  final int legIndex;
  final Map<String, dynamic> leg;
  final List<LatLng> latLngs;
  final List<Map<String, dynamic>> rawStops;
  final Color color;
  final String operatorName;
}

// ─────────────────────────────────────────────────────────
// Map widget with per-leg colored polylines
// ─────────────────────────────────────────────────────────
class _PreviewMap extends StatelessWidget {
  const _PreviewMap({required this.segments, required this.walkingSegments});
  final List<_LegSegment> segments;
  final List<List<LatLng>> walkingSegments;

  @override
  Widget build(BuildContext context) {
    final allPoints = segments.expand((s) => s.latLngs).toList();
    // Calculate bounds to fit all points
    var minLat = allPoints.first.latitude;
    var maxLat = allPoints.first.latitude;
    var minLng = allPoints.first.longitude;
    var maxLng = allPoints.first.longitude;
    for (final p in allPoints) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }
    final center = LatLng((minLat + maxLat) / 2, (minLng + maxLng) / 2);

    return FlutterMap(
      options: MapOptions(
        initialCenter: center,
        initialZoom: 13,
        initialCameraFit: CameraFit.bounds(
          bounds: LatLngBounds(
            LatLng(minLat, minLng),
            LatLng(maxLat, maxLng),
          ),
          padding: const EdgeInsets.all(40),
        ),
      ),
      children: [
        const AppTileLayer(),
        // Bus leg polylines — each a distinct color
        PolylineLayer(polylines: segments.map((segment) => Polyline(
          points: segment.latLngs,
          color: segment.color,
          strokeWidth: 5,
        )).toList()),
        // Walking segments — dashed grey lines
        PolylineLayer(polylines: _dashedPolylines(walkingSegments)),
        // Start and end markers
        MarkerLayer(markers: [
          // A few evenly-spaced intermediate stop labels (not every stop)
          ..._sampledStopMarkers(segments),

          // Source marker at the user's actual starting point
          if (_originPoint() != null)
            Marker(
              point: _originPoint()!,
              width: 40, height: 40,
              child: const _SourceMarker(),
            ),

          if (segments.isNotEmpty) ...[
            // First boarding stop — labelled like the other bus stops
            Marker(
              point: segments.first.latLngs.first,
              width: 150, height: 52,
              alignment: Alignment.center,
              child: _BusStopMarker(
                label: segments.first.rawStops.isNotEmpty
                    ? segments.first.rawStops.first['name'].toString()
                    : (segments.first.leg['from_stop'] ?? 'Board here').toString(),
                accent: const Color(0xFF16806B),
              ),
            ),
            // Destination — labelled with a pin
            Marker(
              point: segments.last.latLngs.last,
              width: 150, height: 52,
              alignment: Alignment.center,
              child: _DestinationMarker(
                label: segments.last.rawStops.isNotEmpty
                    ? segments.last.rawStops.last['name'].toString()
                    : (segments.last.leg['to_stop'] ?? 'Destination').toString(),
              ),
            ),
          ],
          // Intermediate transfer points — where the rider changes buses
          for (var i = 0; i < segments.length - 1; i++)
            Marker(
              point: segments[i].latLngs.last,
              width: 160, height: 66,
              alignment: Alignment.center,
              child: _TransferMarker(
                stopName: segments[i].rawStops.isNotEmpty
                    ? segments[i].rawStops.last['name'].toString()
                    : (segments[i].leg['to_stop'] ?? 'Transfer').toString(),
              ),
            ),
        ]),
      ],
    );
  }

  List<Polyline> _dashedPolylines(List<List<LatLng>> segs) {
    const dashFraction = .55;
    const dashLengthDegrees = .00035;
    final polylines = <Polyline>[];
    for (final segment in segs) {
      final start = segment.first;
      final end = segment.last;
      final distance = (start.latitude - end.latitude).abs() +
          (start.longitude - end.longitude).abs();
      final dashCount = (distance / dashLengthDegrees).ceil().clamp(1, 80).toInt();
      for (var index = 0; index < dashCount; index++) {
        final dashStart = index / dashCount;
        final dashEnd = ((index + dashFraction) / dashCount).clamp(0.0, 1.0).toDouble();
        polylines.add(Polyline(
          points: [_interpolate(start, end, dashStart), _interpolate(start, end, dashEnd)],
          color: const Color(0xFF4B6275),
          strokeWidth: 3,
        ));
      }
    }
    return polylines;
  }

  LatLng _interpolate(LatLng start, LatLng end, double fraction) => LatLng(
    start.latitude + (end.latitude - start.latitude) * fraction,
    start.longitude + (end.longitude - start.longitude) * fraction,
  );

  /// The user's starting point: the beginning of the first walking segment.
  LatLng? _originPoint() {
    if (walkingSegments.isNotEmpty && walkingSegments.first.isNotEmpty) {
      return walkingSegments.first.first;
    }
    return null;
  }

  /// Picks at most 4 evenly-spaced intermediate stops across all legs so the
  /// map stays readable instead of labelling every single stop.
  List<Marker> _sampledStopMarkers(List<_LegSegment> segments) {
    final intermediates = <Map<String, dynamic>>[];
    for (final segment in segments) {
      for (var i = 1; i < segment.rawStops.length - 1; i++) {
        intermediates.add(segment.rawStops[i]);
      }
    }
    if (intermediates.isEmpty) return const [];

    const maxLabels = 4;
    final selected = <Map<String, dynamic>>[];
    if (intermediates.length <= maxLabels) {
      selected.addAll(intermediates);
    } else {
      final step = intermediates.length / maxLabels;
      for (var i = 0; i < maxLabels; i++) {
        selected.add(intermediates[(i * step).floor()]);
      }
    }

    return selected.map((stop) => Marker(
      point: LatLng((stop['latitude'] as num).toDouble(), (stop['longitude'] as num).toDouble()),
      width: 150, height: 52,
      alignment: Alignment.center,
      child: _BusStopMarker(label: stop['name'].toString()),
    )).toList();
  }
}

class _TransferMarker extends StatelessWidget {
  const _TransferMarker({required this.stopName});
  final String stopName;

  static const _accent = Color(0xFFD97706);

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          color: _accent,
          borderRadius: BorderRadius.circular(6),
          boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 5, offset: Offset(0, 2))],
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.sync_alt, size: 11, color: Colors.white),
          const SizedBox(width: 3),
          Flexible(child: Text(stopName, maxLines: 1, overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white))),
        ]),
      ),
      const SizedBox(height: 1),
      const Text('Change bus', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: _accent)),
      const SizedBox(height: 2),
      Container(
        width: 26, height: 26,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: _accent, width: 2.5),
          boxShadow: [BoxShadow(color: _accent.withValues(alpha: 0.25), blurRadius: 6)],
        ),
        child: const Icon(Icons.sync_alt, size: 14, color: _accent),
      ),
    ],
  );
}

class _BusStopMarker extends StatelessWidget {
  const _BusStopMarker({required this.label, this.accent = const Color(0xFF006495)});
  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color(0xFFC0C7CD)),
          ),
          child: Text(
            label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF4B6275)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 2),
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: accent, width: 2),
            boxShadow: [BoxShadow(color: accent.withValues(alpha: 0.2), blurRadius: 5)],
          ),
          child: Icon(Icons.directions_bus, size: 13, color: accent),
        ),
      ],
    );
  }
}

// Destination marker: label bubble above a red location pin.
class _DestinationMarker extends StatelessWidget {
  const _DestinationMarker({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFAA3C1A),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 2),
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: const [BoxShadow(color: Color(0x33AA3C1A), blurRadius: 6)],
          ),
          child: const Icon(Icons.location_on, size: 20, color: Color(0xFFAA3C1A)),
        ),
      ],
    );
  }
}

// Pulsing origin badge marking the user's starting point.
class _SourceMarker extends StatelessWidget {
  const _SourceMarker();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF16806B),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [BoxShadow(color: Color(0x5516806B), blurRadius: 10, spreadRadius: 1)],
      ),
      child: const Icon(Icons.my_location, color: Colors.white, size: 20),
    );
  }
}
