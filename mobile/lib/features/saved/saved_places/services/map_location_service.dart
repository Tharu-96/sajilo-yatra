import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/nominatim_service.dart';

/// ===============================================================
/// Map Location Service
/// ---------------------------------------------------------------
/// Handles:
/// • Location permission
/// • Current device location
/// • Reverse geocoding
///
/// Used by:
/// • MapLocationPickerScreen
/// • SaveLocationScreen
/// ===============================================================

class MapLocationService {
  const MapLocationService();

  /// Default location (Kathmandu)
  static const LatLng defaultLocation = LatLng(
    27.7172,
    85.3240,
  );

  /// -------------------------------------------------------------
  /// Request permission
  /// -------------------------------------------------------------
  Future<bool> requestPermission() async {
    bool enabled =
        await Geolocator.isLocationServiceEnabled();

    if (!enabled) {
      return false;
    }

    LocationPermission permission =
        await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission =
          await Geolocator.requestPermission();
    }

    return permission ==
            LocationPermission.always ||
        permission ==
            LocationPermission.whileInUse;
  }

  /// -------------------------------------------------------------
  /// Current location
  /// -------------------------------------------------------------
  Future<LatLng> getCurrentLocation() async {
    final granted =
        await requestPermission();

    if (!granted) {
      return defaultLocation;
    }

    final position =
        await Geolocator.getCurrentPosition(
      desiredAccuracy:
          LocationAccuracy.high,
    );

    return LatLng(
      position.latitude,
      position.longitude,
    );
  }

  /// -------------------------------------------------------------
  /// Reverse Geocoding (via Nominatim / OpenStreetMap)
  /// -------------------------------------------------------------
  Future<String> getAddress(
    LatLng location,
  ) async {
    final result = await NominatimService.reverseGeocode(
      latitude: location.latitude,
      longitude: location.longitude,
    );
    return result ?? 'Unknown location';
  }
}
