import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/input_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../core/api_service.dart';
import '../../core/location_service.dart';
import '../../core/nominatim_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../../core/widgets/app_tile_layer.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  late final TextEditingController _fromController;
  final TextEditingController _toController = TextEditingController(text: '');
  LatLng? _gpsOrigin;
  LatLng? _gpsDestination;
  bool _settingGpsText = false;

  final MapController _mapController = MapController();
  static const _fallbackCenter = LatLng(27.7172, 85.3240);

  Map<String, dynamic>? _selectedFromStop;
  Map<String, dynamic>? _selectedToStop;

  Timer? _fromDebounce;
  int _fromRequestId = 0;
  Timer? _toDebounce;
  int _toRequestId = 0;

  @override
  void initState() {
    super.initState();
    _fromController = TextEditingController();
    _fromController.addListener(_onFromEdited);
    _toController.addListener(_onToEdited);
    _detectCurrentLocation();
  }

  void _onFromEdited() {
    if (!_settingGpsText) {
      _gpsOrigin = null;
      if (_selectedFromStop != null && _fromController.text != _selectedFromStop!['name']) {
        _selectedFromStop = null;
      }
    }
  }

  void _onToEdited() {
    if (_settingGpsText) return;
    if (_selectedToStop != null && _toController.text != _selectedToStop!['name']) {
      _selectedToStop = null;
    }
    // GPS destination is invalidated as soon as the user manually edits the field
    _gpsDestination = null;
  }

  Future<void> _detectCurrentLocation() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return;
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );
      final location = LatLng(position.latitude, position.longitude);
      LocationService().updateLocation(location);
      final areaName = await NominatimService.reverseGeocode(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      if (!mounted || areaName == null || _fromController.text.isNotEmpty) return;
      _settingGpsText = true;
      _gpsOrigin = location;
      _fromController.text = areaName;
      _settingGpsText = false;
      _fitMapToPoints();
    } catch (_) {
      // GPS/reverse-geocoding is an optional convenience; manual search stays available.
    }
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _fromDebounce?.cancel();
    _toDebounce?.cancel();
    super.dispose();
  }

  Future<Iterable<Map<String, dynamic>>> _searchFrom(String query) async {
    if (query.length < 2) return const Iterable.empty();

    final completer = Completer<Iterable<Map<String, dynamic>>>();
    _fromDebounce?.cancel();
    _fromRequestId++;
    final currentRequestId = _fromRequestId;

    _fromDebounce = Timer(const Duration(milliseconds: 300), () async {
      try {
        final results = await ApiService.searchStops(query);
        if (mounted && _fromRequestId == currentRequestId) {
          completer.complete(results);
        } else if (!completer.isCompleted) {
          completer.complete(const Iterable.empty());
        }
      } catch (e) {
        if (!completer.isCompleted) {
          completer.complete(const Iterable.empty());
        }
      }
    });

    return completer.future;
  }

  Future<Iterable<Map<String, dynamic>>> _searchTo(String query) async {
    if (query.length < 2) return const Iterable.empty();

    final completer = Completer<Iterable<Map<String, dynamic>>>();
    _toDebounce?.cancel();
    _toRequestId++;
    final currentRequestId = _toRequestId;

    _toDebounce = Timer(const Duration(milliseconds: 300), () async {
      try {
        final results = await ApiService.searchStops(query);
        if (mounted && _toRequestId == currentRequestId) {
          completer.complete(results);
        } else if (!completer.isCompleted) {
          completer.complete(const Iterable.empty());
        }
      } catch (e) {
        if (!completer.isCompleted) {
          completer.complete(const Iterable.empty());
        }
      }
    });

    return completer.future;
  }

  Future<void> _findRoutes() async {
    final fromText = _fromController.text.trim();
    final toText = _toController.text.trim();
    final isCurrentLocation = _gpsOrigin != null;

    if (fromText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your source location.')),
      );
      return;
    }
    if (toText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your destination.')),
      );
      return;
    }

    // Selecting a suggestion gives us its coordinates immediately, but an
    // exact stop name typed by the user needs to be resolved before we can
    // search.  Do not require users to tap a suggestion for a valid stop.
    Map<String, dynamic>? fromStop = _selectedFromStop;
    Map<String, dynamic>? toStop = _selectedToStop;
    try {
      if (!isCurrentLocation && fromStop == null) {
        fromStop = await ApiService.resolveStop(fromText);
      }
      if (_gpsDestination == null && toStop == null) {
        toStop = await ApiService.resolveStop(toText);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to validate locations. Please try again.'),
          ),
        );
      }
      return;
    }

    if (!mounted) return;
    final hasInvalidSource = !isCurrentLocation && fromStop == null;
    final hasInvalidDestination = toStop == null && _gpsDestination == null;

    if (hasInvalidSource || hasInvalidDestination) {
      final message = hasInvalidSource && hasInvalidDestination
          ? 'The source and destination stops could not be found. Check the spelling or choose from the suggestions.'
          : hasInvalidSource
              ? 'The source stop could not be found. Check the spelling or choose from the suggestions.'
              : 'The destination stop could not be found. Check the spelling or choose from the suggestions.';

      context.push('/error-empty', extra: {
        'title': 'Location not found',
        'message': message,
        'actionLabel': 'Try again',
        'onAction': () => context.pop(),
      });
      return;
    }

    setState(() {
      _selectedFromStop = fromStop;
      _selectedToStop = toStop;
    });

    context.push('/results', extra: {
      'from': fromText,
      'to': toText,
      'originLat': isCurrentLocation
          ? _gpsOrigin!.latitude
          : (fromStop!['latitude'] as num).toDouble(),
      'originLng': isCurrentLocation
          ? _gpsOrigin!.longitude
          : (fromStop!['longitude'] as num).toDouble(),
      'destLat': toStop != null
          ? (toStop['latitude'] as num).toDouble()
          : _gpsDestination!.latitude,
      'destLng': toStop != null
          ? (toStop['longitude'] as num).toDouble()
          : _gpsDestination!.longitude,
    });
  }

  Widget _buildAutocomplete({
    required String hintText,
    required IconData icon,
    required TextEditingController controller,
    required Future<Iterable<Map<String, dynamic>>> Function(String) searchFunc,
    required void Function(Map<String, dynamic>) onSelected,
  }) {
    return RawAutocomplete<Map<String, dynamic>>(
      textEditingController: controller,
      focusNode: FocusNode(),
      displayStringForOption: (option) => option['name'] as String,
      optionsBuilder: (textEditingValue) => searchFunc(textEditingValue.text),
      onSelected: onSelected,
      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
        return InputField(
          hintText: hintText,
          prefixIcon: icon,
          controller: textEditingController,
          focusNode: focusNode,
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            clipBehavior: Clip.antiAlias,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final option = options.elementAt(index);
                  return InkWell(
                    onTap: () => onSelected(option),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Text(option['name'] as String),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  LatLng? get _originLatLng {
    if (_selectedFromStop != null) {
      return LatLng(
        (_selectedFromStop!['latitude'] as num).toDouble(),
        (_selectedFromStop!['longitude'] as num).toDouble(),
      );
    }
    return _gpsOrigin;
  }

  LatLng? get _destinationLatLng {
    if (_selectedToStop != null) {
      return LatLng(
        (_selectedToStop!['latitude'] as num).toDouble(),
        (_selectedToStop!['longitude'] as num).toDouble(),
      );
    }
    return _gpsDestination;
  }

  void _fitMapToPoints() {
    final origin = _originLatLng;
    final dest = _destinationLatLng;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (origin != null && dest != null) {
        _mapController.fitCamera(
          CameraFit.bounds(
            bounds: LatLngBounds(origin, dest),
            padding: const EdgeInsets.all(48),
          ),
        );
      } else if (origin != null) {
        _mapController.move(origin, 14);
      } else if (dest != null) {
        _mapController.move(dest, 14);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.centerRight,
              children: [
                Column(
                  children: [
                    _buildAutocomplete(
                      hintText: 'From',
                      icon: Icons.my_location,
                      controller: _fromController,
                      searchFunc: _searchFrom,
                      onSelected: (option) {
                        setState(() {
                          _selectedFromStop = option;
                        });
                        _fitMapToPoints();
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildAutocomplete(
                      hintText: 'To',
                      icon: Icons.location_on,
                      controller: _toController,
                      searchFunc: _searchTo,
                      onSelected: (option) {
                        setState(() {
                          _selectedToStop = option;
                        });
                        _fitMapToPoints();
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.swap_vert, color: Color(0xFF667085)),
                      onPressed: () {
                        setState(() {
                          // Guard listeners so programmatic text changes don't wipe GPS state
                          _settingGpsText = true;
                          final tempText = _fromController.text;
                          _fromController.text = _toController.text;
                          _toController.text = tempText;
                          _settingGpsText = false;

                          final tempStop = _selectedFromStop;
                          _selectedFromStop = _selectedToStop;
                          _selectedToStop = tempStop;

                          // Carry GPS coords to the destination slot when swapped away from source
                          _gpsDestination = _gpsOrigin;
                          _gpsOrigin = null;
                        });
                        _fitMapToPoints();
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              text: 'Find Routes',
              onPressed: _findRoutes,
            ),
            const SizedBox(height: 24),
            Expanded(child: _buildMap()),
          ],
        ),
      ),
    );
  }

  Widget _buildMap() {
    final origin = _originLatLng;
    final dest = _destinationLatLng;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: origin ?? dest ?? _fallbackCenter,
              initialZoom: 13,
              interactionOptions: const InteractionOptions(flags: InteractiveFlag.all),
            ),
            children: [
              const AppTileLayer(),
              MarkerLayer(
                markers: [
                  if (origin != null)
                    Marker(
                      point: origin,
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.my_location, color: Color(0xFF00B8A9), size: 34),
                    ),
                  if (dest != null)
                    Marker(
                      point: dest,
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.location_on, color: Color(0xFFE53935), size: 38),
                    ),
                ],
              ),
            ],
          ),
          Positioned(
            right: 8,
            bottom: 8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton.small(
                  heroTag: 'picker_zoom_in',
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF1F5FA8),
                  elevation: 3,
                  onPressed: () => _mapController.move(
                    _mapController.camera.center,
                    _mapController.camera.zoom + 1,
                  ),
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 6),
                FloatingActionButton.small(
                  heroTag: 'picker_zoom_out',
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF1F5FA8),
                  elevation: 3,
                  onPressed: () => _mapController.move(
                    _mapController.camera.center,
                    _mapController.camera.zoom - 1,
                  ),
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
