import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static String get _baseUrl {
    if (kIsWeb) return 'http://127.0.0.1:8000/api';
    if (Platform.isAndroid) return 'http://10.0.2.2:8000/api';
    return 'http://127.0.0.1:8000/api';
  }

  static Future<Map<String, dynamic>> searchRoutes({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
    required String preference,
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
        'preference': preference,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load routes: ${response.statusCode}');
    }
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
}
