import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../shared/widgets/elevated_card.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../core/theme/app_theme.dart';
import 'fare_breakdown_modal.dart';

class RouteDetailScreen extends StatelessWidget {
  final Map<String, dynamic> route;
  const RouteDetailScreen({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    final totalFare = route['total_fare_npr'] ?? 0;
    final legs = route['legs'] as List;
    final String fromStop = legs.isNotEmpty ? legs.first['from_stop'] : 'Origin';
    final String toStop = legs.isNotEmpty ? legs.last['to_stop'] : 'Destination';
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(27.7172, 85.3240),
              initialZoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=${dotenv.env['MAPTILER_API_KEY']}',
                userAgentPackageName: 'com.sajiloyatra.app',
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: const [
                      LatLng(27.7058, 85.3148), // Ratnapark
                      LatLng(27.6931, 85.2811), // Kalanki
                    ],
                    color: AppColors.sapphireBlue,
                    strokeWidth: 4.0,
                  ),
                ],
              ),
            ],
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.surfaceContainerHigh,
                    child: BackButton(color: AppColors.onSurface),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('$fromStop to $toStop', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Fare: Rs. $totalFare'),
                      TextButton(
                        onPressed: () => showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (context) => FareBreakdownModal(route: route),
                        ),
                        child: const Text('View Breakdown', style: TextStyle(color: AppColors.sapphireBlue)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(text: 'Start Navigation', onPressed: () {}),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
