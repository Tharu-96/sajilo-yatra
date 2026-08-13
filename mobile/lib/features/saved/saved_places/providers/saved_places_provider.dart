import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/auth_change_notifier.dart';
import '../models/saved_place.dart';
import '../repository/saved_places_prefs_repository.dart';
import '../repository/saved_places_repository.dart';

/// ===============================================================
/// Auth-scoped user id (rebuilds saved-places state on login/logout)
/// ===============================================================

final _authUserIdProvider =
    ChangeNotifierProvider<_AuthUserIdNotifier>((ref) {
  final notifier = _AuthUserIdNotifier();
  ref.onDispose(notifier.detach);
  return notifier;
});

class _AuthUserIdNotifier extends ChangeNotifier {
  _AuthUserIdNotifier() {
    _userId = AuthChangeNotifier.instance.user?.id;
    AuthChangeNotifier.instance.addListener(_onAuthChanged);
  }

  String? _userId;
  String? get userId => _userId;

  void _onAuthChanged() {
    final next = AuthChangeNotifier.instance.user?.id;
    if (next != _userId) {
      _userId = next;
      notifyListeners();
    }
  }

  void detach() {
    AuthChangeNotifier.instance.removeListener(_onAuthChanged);
  }
}

/// ===============================================================
/// Repository Provider
/// ===============================================================

final savedPlacesRepositoryProvider =
    Provider<SavedPlacesRepository>((ref) {
  final userId = ref.watch(_authUserIdProvider).userId;
  return SavedPlacesPrefsRepository(userScope: userId);
});

/// ===============================================================
/// Saved Places Provider
/// ===============================================================

final savedPlacesProvider =
    AsyncNotifierProvider<SavedPlacesNotifier, List<SavedPlace>>(
  SavedPlacesNotifier.new,
);

class SavedPlacesNotifier extends AsyncNotifier<List<SavedPlace>> {
  late SavedPlacesRepository _repository;

  @override
  Future<List<SavedPlace>> build() async {
    ref.watch(_authUserIdProvider);
    _repository = ref.watch(savedPlacesRepositoryProvider);

    return _repository.getSavedPlaces();
  }

  /// Reload all saved places.
  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => _repository.getSavedPlaces(),
    );
  }

  /// Add a new place.
  Future<void> addPlace(
    SavedPlace place,
  ) async {
    final currentPlaces = state.value ?? [];

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final createdPlace =
          await _repository.createSavedPlace(place);

      return [
        ...currentPlaces,
        createdPlace,
      ];
    });
  }

  /// Update an existing place.
  Future<void> updatePlace(
    SavedPlace place,
  ) async {
    final currentPlaces = state.value ?? [];

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final updatedPlace =
          await _repository.updateSavedPlace(place);

      return currentPlaces
          .map(
            (savedPlace) => savedPlace.id == updatedPlace.id
                ? updatedPlace
                : savedPlace,
          )
          .toList(growable: false);
    });
  }

  /// Delete one place.
  Future<void> deletePlace(
    String id,
  ) async {
    final currentPlaces = state.value ?? [];

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _repository.deleteSavedPlace(id);

      return currentPlaces
          .where((savedPlace) => savedPlace.id != id)
          .toList(growable: false);
    });
  }

  /// Delete every saved place.
  Future<void> clearAll() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _repository.deleteAllSavedPlaces();

      return <SavedPlace>[];
    });
  }

  /// Search saved places.
  Future<List<SavedPlace>> search(
    String query,
  ) {
    return _repository.searchSavedPlaces(query);
  }

  /// Find by ID.
  SavedPlace? getById(
    String id,
  ) {
    final places = state.value ?? [];

    try {
      return places.firstWhere(
        (place) => place.id == id,
      );
    } catch (_) {
      return null;
    }
  }

  /// Check duplicate name.
  Future<bool> existsByName(
    String name,
  ) {
    return _repository.existsByName(name);
  }

  /// Check duplicate coordinates.
  Future<bool> existsByCoordinate({
    required double latitude,
    required double longitude,
  }) {
    return _repository.existsByCoordinate(
      latitude: latitude,
      longitude: longitude,
    );
  }
}