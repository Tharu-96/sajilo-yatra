import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();

  factory LocationService() {
    return _instance;
  }

  LocationService._internal();

  final ValueNotifier<LatLng?> currentLocation = ValueNotifier<LatLng?>(null);

  void updateLocation(LatLng newLocation) {
    currentLocation.value = newLocation;
  }
}
