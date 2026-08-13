import '../models/saved_place.dart';

/// ===============================================================
/// Saved Places Repository
/// ---------------------------------------------------------------
///
/// Contract for all Saved Places data operations.
///
/// The UI communicates only with this interface.
/// Implementations can use:
///
/// • Local memory
/// • SQLite / Hive / Isar
/// • FastAPI
/// • PostgreSQL
///
/// without changing the presentation layer.
///
/// ===============================================================

abstract interface class SavedPlacesRepository {
  /// Returns all saved places.
  Future<List<SavedPlace>> getSavedPlaces();

  /// Returns one saved place.
  ///
  /// Returns null if not found.
  Future<SavedPlace?> getSavedPlaceById(String id);

  /// Creates a new saved place.
  ///
  /// Returns the created object.
  Future<SavedPlace> createSavedPlace(
    SavedPlace place,
  );

  /// Updates an existing saved place.
  ///
  /// Returns the updated object.
  Future<SavedPlace> updateSavedPlace(
    SavedPlace place,
  );

  /// Deletes one saved place.
  Future<void> deleteSavedPlace(
    String id,
  );

  /// Deletes every saved place.
  Future<void> deleteAllSavedPlaces();

  /// Checks whether a place with the same
  /// name already exists.
  Future<bool> existsByName(
    String name,
  );

  /// Checks whether the coordinate
  /// has already been saved.
  Future<bool> existsByCoordinate({
    required double latitude,
    required double longitude,
  });

  /// Searches saved places.
  Future<List<SavedPlace>> searchSavedPlaces(
    String query,
  );
}