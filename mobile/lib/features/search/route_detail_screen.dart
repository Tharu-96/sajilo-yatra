import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/api_service.dart';
import '../../core/location_service.dart';
import '../../core/osrm_service.dart';
import '../../core/widgets/app_tile_layer.dart';

class RouteDetailScreen extends StatefulWidget {
  final Map<String, dynamic> route;
  const RouteDetailScreen({super.key, required this.route});

  @override
  State<RouteDetailScreen> createState() => _RouteDetailScreenState();
}

class _RouteDetailScreenState extends State<RouteDetailScreen> {
  late Future<List<_BusSegment>> _segmentsFuture;

  @override
  void initState() {
    super.initState();
    _segmentsFuture = _loadBusSegments();
  }

  void _viewMap() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => _FullScreenRouteMap(
        route: widget.route,
        segmentsFuture: _segmentsFuture,
      ),
    ));
  }

  Future<List<_BusSegment>> _loadBusSegments() async {
    final legs = (widget.route['legs'] as List? ?? [])
        .whereType<Map>()
        .where((leg) => leg['mode'] == 'bus' && leg['route_id'] != null)
        .toList();
    return Future.wait(legs.map((leg) async {
      final rawPoints = await ApiService.getRouteGeometry(
        routeId: leg['route_id'].toString(),
        fromStop: leg['from_stop'].toString(),
        toStop: leg['to_stop'].toString(),
      );
      final waypoints = rawPoints.map((p) => LatLng(
        (p['latitude'] as num).toDouble(),
        (p['longitude'] as num).toDouble(),
      )).toList();
      final detailedRoute = await OsrmService.getRoute(waypoints, mode: 'driving');
      return _BusSegment(leg.cast<String, dynamic>(), detailedRoute);
    }));
  }

  @override
  Widget build(BuildContext context) {
    final route = widget.route;
    final totalFare = route['total_fare_npr'] ?? 0;
    final legs = route['legs'] as List? ?? [];
    final String fromStop = legs.isNotEmpty ? legs.first['from_stop'] : 'Origin';
    final String toStop = legs.isNotEmpty ? legs.last['to_stop'] : 'Destination';
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            Row(children: [
              IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back)),
              const SizedBox(width: 4),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Sajha Yatayat', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                Text('$fromStop → $toStop', style: const TextStyle(color: Color(0xFF667085))),
              ])),
            ]),
            const SizedBox(height: 14),
            _mapPreview(),
            const SizedBox(height: 16),
            _fareCard(totalFare, route),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: _viewMap,
              icon: const Icon(Icons.map_outlined),
              label: const Text('View Map'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mapPreview() => FutureBuilder<List<_BusSegment>>(
    future: _segmentsFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) {
        return const SizedBox(height: 170, child: Center(child: CircularProgressIndicator()));
      }
      final segments = snapshot.data ?? const <_BusSegment>[];
      final points = segments.expand((segment) => segment.latLngs).toList();
      return SizedBox(height: 170, child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: points.length < 2 ? const Center(child: Text('Route map is unavailable.')) : _RouteMap(
          segments: segments,
          route: widget.route,
        ),
      ));
    },
  );

  Widget _directions(List legs, List<_BusSegment> segments) {
    final steps = <_DirectionStep>[];
    var busSegmentIndex = 0;
    for (final rawLeg in legs) {
      final leg = rawLeg as Map;
      if (leg['mode'] != 'bus') {
        steps.add(_DirectionStep(
          Icons.directions_walk,
          'Walk to ${leg['to_stop']}',
        ));
        continue;
      }

      final segment = busSegmentIndex < segments.length
          ? segments[busSegmentIndex]
          : null;
      busSegmentIndex++;
      
      // We don't have the intermediate stops' names easily available since _BusSegment now holds latLngs.
      // We just show boarding and alighting.
      steps.add(_DirectionStep(Icons.directions_bus, 'Board at ${leg['from_stop']}'));
      steps.add(_DirectionStep(Icons.location_on, 'Get off at ${leg['to_stop']}'));
    }

    return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Directions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
      const SizedBox(height: 12),
      ...steps.map((step) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(step.icon, size: 19, color: AppColors.sapphireBlue),
            const SizedBox(width: 10),
            Expanded(child: Text(step.label, style: const TextStyle(height: 1.45))),
          ]),
        );
      }),
    ]),
  );
  }

  Widget _fareCard(dynamic totalFare, Map<String, dynamic> route) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
    child: Row(children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Total fare', style: TextStyle(color: Color(0xFF667085))),
        Text('Rs $totalFare', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
      ])),
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        const Text('Duration', style: TextStyle(color: Color(0xFF667085))),
        Text('${route['total_time_min'] ?? 0} min', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
      ]),
    ]),
  );
}

class _BusSegment {
  const _BusSegment(this.leg, this.latLngs);
  final Map<String, dynamic> leg;
  final List<LatLng> latLngs;
}

class _DirectionStep {
  const _DirectionStep(this.icon, this.label);
  final IconData icon;
  final String label;
}

class _RouteMap extends StatelessWidget {
  const _RouteMap({required this.segments, required this.route});
  final List<_BusSegment> segments;
  final Map<String, dynamic> route;

  @override
  Widget build(BuildContext context) {
    final points = segments.expand((segment) => segment.latLngs).toList();
    return FlutterMap(
      options: MapOptions(initialCenter: points.first, initialZoom: 13),
      children: [
        const AppTileLayer(),
        PolylineLayer(polylines: segments.map((segment) => Polyline(
          points: segment.latLngs,
          color: AppColors.sapphireBlue,
          strokeWidth: 4,
        )).toList()),
        ValueListenableBuilder<LatLng?>(
          valueListenable: LocationService().currentLocation,
          builder: (context, userLocation, _) {
            return FutureBuilder<_AccessWalks>(
              future: _calculateAccessWalks(route, segments, userLocation),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) return const SizedBox.shrink();
                final accessWalks = snapshot.data!;
                return PolylineLayer(polylines: _dashedPolylines(accessWalks.lines));
              },
            );
          },
        ),
        MarkerLayer(markers: [
          Marker(point: points.first, width: 38, height: 38, child: const _BusStopMarker(color: Color(0xFF16806B))),
          Marker(point: points.last, width: 38, height: 38, child: const _BusStopMarker(color: Color(0xFFAA3C1A))),
        ]),
        ValueListenableBuilder<LatLng?>(
          valueListenable: LocationService().currentLocation,
          builder: (context, userLocation, _) {
            return FutureBuilder<_AccessWalks>(
              future: _calculateAccessWalks(route, segments, userLocation),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) return const SizedBox.shrink();
                final accessWalks = snapshot.data!;
                return MarkerLayer(markers: [
                  if (accessWalks.walkToBoarding && accessWalks.userLocation != null)
                    Marker(point: accessWalks.userLocation!, width: 24, height: 24, child: const _LocationMarker(color: Colors.blue)),
                  if (accessWalks.walkFromAlighting && accessWalks.finalDestination != null)
                    Marker(point: accessWalks.finalDestination!, width: 24, height: 24, child: const _LocationMarker(color: Colors.red)),
                ]);
              },
            );
          },
        ),
      ],
    );
  }
}

class _LocationMarker extends StatelessWidget {
  const _LocationMarker({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
      border: Border.all(color: Colors.white, width: 2),
      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
    ),
  );
}

class _FullScreenRouteMap extends StatelessWidget {
  const _FullScreenRouteMap({required this.route, required this.segmentsFuture});
  final Map<String, dynamic> route;
  final Future<List<_BusSegment>> segmentsFuture;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: FutureBuilder<List<_BusSegment>>(
      future: segmentsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        final segments = snapshot.data ?? const <_BusSegment>[];
        final points = segments.expand((segment) => segment.latLngs).toList();
        if (points.length < 2) return const Center(child: Text('Route map is unavailable.'));
        return Stack(children: [
          Positioned.fill(child: _RouteMap(
            segments: segments,
            route: route,
          )),
          SafeArea(child: Padding(
            padding: const EdgeInsets.all(12),
            child: IconButton.filledTonal(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.arrow_back)),
          )),
          DraggableScrollableSheet(
            initialChildSize: .24,
            minChildSize: .15,
            maxChildSize: .70,
            builder: (context, controller) {
              return Container(
                decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                child: ValueListenableBuilder<LatLng?>(
                  valueListenable: LocationService().currentLocation,
                  builder: (context, userLocation, _) {
                    return FutureBuilder<_AccessWalks>(
                      future: _calculateAccessWalks(route, segments, userLocation),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
                        }
                        final accessWalks = snapshot.data!;
                        return ListView(controller: controller, padding: const EdgeInsets.fromLTRB(20, 10, 20, 28), children: [
                          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFCBD5E1), borderRadius: BorderRadius.circular(4)))),
                          const SizedBox(height: 14),
                          const Text('Directions', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 10),
                          if (accessWalks.walkToBoarding)
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.directions_walk, color: AppColors.sapphireBlue),
                              title: Text('Walk to ${segments.first.leg['from_stop']}'),
                              subtitle: Text('${const Distance().as(LengthUnit.Meter, accessWalks.userLocation!, segments.first.latLngs.first).ceil()} m'),
                            ),
                          ...(route['legs'] as List? ?? []).map((raw) {
                            final leg = raw as Map;
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.directions_bus, color: AppColors.sapphireBlue),
                              title: Text('Take bus: ${leg['from_stop']} → ${leg['to_stop']}'),
                              subtitle: Text('${leg['duration_min']} min'),
                            );
                          }),
                          if (accessWalks.walkFromAlighting)
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.directions_walk, color: AppColors.sapphireBlue),
                              title: const Text('Walk to destination'),
                              subtitle: Text('${const Distance().as(LengthUnit.Meter, segments.last.latLngs.last, accessWalks.finalDestination!).ceil()} m'),
                            ),
                        ]);
                      }
                    );
                  },
                ),
              );
            },
          ),
        ]);
      },
    ),
  );
}

class _AccessWalks {
  final List<List<LatLng>> lines;
  final bool walkToBoarding;
  final bool walkFromAlighting;
  final LatLng? userLocation;
  final LatLng? finalDestination;
  
  _AccessWalks({
    required this.lines,
    required this.walkToBoarding,
    required this.walkFromAlighting,
    required this.userLocation,
    required this.finalDestination,
  });
}

Future<_AccessWalks> _calculateAccessWalks(Map<String, dynamic> route, List<_BusSegment> busSegments, LatLng? userLocation) async {
  final lines = <List<LatLng>>[];
  bool walkToBoarding = false;
  bool walkFromAlighting = false;
  
  if (busSegments.isEmpty) {
    return _AccessWalks(lines: lines, walkToBoarding: false, walkFromAlighting: false, userLocation: null, finalDestination: null);
  }
  
  final boardingStop = busSegments.first.latLngs.first;
  
  final destLat = route['dest_lat'];
  final destLng = route['dest_lng'];
  LatLng? finalDestination;
  if (destLat is num && destLng is num) {
    finalDestination = LatLng(destLat.toDouble(), destLng.toDouble());
  }
  final alightingStop = busSegments.last.latLngs.last;
  
  const distance = Distance();
  
  if (userLocation != null) {
    if (distance.as(LengthUnit.Meter, userLocation, boardingStop) > 30) {
      final route = await OsrmService.getRoute([userLocation, boardingStop], mode: 'foot');
      lines.add(route);
      walkToBoarding = true;
    }
  }
  
  if (finalDestination != null) {
    if (distance.as(LengthUnit.Meter, alightingStop, finalDestination) > 30) {
      final route = await OsrmService.getRoute([alightingStop, finalDestination], mode: 'foot');
      lines.add(route);
      walkFromAlighting = true;
    }
  }
  
  return _AccessWalks(
    lines: lines,
    walkToBoarding: walkToBoarding,
    walkFromAlighting: walkFromAlighting,
    userLocation: userLocation,
    finalDestination: finalDestination,
  );
}

List<Polyline> _dashedPolylines(List<List<LatLng>> segments) {
  const dashFraction = .55;
  const dashLengthDegrees = .00035;
  final polylines = <Polyline>[];
  for (final segment in segments) {
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

class _BusStopMarker extends StatelessWidget {
  const _BusStopMarker({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
    child: Icon(Icons.directions_bus, color: color, size: 25),
  );
}
