import '../models/saved_place.dart';
import '../utils/validators.dart';
import 'saved_places_repository.dart';

/// ===============================================================
/// Saved Places Local Repository
/// ---------------------------------------------------------------
/// Temporary in-memory implementation.
///
/// This repository allows the Saved Places feature to work before
/// integrating the FastAPI backend.
/// ===============================================================

class SavedPlacesLocalRepository implements SavedPlacesRepository {
  SavedPlacesLocalRepository();

  final List<SavedPlace> _places = [];

  @override
  Future<List<SavedPlace>> getSavedPlaces() async {
    return List.unmodifiable(_places);
  }

  @override
  Future<SavedPlace?> getSavedPlaceById(String id) async {
    try {
      return _places.firstWhere((place) => place.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<SavedPlace> createSavedPlace(
    SavedPlace place,
  ) async {
    if (await existsByName(place.name)) {
      throw Exception(
        'A location with this name already exists.',
      );
    }

    _places.add(place);

    return place;
  }

  @override
  Future<SavedPlace> updateSavedPlace(
    SavedPlace place,
  ) async {
    final index = _places.indexWhere(
      (item) => item.id == place.id,
    );

    if (index == -1) {
      throw Exception('Saved place not found.');
    }

    final duplicate = _places.any(
      (item) =>
          item.id != place.id &&
          SavedPlacesValidators.isSameName(
            item.name,
            place.name,
          ),
    );

    if (duplicate) {
      throw Exception(
        'Another location already uses this name.',
      );
    }

    final updatedPlace = place.copyWith(
      updatedAt: DateTime.now(),
    );

    _places[index] = updatedPlace;

    return updatedPlace;
  }

  @override
  Future<void> deleteSavedPlace(
    String id,
  ) async {
    _places.removeWhere(
      (item) => item.id == id,
    );
  }

  @override
  Future<void> deleteAllSavedPlaces() async {
    _places.clear();
  }

  @override
  Future<bool> existsByName(
    String name,
  ) async {
    return _places.any(
      (item) => SavedPlacesValidators.isSameName(
        item.name,
        name,
      ),
    );
  }

  @override
  Future<bool> existsByCoordinate({
    required double latitude,
    required double longitude,
  }) async {
    const tolerance = 0.00001;

    return _places.any(
      (item) =>
          (item.latitude - latitude).abs() <= tolerance &&
          (item.longitude - longitude).abs() <= tolerance,
    );
  }

  @override
  Future<List<SavedPlace>> searchSavedPlaces(
    String query,
  ) async {
    final normalized =
        SavedPlacesValidators.normalize(query).toLowerCase();

    if (normalized.isEmpty) {
      return List.unmodifiable(_places);
    }

    return _places.where((item) {
      return item.name.toLowerCase().contains(normalized) ||
          item.address.toLowerCase().contains(normalized);
    }).toList(growable: false);
  }
}