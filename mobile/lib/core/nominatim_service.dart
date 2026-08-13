import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

/// Reverse-geocodes device coordinates without retaining location data on disk.
/// The cache is deliberately process-local, so a session never repeats a lookup.
class NominatimService {
  static final Map<String, Future<String?>> _cache = {};
  static DateTime? _lastRequestAt;
  static Future<void> _requestQueue = Future<void>.value();

  static Future<String?> reverseGeocode({
    required double latitude,
    required double longitude,
  }) {
    // About 11 m precision: enough to reuse a result during a normal screen visit.
    final key = '${latitude.toStringAsFixed(4)},${longitude.toStringAsFixed(4)}';
    return _cache.putIfAbsent(key, () => _fetch(latitude, longitude));
  }

  static Future<String?> _fetch(double latitude, double longitude) async {
    // Queue requests so separate screen instances cannot accidentally exceed
    // Nominatim's one-request-per-second public-service policy.
    final slot = _requestQueue.then((_) async {
      final lastRequest = _lastRequestAt;
      if (lastRequest != null) {
        final elapsed = DateTime.now().difference(lastRequest);
        final remaining = Duration(
          milliseconds: const Duration(seconds: 1).inMilliseconds -
              elapsed.inMilliseconds,
        );
        if (remaining > Duration.zero) {
          await Future<void>.delayed(remaining);
        }
      }
      _lastRequestAt = DateTime.now();
    });
    _requestQueue = slot;
    await slot;

    final response = await http.get(
      Uri.https('nominatim.openstreetmap.org', '/reverse', {
        'format': 'jsonv2',
        'lat': latitude.toString(),
        'lon': longitude.toString(),
        'zoom': '18',
        'addressdetails': '1',
      }),
      headers: const {'User-Agent': 'SajiloYatra/1.0 (mobile transit app)'},
    );
    if (response.statusCode != 200) return null;

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final address = body['address'] as Map<String, dynamic>?;
    if (address == null) return body['display_name'] as String?;
    final area = _firstAddressValue(address, const [
      'neighbourhood',
      'suburb',
      'village',
      'city_district',
      'town',
      'city',
    ]);
    final landmark = _firstAddressValue(address, const [
      'amenity',
      'building',
      'road',
      'pedestrian',
    ]);
    if (area != null && landmark != null && area != landmark) {
      return '$area, $landmark';
    }
    return area ?? landmark ?? body['display_name'] as String?;
  }

  static String? _firstAddressValue(
    Map<String, dynamic> address,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = address[key]?.toString().trim();
      if (value != null && value.isNotEmpty) return value;
    }
    return null;
  }
}
