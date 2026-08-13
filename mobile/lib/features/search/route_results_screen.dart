import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/elevated_card.dart';
import '../../../shared/widgets/route_chip.dart';
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
      preference: widget.searchData['preference'] ?? 'shortest',
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
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
              child: Row(children: [
                IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back, color: Color(0xFF005F8D))),
                Expanded(child: Column(children: [
                  const Text('SAJILO YATRA', style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.w700, color: Color(0xFF005F8D), fontSize: 16)),
                  Text('$from → $to', style: const TextStyle(fontSize: 11, color: Color(0xFF667085))),
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
                  child: ListView(padding: const EdgeInsets.fromLTRB(18, 16, 18, 24), children: [
                    Row(children: [
                      const Expanded(child: Text('Suggested Routes', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700))),
                      Text('${routes.length} Found', style: const TextStyle(fontSize: 11, color: Color(0xFF006495), fontWeight: FontWeight.w700)),
                    ]),
                    const SizedBox(height: 14),
                    ...routes.map((route) => Padding(padding: const EdgeInsets.only(bottom: 14), child: _referenceCard(context, route as Map<String, dynamic>))),
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
      borderRadius: BorderRadius.circular(10),
      onTap: () => context.push('/bus-options', extra: route),
      child: Container(
        padding: const EdgeInsets.fromLTRB(13, 13, 13, 12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFF8994A3)), boxShadow: const [BoxShadow(color: Color(0x16006495), blurRadius: 4, offset: Offset(-3, 1))]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            RichText(text: TextSpan(style: const TextStyle(color: Color(0xFF172235)), children: [TextSpan(text: '${route['total_time_min']}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)), const TextSpan(text: ' min', style: TextStyle(fontSize: 12))])),
            const Spacer(),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('🚶 $walking km', style: const TextStyle(fontFamily: 'monospace', fontSize: 11)),
              const SizedBox(height: 4), Text('♟ $transfers ${transfers == 1 ? 'transfer' : 'transfers'}', style: const TextStyle(fontFamily: 'monospace', fontSize: 11)),
            ]),
          ]),
          const SizedBox(height: 7),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3), decoration: BoxDecoration(border: Border.all(color: const Color(0xFF006495)), borderRadius: BorderRadius.circular(20)), child: Text('Rs. ${route['total_fare_npr']}', style: const TextStyle(color: Color(0xFF005F8D), fontFamily: 'monospace', fontSize: 11))),
          const SizedBox(height: 12),
          LayoutBuilder(builder: (context, constraints) => Wrap(
            spacing: 6,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Icon(Icons.circle_outlined, color: Color(0xFF006495), size: 14),
              ...directions.map((direction) => ConstrainedBox(
                constraints: BoxConstraints(maxWidth: constraints.maxWidth - 28),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF8A96A5)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(direction, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 11, color: Color(0xFF405064))),
                ),
              )),
              const Icon(Icons.circle, color: Color(0xFF006495), size: 12),
            ],
          )),
        ]),
      ),
    );
  }

  Widget _legacyBuild(BuildContext context) {
    final from = widget.searchData['from'] ?? 'Unknown';
    final to = widget.searchData['to'] ?? 'Unknown';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('$from → $to'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _routesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildSkeleton();
          } else if (snapshot.hasError) {
            return const SizedBox(); // Handled by catchError navigation
          } else if (snapshot.hasData) {
            final results = snapshot.data!['results'] as List;
            return ListView.builder(
              padding: const EdgeInsets.all(20.0),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final route = results[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _buildResultCard(context, route),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
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

  Widget _buildResultCard(BuildContext context, Map<String, dynamic> route) {
    final label = route['label'] ?? 'Route';
    final time = '${route['total_time_min']} min';
    final fare = 'Rs. ${route['total_fare_npr']}';
    final transferCount = route['transfer_count'];
    final walkingDist = (route['walking_distance_km'] as num).toStringAsFixed(1);
    final details = '$transferCount transfers • ${walkingDist}km walk';
    
    final legs = route['legs'] as List;
    final busLegs = legs.where((leg) => leg['mode'] == 'bus').toList();
    final routes = busLegs.map((l) => '${l['from_stop']} → ${l['to_stop']}').toList();

    return GestureDetector(
      onTap: () => context.push('/bus-options', extra: route),
      child: ElevatedCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  time,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(details, style: TextStyle(color: Theme.of(context).colorScheme.outline)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: routes.map((r) => Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: RouteChip(label: r),
                  )).toList(),
                ),
                Text(
                  fare,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
