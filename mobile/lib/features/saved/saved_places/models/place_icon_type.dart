import 'package:flutter/material.dart';

/// ===============================================================
/// Place Icon Type
/// ---------------------------------------------------------------
/// Defines the available icons for a saved location.
///
/// These values are stored in the model and later converted into
/// Material icons for display.
///
/// ===============================================================

enum PlaceIconType {
  home,
  office,
  favorite,
  pin,
}

/// Extension for converting PlaceIconType into Material Icons.
extension PlaceIconTypeExtension on PlaceIconType {
  /// Display label
  String get label {
    switch (this) {
      case PlaceIconType.home:
        return 'Home';

      case PlaceIconType.office:
        return 'Office';

      case PlaceIconType.favorite:
        return 'Favorite';

      case PlaceIconType.pin:
        return 'Pinned';
    }
  }

  /// Material icon
  IconData get icon {
    switch (this) {
      case PlaceIconType.home:
        return Icons.home_rounded;

      case PlaceIconType.office:
        return Icons.work_rounded;

      case PlaceIconType.favorite:
        return Icons.favorite_rounded;

      case PlaceIconType.pin:
        return Icons.location_pin;
    }
  }

  /// Value stored in database/API
  String get value {
    switch (this) {
      case PlaceIconType.home:
        return 'home';

      case PlaceIconType.office:
        return 'office';

      case PlaceIconType.favorite:
        return 'favorite';

      case PlaceIconType.pin:
        return 'pin';
    }
  }

  /// Convert database value into enum.
  static PlaceIconType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'home':
        return PlaceIconType.home;

      case 'office':
        return PlaceIconType.office;

      case 'favorite':
        return PlaceIconType.favorite;

      case 'pin':
        return PlaceIconType.pin;

      default:
        return PlaceIconType.pin;
    }
  }
}