import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../../core/api_service.dart';
import '../../core/location_service.dart';
import '../../core/theme/app_theme.dart';
import '../saved/saved_places/services/places_service.dart';

class NearbyStopsScreen extends StatefulWidget {
  const NearbyStopsScreen({super.key});

  @override
  State<NearbyStopsScreen> createState() => _NearbyStopsScreenState();
}

class _NearbyStopsScreenState extends State<NearbyStopsScreen> {
  static const _fallbackLocation = LatLng(27.7172, 85.3240);

  final MapController _mapController = MapController();
  LatLng _center = _fallbackLocation;
  List<dynamic> _stops = [];
  bool _isLoading = false;
  bool _isLocating = false;
  Map<String, dynamic>? _selectedStop;
  List<LatLng> _walkingRoute = [];
  bool _isFetchingRoute = false;
  bool _isSearchVisible = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadCurrentLocation();
  }

  Future<void> _loadCurrentLocation() async {
    final savedLocation = LocationService().currentLocation.value;
    if (savedLocation != null) {
      _updateCenter(savedLocation);
      return;
    }

    setState(() => _isLocating = true);
    var locationUpdated = false;
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        await Geolocator.openLocationSettings();
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final location = LatLng(position.latitude, position.longitude);
      LocationService().updateLocation(location);
      locationUpdated = true;
      _updateCenter(location);
    } catch (_) {
      // The fallback center is used if the browser/device cannot provide GPS.
    } finally {
      if (mounted) setState(() => _isLocating = false);
      if (!locationUpdated && mounted) await _fetchStops();
    }
  }

  void _updateCenter(LatLng location) {
    if (!mounted) return;
    setState(() => _center = location);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _mapController.move(location, 14);
    });
    _fetchStops();
  }

  Future<void> _fetchStops() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final stops = await ApiService.getNearbyStops(
        lat: _center.latitude,
        lng: _center.longitude,
        radiusMeters: 1000,
      );
      if (!mounted) return;
      setState(() {
        _stops = stops;
        _isLoading = false;
      });
      if (stops.isEmpty && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('sorry stops not found, search the location within the kathmandu valley only')),
        );
      }
    } catch (e) {
      if (!mounted) return;
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

  Future<void> _handleSearch(String query) async {
    if (query.trim().isEmpty) return;
    setState(() => _isLoading = true);
    try {
      final predictions = await PlacesService.autocomplete(query);
      if (predictions.isEmpty) {
        throw Exception("Location not found");
      }
      final details = await PlacesService.getPlaceDetails(predictions.first.placeId);
      final location = LatLng(details.latitude, details.longitude);
      setState(() => _isSearchVisible = false);
      _updateCenter(location);
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('sorry stops not found, search the location within the kathmandu valley only')),
        );
      }
    }
  }

  Future<void> _fetchWalkingRoute(LatLng destination) async {
    setState(() => _isFetchingRoute = true);
    try {
      final url = Uri.parse(
        'https://router.project-osrm.org/route/v1/foot/'
        '${_center.longitude},${_center.latitude};'
        '${destination.longitude},${destination.latitude}'
        '?geometries=geojson&overview=full',
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final routes = data['routes'] as List<dynamic>;
        if (routes.isNotEmpty) {
          final coords = (routes[0]['geometry']['coordinates'] as List<dynamic>)
              .map((c) => LatLng(
                    ((c as List<dynamic>)[1] as num).toDouble(),
                    (c[0] as num).toDouble(),
                  ))
              .toList();
          if (mounted) setState(() => _walkingRoute = coords);
        }
      }
    } catch (_) {
      // Silently ignore; user can retry by tapping Get Directions again.
    } finally {
      if (mounted) setState(() => _isFetchingRoute = false);
    }
  }

  String _walkLabel(Map<String, dynamic> stop) {
    final lat = (stop['latitude'] as num).toDouble();
    final lng = (stop['longitude'] as num).toDouble();
    final distM = Geolocator.distanceBetween(
      _center.latitude, _center.longitude, lat, lng,
    );
    final mins = (distM / 80).ceil();
    return '$mins min walk · ~${distM.round()} m';
  }

  void _selectStop(Map<String, dynamic> stop) {
    setState(() {
      _selectedStop = stop;
      _walkingRoute = [];
    });
    final lat = (stop['latitude'] as num).toDouble();
    final lng = (stop['longitude'] as num).toDouble();
    _mapController.move(LatLng(lat, lng), _mapController.camera.zoom);
  }

  void _dismissPopup() {
    setState(() {
      _selectedStop = null;
      _walkingRoute = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selectedStop;
    // Offset FABs above the pill navbar (64px height + 20px bottom margin + 16px gap)
    final navbarClearance = 64.0 + 20.0 + 16.0;
    final fabBottom = selected != null ? navbarClearance + 246.0 : navbarClearance;

    return Scaffold(
      body: Stack(
        children: [
          // ── Map ───────────────────────────────────────────────────────────
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: 14.0,
              interactionOptions: const InteractionOptions(flags: InteractiveFlag.all),
              onTap: (_, __) => _dismissPopup(),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=${dotenv.env['MAPTILER_API_KEY']}',
                userAgentPackageName: 'com.sajiloyatra.app',
                tileProvider: CancellableNetworkTileProvider(),
              ),
              if (_walkingRoute.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _walkingRoute,
                      color: AppColors.sapphireBlue,
                      strokeWidth: 4.5,
                    ),
                  ],
                ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _center,
                    child: const Icon(Icons.person_pin_circle, color: AppColors.electricTeal, size: 40),
                  ),
                  ..._stops.map((stop) {
                    final s = stop as Map<String, dynamic>;
                    final lat = (s['latitude'] as num).toDouble();
                    final lng = (s['longitude'] as num).toDouble();
                    final isSelected = selected != null && selected['id'] == s['id'];
                    return Marker(
                      point: LatLng(lat, lng),
                      child: GestureDetector(
                        onTap: () => _selectStop(s),
                        child: Image.asset(
                          'assets/icons/bus_stop.png',
                          width: isSelected ? 40 : 32,
                          height: isSelected ? 40 : 32,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),

          // ── Header card ───────────────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Nearby Stops',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.search),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  setState(() {
                                    _isSearchVisible = !_isSearchVisible;
                                  });
                                },
                              ),
                              const SizedBox(width: 12),
                              if (_isLoading)
                                const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
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
                        ],
                      ),
                      if (_isSearchVisible) ...[
                        const SizedBox(height: 12),
                        TextField(
                          controller: _searchController,
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: 'Search location...',
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.search, size: 20),
                              onPressed: () => _handleSearch(_searchController.text),
                            ),
                          ),
                          onSubmitted: _handleSearch,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── FAB column ────────────────────────────────────────────────────
          Positioned(
            right: 16,
            bottom: fabBottom,
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton.small(
                    heroTag: 'nearby_zoom_in',
                    tooltip: 'Zoom in',
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.sapphireBlue,
                    elevation: 4,
                    onPressed: () => _mapController.move(
                      _mapController.camera.center,
                      _mapController.camera.zoom + 1,
                    ),
                    child: const Icon(Icons.add),
                  ),
                  const SizedBox(height: 6),
                  FloatingActionButton.small(
                    heroTag: 'nearby_zoom_out',
                    tooltip: 'Zoom out',
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.sapphireBlue,
                    elevation: 4,
                    onPressed: () => _mapController.move(
                      _mapController.camera.center,
                      _mapController.camera.zoom - 1,
                    ),
                    child: const Icon(Icons.remove),
                  ),

                ],
              ),
            ),
          ),

          // ── Stop popup card ────────────────────────────────────────────────
          if (selected != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 90,
              child: SafeArea(
                top: false,
                child: _StopPopupCard(
                  stop: selected,
                  walkLabel: _walkLabel(selected),
                  isFetchingRoute: _isFetchingRoute,
                  hasRoute: _walkingRoute.isNotEmpty,
                  onDismiss: _dismissPopup,
                  onGetDirections: () {
                    final lat = (selected['latitude'] as num).toDouble();
                    final lng = (selected['longitude'] as num).toDouble();
                    _fetchWalkingRoute(LatLng(lat, lng));
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Popup card ────────────────────────────────────────────────────────────────

class _StopPopupCard extends StatelessWidget {
  final Map<String, dynamic> stop;
  final String walkLabel;
  final bool isFetchingRoute;
  final bool hasRoute;
  final VoidCallback onDismiss;
  final VoidCallback onGetDirections;

  const _StopPopupCard({
    required this.stop,
    required this.walkLabel,
    required this.isFetchingRoute,
    required this.hasRoute,
    required this.onDismiss,
    required this.onGetDirections,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppRadius.card),
      elevation: 8,
      shadowColor: Colors.black26,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _BusStopChip(),
                const Spacer(),
                GestureDetector(
                  onTap: onDismiss,
                  child: const Icon(Icons.close, size: 20, color: AppColors.outline),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              stop['name'] as String? ?? 'Unknown Stop',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.onSurface),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.directions_walk, color: AppColors.sapphireBlue, size: 18),
                const SizedBox(width: 6),
                Text(walkLabel, style: const TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 10),
            // Tapping this row draws the walking route on the map.
            InkWell(
              onTap: isFetchingRoute ? null : onGetDirections,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    if (isFetchingRoute)
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.sapphireBlue),
                      )
                    else
                      Icon(hasRoute ? Icons.check_circle_outline : Icons.directions,
                          color: AppColors.sapphireBlue, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      isFetchingRoute
                          ? 'Loading route...'
                          : hasRoute
                              ? 'Route Shown on Map'
                              : 'Get Direction',
                      style: const TextStyle(
                        color: AppColors.sapphireBlue,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 4),
                    if (!isFetchingRoute)
                      const Icon(Icons.chevron_right, size: 18, color: AppColors.sapphireBlue),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BusStopChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryBright,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/icons/bus_stop.png',
            width: 12,
            height: 12,
          ),
          SizedBox(width: 4),
          Text(
            'BUS STOP',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.sapphireBlue,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

