import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../models/selected_location.dart';
import '../services/map_location_service.dart';
import '../services/places_service.dart';

class MapLocationPickerScreen extends StatefulWidget {
  final PlaceDetails? initialPlace;

  const MapLocationPickerScreen({super.key, this.initialPlace});

  @override
  State<MapLocationPickerScreen> createState() => _MapLocationPickerScreenState();
}

class _MapLocationPickerScreenState extends State<MapLocationPickerScreen> {
  final MapLocationService _locationService = const MapLocationService();
  final MapController _mapController = MapController();

  LatLng _selectedLocation = MapLocationService.defaultLocation;
  String _selectedAddress = '';
  bool _loading = true;
  bool _loadingAddress = false;
  Timer? _cameraIdleTimer;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    if (widget.initialPlace != null) {
      final place = widget.initialPlace!;
      setState(() {
        _selectedLocation = LatLng(place.latitude, place.longitude);
        _selectedAddress = place.address;
        _loading = false;
      });
      return;
    }

    final currentLocation = await _locationService.getCurrentLocation();
    final address = await _locationService.getAddress(currentLocation);
    if (!mounted) return;
    setState(() {
      _selectedLocation = currentLocation;
      _selectedAddress = address;
      _loading = false;
    });
  }

  void _onPositionChanged(MapPosition position, bool hasGesture) {
    final center = position.center;
    if (!hasGesture || center == null) return;
    _selectedLocation = center;
    _cameraIdleTimer?.cancel();
    _cameraIdleTimer = Timer(const Duration(milliseconds: 400), _updateAddress);
  }

  Future<void> _updateAddress() async {
    if (!mounted) return;
    setState(() => _loadingAddress = true);
    try {
      final address = await _locationService.getAddress(_selectedLocation);
      if (mounted) setState(() => _selectedAddress = address);
    } finally {
      if (mounted) setState(() => _loadingAddress = false);
    }
  }

  Future<void> _moveToCurrentLocation() async {
    final location = await _locationService.getCurrentLocation();
    if (!mounted) return;
    _mapController.move(location, 17);
    setState(() => _selectedLocation = location);
    await _updateAddress();
  }

  void _confirmLocation() {
    context.push(
      '/saved/save-location',
      extra: SelectedLocation(
        latitude: _selectedLocation.latitude,
        longitude: _selectedLocation.longitude,
        address: _selectedAddress,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _selectedLocation,
              initialZoom: 17,
              onPositionChanged: _onPositionChanged,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=${dotenv.env['MAPTILER_API_KEY']}',
                userAgentPackageName: 'com.sajiloyatra.app',
                tileProvider: CancellableNetworkTileProvider(),
              ),
            ],
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Material(
                color: Colors.white,
                shape: const CircleBorder(),
                elevation: 3,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.pop(),
                ),
              ),
            ),
          ),
          IgnorePointer(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Icon(Icons.location_pin, size: 56, color: Theme.of(context).primaryColor),
              ),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 210,
            child: FloatingActionButton(
              heroTag: 'current_location',
              mini: true,
              onPressed: _moveToCurrentLocation,
              child: const Icon(Icons.my_location),
            ),
          ),
          Positioned(left: 0, right: 0, bottom: 0, child: _locationSheet()),
        ],
      ),
    );
  }

  Widget _locationSheet() => SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, -2))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Selected Location', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(16)),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Icon(Icons.location_on, color: Color(0xff0D5C8F)),
                  const SizedBox(width: 12),
                  Expanded(child: _loadingAddress
                      ? const Row(children: [SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)), SizedBox(width: 12), Text('Getting address...')])
                      : Text(_selectedAddress.isEmpty ? 'Unknown location' : _selectedAddress, style: const TextStyle(fontSize: 15))),
                ]),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  onPressed: _loadingAddress ? null : _confirmLocation,
                  style: FilledButton.styleFrom(backgroundColor: const Color(0xff0D5C8F), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  child: const Text('Confirm Location', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      );

  @override
  void dispose() {
    _cameraIdleTimer?.cancel();
    super.dispose();
  }
}
