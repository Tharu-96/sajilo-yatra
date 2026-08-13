import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/saved_place.dart';
import '../utils/validators.dart';
import 'saved_places_repository.dart';

class SavedPlacesPrefsRepository implements SavedPlacesRepository {
  SavedPlacesPrefsRepository({String? userScope})
      : _key = _buildKey(userScope);

  static const _legacyKey = 'saved_places';
  static const _guestScope = 'guest';

  final String _key;

  static String _buildKey(String? userScope) {
    final scope =
        (userScope == null || userScope.isEmpty) ? _guestScope : userScope;
    return 'saved_places::$scope';
  }

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<List<SavedPlace>> _load() async {
    final prefs = await _prefs;
    var raw = prefs.getString(_key);
    if (raw == null) {
      // One-time migration of pre-scope global bucket into this user's scope.
      final legacy = prefs.getString(_legacyKey);
      if (legacy != null) {
        await prefs.setString(_key, legacy);
        await prefs.remove(_legacyKey);
        raw = legacy;
      } else {
        return [];
      }
    }
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => SavedPlace.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> _save(List<SavedPlace> places) async {
    final prefs = await _prefs;
    await prefs.setString(
        _key, jsonEncode(places.map((p) => p.toJson()).toList()));
  }

  @override
  Future<List<SavedPlace>> getSavedPlaces() => _load();

  @override
  Future<SavedPlace?> getSavedPlaceById(String id) async {
    final places = await _load();
    try {
      return places.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<SavedPlace> createSavedPlace(SavedPlace place) async {
    final places = await _load();
    if (places
        .any((p) => SavedPlacesValidators.isSameName(p.name, place.name))) {
      throw Exception('A location with this name already exists.');
    }
    places.add(place);
    await _save(places);
    return place;
  }

  @override
  Future<SavedPlace> updateSavedPlace(SavedPlace place) async {
    final places = await _load();
    final index = places.indexWhere((p) => p.id == place.id);
    if (index == -1) throw Exception('Saved place not found.');
    if (places.any((p) =>
        p.id != place.id &&
        SavedPlacesValidators.isSameName(p.name, place.name))) {
      throw Exception('Another location already uses this name.');
    }
    final updated = place.copyWith(updatedAt: DateTime.now());
    places[index] = updated;
    await _save(places);
    return updated;
  }

  @override
  Future<void> deleteSavedPlace(String id) async {
    final places = await _load();
    places.removeWhere((p) => p.id == id);
    await _save(places);
  }

  @override
  Future<void> deleteAllSavedPlaces() async {
    final prefs = await _prefs;
    await prefs.remove(_key);
    await prefs.remove(_legacyKey);
  }

  @override
  Future<bool> existsByName(String name) async {
    final places = await _load();
    return places.any((p) => SavedPlacesValidators.isSameName(p.name, name));
  }

  @override
  Future<bool> existsByCoordinate(
      {required double latitude, required double longitude}) async {
    const tolerance = 0.00001;
    final places = await _load();
    return places.any((p) =>
        (p.latitude - latitude).abs() <= tolerance &&
        (p.longitude - longitude).abs() <= tolerance);
  }

  @override
  Future<List<SavedPlace>> searchSavedPlaces(String query) async {
    final normalized = SavedPlacesValidators.normalize(query).toLowerCase();
    final places = await _load();
    return places
        .where((p) =>
            SavedPlacesValidators.normalize(p.name)
                .toLowerCase()
                .contains(normalized) ||
            p.address.toLowerCase().contains(normalized))
        .toList();
  }
}
