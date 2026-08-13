import 'constants.dart';

/// ===============================================================
/// Saved Places Validators
/// ---------------------------------------------------------------
/// Validation helper methods for the Saved Places feature.
///
/// This class contains only pure validation logic and has no
/// dependency on Flutter widgets or Riverpod.
/// ===============================================================

class SavedPlacesValidators {
  SavedPlacesValidators._();

  /// Removes unnecessary whitespace.
  static String normalize(String value) {
    return value.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  /// Returns true if two names are equal after normalization.
  static bool isSameName(String first, String second) {
    return normalize(first).toLowerCase() ==
        normalize(second).toLowerCase();
  }

  /// Validates the location name.
  ///
  /// Returns null when valid.
  static String? validateLocationName(String? value) {
    final name = normalize(value ?? '');

    if (name.isEmpty) {
      return 'Please enter a location name.';
    }

    if (name.length >
        SavedPlacesConstants.maxLocationNameLength) {
      return 'Location name must be less than '
          '${SavedPlacesConstants.maxLocationNameLength} characters.';
    }

    return null;
  }

  /// Validates the address.
  ///
  /// Returns null when valid.
  static String? validateAddress(String? value) {
    final address = normalize(value ?? '');

    if (address.isEmpty) {
      return 'Address cannot be empty.';
    }

    if (address.length >
        SavedPlacesConstants.maxAddressLength) {
      return 'Address is too long.';
    }

    return null;
  }

  /// Validates the search query.
  static bool isValidSearchQuery(String value) {
    return normalize(value).length >=
        SavedPlacesConstants.minSearchCharacters;
  }

  /// Validates latitude.
  static bool isValidLatitude(double latitude) {
    return latitude >= -90 && latitude <= 90;
  }

  /// Validates longitude.
  static bool isValidLongitude(double longitude) {
    return longitude >= -180 && longitude <= 180;
  }

  /// Validates coordinate pair.
  static bool isValidCoordinate({
    required double latitude,
    required double longitude,
  }) {
    return isValidLatitude(latitude) &&
        isValidLongitude(longitude);
  }
}