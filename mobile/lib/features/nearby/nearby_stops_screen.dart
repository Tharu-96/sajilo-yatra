import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../core/theme/app_theme.dart';
import '../../core/api_service.dart';
import '../../core/location_service.dart';
import '../../shared/widgets/route_chip.dart';

class NearbyStopsScreen extends StatefulWidget {
  const NearbyStopsScreen({super.key});

  @override
  State<NearbyStopsScreen> createState() => _NearbyStopsScreenState();
}

class _NearbyStopsScreenState extends State<NearbyStopsScreen> {
  late final LatLng _center;
  List<dynamic> _stops = [];
  bool _isLoading = false;
  int _selectedRadius = 100;
  final List<int> _radii = [100, 200, 300, 400, 500];

  @override
  void initState() {
    super.initState();
    _center = LocationService().currentLocation.value ?? const LatLng(27.7172, 85.3240);
    _fetchStops();
  }

  Future<void> _fetchStops() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final stops = await ApiService.getNearbyStops(
        lat: _center.latitude,
        lng: _center.longitude,
        radiusMeters: _selectedRadius,
      );
      setState(() {
        _stops = stops;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _onRadiusSelected(int radius) {
    if (_selectedRadius != radius) {
      setState(() {
        _selectedRadius = radius;
      });
      _fetchStops();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: _center,
              initialZoom: 15.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=${dotenv.env['MAPTILER_API_KEY']}',
                userAgentPackageName: 'com.sajiloyatra.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _center,
                    child: const Icon(Icons.person_pin_circle, color: AppColors.electricTeal, size: 40),
                  ),
                  ..._stops.map((stop) {
                    final lat = stop['latitude'] as double;
                    final lng = stop['longitude'] as double;
                    return Marker(
                      point: LatLng(lat, lng),
                      child: const Icon(Icons.location_on, color: AppColors.sapphireBlue, size: 30),
                    );
                  }).toList(),
                ],
              ),
            ],
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Nearby Stops',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            if (_isLoading)
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            else
                              Text(
                                '${_stops.length} found',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _radii.map((r) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: RouteChip(
                                  label: '${r}m',
                                  isSelected: _selectedRadius == r,
                                  onTap: () => _onRadiusSelected(r),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (_stops.isNotEmpty)
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(AppRadius.card),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),
                      child: ListView.builder(
                        itemCount: _stops.length,
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          final stop = _stops[index];
                          return ListTile(
                            leading: const Icon(Icons.directions_bus, color: AppColors.sapphireBlue),
                            title: Text(stop['name'] ?? 'Unknown Stop'),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
