import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'places_service.dart';

class RecentPlacesService {
  static const _key = 'recent_places_search';
  static const _maxRecent = 10;

  static Future<List<PlaceDetails>> getRecentPlaces() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw.map((e) => PlaceDetails.fromJson(jsonDecode(e))).toList();
  }

  static Future<void> addRecentPlace(PlaceDetails place) async {
    final prefs = await SharedPreferences.getInstance();
    final places = await getRecentPlaces();

    // Remove if already exists (to move it to top)
    places.removeWhere((p) =>
        p.latitude == place.latitude && p.longitude == place.longitude);

    places.insert(0, place);
    if (places.length > _maxRecent) {
      places.removeLast();
    }

    final raw = places.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, raw);
  }
}
