import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'auth/auth_service.dart';

class ApiService {
  static String get _baseUrl {
    const configuredUrl = String.fromEnvironment('API_BASE_URL');
    if (configuredUrl.isNotEmpty) {
      return '${configuredUrl.replaceFirst(RegExp(r'/+$'), '')}/api';
    }
    // Fallback to production URL when no API_BASE_URL is provided
    return 'https://sajilo-yatra-api.onrender.com/api';
  }

  static Future<Map<String, dynamic>> searchRoutes({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
  }) async {
    final url = Uri.parse('$_baseUrl/routes/search');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'origin_lat': originLat,
        'origin_lng': originLng,
        'dest_lat': destLat,
        'dest_lng': destLng,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load routes: ${response.statusCode}');
    }
  }

  static Future<List<dynamic>> getBusOptions({
    required String routeId,
    required Map<String, dynamic> route,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/routes/options'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'route_id': routeId, 'route': route}),
    );
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as Map<String, dynamic>)['vehicles'] as List<dynamic>;
    }
    throw Exception('Failed to load bus options: ${response.statusCode}');
  }

  /// Finds an exact stop name in the transit database.
  /// Returns null when the entered location is not a known stop.
  static Future<Map<String, dynamic>?> resolveStop(String name) async {
    final url = Uri.parse('$_baseUrl/stops/resolve')
        .replace(queryParameters: {'name': name.trim()});
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    if (response.statusCode == 404) {
      return null;
    }
    throw Exception('Failed to validate location: ${response.statusCode}');
  }

  static Future<List<dynamic>> getNearbyStops({
    required double lat,
    required double lng,
    required int radiusMeters,
  }) async {
    final url = Uri.parse('$_baseUrl/stops/nearby?lat=$lat&lng=$lng&radius_meters=$radiusMeters');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load nearby stops: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> getStopDetail(String stopId) async {
    final url = Uri.parse('$_baseUrl/stops/$stopId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to load stop detail: ${response.statusCode}');
  }

  /// Returns an ordered, stop-based route line for the selected bus segment.
  static Future<List<Map<String, dynamic>>> getRouteGeometry({
    required String routeId,
    required String fromStop,
    required String toStop,
  }) async {
    final url = Uri.parse('$_baseUrl/routes/$routeId/geometry').replace(
      queryParameters: {'from_stop': fromStop, 'to_stop': toStop},
    );
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to load route geometry: ${response.statusCode}');
    }
    final points = (jsonDecode(response.body) as Map<String, dynamic>)['points']
        as List<dynamic>;
    return points.cast<Map<String, dynamic>>();
  }

  // Completed prefix searches keyed by lowercased query, so extending or
  // repeating a query can be served instantly without hitting the network.
  static final Map<String, List<Map<String, dynamic>>> _stopSearchCache = {};
  static const int _stopSearchLimit = 100;

  /// Returns stop matches for [query] from the local cache without any network
  /// call, or null when no complete cached result can satisfy it. Matching is a
  /// case-insensitive prefix match, so "ka" is reused to answer "kat".
  static List<Map<String, dynamic>>? cachedStopSearch(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return const [];

    final exact = _stopSearchCache[q];
    if (exact != null) return exact;

    for (var len = q.length - 1; len >= 1; len--) {
      final base = _stopSearchCache[q.substring(0, len)];
      // A non-truncated base holds every match for its prefix, so it is safe
      // to narrow locally; a truncated one might be missing later matches.
      if (base != null && base.length < _stopSearchLimit) {
        final narrowed = base
            .where((s) => (s['name'] as String).toLowerCase().startsWith(q))
            .toList();
        _stopSearchCache[q] = narrowed;
        return narrowed;
      }
    }
    return null;
  }

  static Future<List<Map<String, dynamic>>> searchStops(String query, {int limit = _stopSearchLimit}) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return const [];

    final cached = cachedStopSearch(trimmed);
    if (cached != null) return cached;

    final url = Uri.parse('$_baseUrl/stops/search').replace(
      queryParameters: {'q': trimmed, 'limit': limit.toString()},
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final results = data.cast<Map<String, dynamic>>();
      _stopSearchCache[trimmed.toLowerCase()] = results;
      return results;
    }
    throw Exception('Failed to search stops: ${response.statusCode}');
  }

  /// Sends user feedback to the support inbox via the backend's SMTP relay.
  static Future<void> sendFeedback({
    required String subject,
    required String message,
  }) async {
    final token = await AuthService.instance.token;
    if (token == null || token.isEmpty) {
      throw Exception('Please sign in before sending feedback.');
    }

    final url = Uri.parse('$_baseUrl/feedback');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'subject': subject, 'message': message}),
    );

    if (response.statusCode != 202) {
      String detail = 'Failed to send feedback: ${response.statusCode}';
      try {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        if (body['detail'] is String) detail = body['detail'] as String;
      } catch (_) {
        // Ignore malformed error bodies and fall back to the default message.
      }
      throw Exception(detail);
    }
  }
}
