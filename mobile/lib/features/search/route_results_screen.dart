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
      preference: widget.searchData['preference'] ?? 'fastest',
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
    final routes = busLegs.map((l) => l['route_id'].toString()).toList();

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
