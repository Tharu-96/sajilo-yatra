import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/elevated_card.dart';
import '../../core/api_service.dart';
import 'dart:io';

class RouteResultsScreen extends StatefulWidget {
  final Map<String, dynamic> searchData;

  const RouteResultsScreen({
    super.key,
    required this.searchData,
  });

  @override
  State<RouteResultsScreen> createState() => _RouteResultsScreenState();
}

class _RouteResultsScreenState extends State<RouteResultsScreen> {
  late Future<Map<String, dynamic>> _routesFuture;

  @override
  void initState() {
    super.initState();
    _fetchRoutes();
  }

  void _fetchRoutes() {
    _routesFuture = ApiService.searchRoutes(
      originLat: widget.searchData['originLat'] ?? 27.7058,
      originLng: widget.searchData['originLng'] ?? 85.3148,
      destLat: widget.searchData['destLat'] ?? 27.6931,
      destLng: widget.searchData['destLng'] ?? 85.2811,
    );
    _routesFuture.catchError((e) {
      if (mounted) {
        if (e is SocketException || e.toString().contains('SocketException') || e.toString().contains('ClientException')) {
          context.pushReplacement('/no-internet', extra: () {
             if (mounted) {
                context.pushReplacement('/results', extra: widget.searchData);
             }
          });
        } else {
          context.pushReplacement('/error-empty', extra: {
            'title': 'Error',
            'message': e.toString(),
            'actionLabel': 'Retry',
            'onAction': () {
              if (mounted) {
                 context.pushReplacement('/results', extra: widget.searchData);
              }
            }
          });
        }
      }
      throw e;
    });
  }

  @override
  Widget build(BuildContext context) {
    final from = widget.searchData['from'] ?? 'Unknown';
    final to = widget.searchData['to'] ?? 'Unknown';
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FE),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF00557E), Color(0xFF0088CC)]),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
                boxShadow: [BoxShadow(color: Color(0x33006495), blurRadius: 14, offset: Offset(0, 5))],
              ),
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
              child: Row(children: [
                IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back, color: Colors.white)),
                Expanded(child: Column(children: [
                  const Text('SAJILO YATRA', style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.w800, color: Colors.white, fontSize: 16)),
                  const SizedBox(height: 3),
                  Text('$from → $to', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11.5, color: Color(0xFFCDE6F5))),
                ])),
                const SizedBox(width: 48),
              ]),
            ),
            Expanded(child: FutureBuilder<Map<String, dynamic>>(
              future: _routesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return _buildSkeleton();
                if (snapshot.hasError) return const SizedBox();
                final routes = (snapshot.data?['results'] as List? ?? []);
                return Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(color: Color(0xFFEFF4FA), border: Border(top: BorderSide(color: Color(0xFFD5DCE5)))),
                  child: ListView(padding: const EdgeInsets.fromLTRB(18, 18, 18, 24), children: [
                    Row(children: [
                      const Icon(Icons.alt_route_rounded, size: 20, color: Color(0xFF006495)),
                      const SizedBox(width: 7),
                      const Expanded(child: Text('Suggested Routes', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF172235)))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFFDCEBF7), borderRadius: BorderRadius.circular(20)),
                        child: Text('${routes.length} Found', style: const TextStyle(fontSize: 11, color: Color(0xFF006495), fontWeight: FontWeight.w700)),
                      ),
                    ]),
                    const SizedBox(height: 16),
                    ...routes.asMap().entries.map((e) => Padding(padding: const EdgeInsets.only(bottom: 14), child: _referenceCard(context, e.value as Map<String, dynamic>))),
                    if (routes.isNotEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Center(
                          child: Text(
                            'No more routes',
                            style: TextStyle(fontSize: 10, letterSpacing: 1, color: Color(0xFF77808D)),
                          ),
                        ),
                      ),
                  ]),
                );
              },
            )),
          ],
        ),
      ),
    );
  }

  Widget _referenceCard(BuildContext context, Map<String, dynamic> route) {
    final legs = (route['legs'] as List).where((leg) => leg['mode'] == 'bus').toList();
    final directions = legs.map((leg) => '${leg['from_stop']} → ${leg['to_stop']}').toList();
    final transfers = route['transfer_count'] as num? ?? 0;
    final walking = (route['walking_distance_km'] as num? ?? 0).toStringAsFixed(1);
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => context.push('/bus-options', extra: route),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE1E7EF)),
          boxShadow: [BoxShadow(color: const Color(0xFF006495).withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 6))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                RichText(text: TextSpan(style: const TextStyle(color: Color(0xFF0F1B2D)), children: [
                  TextSpan(text: '${route['total_time_min']}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, height: 1)),
                  const TextSpan(text: '  min', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF667085))),
                ])),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF006495), Color(0xFF0088CC)]),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [BoxShadow(color: const Color(0xFF006495).withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 3))],
                  ),
                  child: Text('Rs. ${route['total_fare_npr']}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                ),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                _metricChip(Icons.directions_walk_rounded, '$walking km'),
                const SizedBox(width: 8),
                _metricChip(Icons.swap_horiz_rounded, '$transfers ${transfers == 1 ? 'transfer' : 'transfers'}', highlight: transfers == 0),
              ]),
              const SizedBox(height: 14),
              _journey(directions),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _metricChip(IconData icon, String label, {bool highlight = false}) {
    final color = highlight ? const Color(0xFF00A36C) : const Color(0xFF5D6876);
    final bg = highlight ? const Color(0xFFE6F7EF) : const Color(0xFFF1F4F9);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 5),
        Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
      ]),
    );
  }

  Widget _journey(List directions) {
    return LayoutBuilder(builder: (context, c) => Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8EEF5)),
      ),
      child: Wrap(
        spacing: 6,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Icon(Icons.trip_origin, color: Color(0xFF006495), size: 15),
          for (var i = 0; i < directions.length; i++) ...[
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: c.maxWidth - 60),
              child: _legPill(directions[i], i),
            ),
            if (i < directions.length - 1)
              const Icon(Icons.arrow_forward_rounded, size: 13, color: Color(0xFFAAB4C0)),
          ],
          const Icon(Icons.place, color: Color(0xFFE5484D), size: 16),
        ],
      ),
    ));
  }

  Widget _legPill(String direction, int index) {
    const palette = [Color(0xFF006495), Color(0xFF0E9F6E), Color(0xFFB4690E)];
    final color = palette[index % palette.length];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        border: Border.all(color: color.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.directions_bus_rounded, size: 12, color: color),
        const SizedBox(width: 5),
        Flexible(child: Text(direction, maxLines: 1, overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color))),
      ]),
    );
  }

  Widget _buildSkeleton() {
    return ListView.builder(
      padding: const EdgeInsets.all(20.0),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: ElevatedCard(
            child: Opacity(
              opacity: 0.3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 20, width: 100, color: Theme.of(context).colorScheme.surfaceContainerHigh),
                  const SizedBox(height: 8),
                  Container(height: 16, width: double.infinity, color: Theme.of(context).colorScheme.surfaceContainerHigh),
                  const SizedBox(height: 16),
                  Container(height: 24, width: double.infinity, color: Theme.of(context).colorScheme.surfaceContainerHigh),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
