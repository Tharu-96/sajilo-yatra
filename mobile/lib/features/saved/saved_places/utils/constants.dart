import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

/// ===============================================================
/// Saved Places Constants
/// ---------------------------------------------------------------
/// Constants used only by the Saved Places feature.
///
/// NOTE:
/// This file should contain only values that are unlikely to change.
/// Do not place business logic here.
/// ===============================================================

class SavedPlacesConstants {
  SavedPlacesConstants._();

  // ==========================================================
  // Text Limits
  // ==========================================================

  /// Maximum length of a location name.
  static const int maxLocationNameLength = 40;

  /// Maximum length of a formatted address.
  static const int maxAddressLength = 200;

  // ==========================================================
  // Search
  // ==========================================================

  /// Minimum characters before performing search.
  static const int minSearchCharacters = 2;

  /// Search debounce duration.
  static const Duration searchDebounce = Duration(
    milliseconds: 400,
  );

  // ==========================================================
  // Map
  // ==========================================================

  /// Default location (Kathmandu, Nepal).
  static const LatLng defaultLocation = LatLng(
    27.7172,
    85.3240,
  );

  /// Default zoom.
  static const double defaultZoom = 16.0;

  /// Minimum zoom.
  static const double minZoom = 5.0;

  /// Maximum zoom.
  static const double maxZoom = 20.0;

  /// Camera tilt.
  static const double defaultTilt = 0;

  /// Camera bearing.
  static const double defaultBearing = 0;

  // ==========================================================
  // Animation
  // ==========================================================

  static const Duration animationDuration = Duration(
    milliseconds: 300,
  );

  static const Duration bottomSheetDuration = Duration(
    milliseconds: 250,
  );

  // ==========================================================
  // UI
  // ==========================================================

  static const double borderRadius = 16;

  static const double cardElevation = 2;

  static const double screenPadding = 20;

  static const double cardSpacing = 16;

  static const double buttonHeight = 56;

  static const double iconSize = 24;

  static const double markerSize = 48;

  // ==========================================================
  // Map marker
  // ==========================================================

  static const String markerId = 'saved_place_marker';

  // ==========================================================
  // Default Labels
  // ==========================================================

  static const String defaultPlaceName = 'New Place';

  static const String homeLabel = 'Home';

  static const String officeLabel = 'Office';

  static const String favoriteLabel = 'Favorite';

  static const String pinLabel = 'Pinned';
}
