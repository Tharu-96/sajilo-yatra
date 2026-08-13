import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// Location search backed by MapTiler's geocoding API.
class PlacesService {
  PlacesService._();

  static const _timeout = Duration(seconds: 10);
  static const _kathmanduProximity = '85.324,27.7172';
  static final Map<String, PlaceDetails> _detailsById = {};

  static Future<List<PlacePrediction>> autocomplete(String query) async {
    if (query.trim().isEmpty) return [];

    final apiKey = dotenv.env['MAPTILER_API_KEY'] ?? '';
    if (apiKey.isEmpty) {
      throw Exception('MAPTILER_API_KEY not found in .env');
    }

    final uri = Uri.https(
      'api.maptiler.com',
      '/geocoding/${query.trim()}.json',
      {'key': apiKey, 'proximity': _kathmanduProximity},
    );
    final response = await http.get(uri).timeout(_timeout);
    if (response.statusCode != 200) {
      final error = jsonDecode(response.body) as Map<String, dynamic>?;
      throw Exception(
        error?['message'] ?? 'Location search failed (${response.statusCode})',
      );
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final features = body['features'] as List<dynamic>? ?? const [];
    return features
        .whereType<Map<String, dynamic>>()
        .map(PlacePrediction.fromMapTilerFeature)
        .where((prediction) => prediction.placeId.isNotEmpty)
        .toList();
  }

  /// MapTiler returns the coordinates in its geocoding response, so no
  /// additional place-details request is needed after a user selects a result.
  static Future<PlaceDetails> getPlaceDetails(String placeId) async {
    final details = _detailsById[placeId];
    if (details == null) {
      throw Exception('Selected location is no longer available. Please search again.');
    }
    return details;
  }

  static void _cache(String id, PlaceDetails details) => _detailsById[id] = details;
}

class PlacePrediction {
  final String placeId;
  final String title;
  final String description;

  const PlacePrediction({
    required this.placeId,
    required this.title,
    required this.description,
  });

  factory PlacePrediction.fromMapTilerFeature(Map<String, dynamic> feature) {
    final coordinates = (feature['geometry'] as Map<String, dynamic>?)?['coordinates'] as List<dynamic>?;
    final longitude = coordinates != null && coordinates.isNotEmpty ? coordinates[0] : null;
    final latitude = coordinates != null && coordinates.length > 1 ? coordinates[1] : null;
    final id = feature['id']?.toString() ?? '';
    final title = feature['text'] as String? ?? feature['place_name'] as String? ?? '';
    final description = feature['place_name'] as String? ?? title;

    if (id.isNotEmpty && latitude is num && longitude is num) {
      PlacesService._cache(
        id,
        PlaceDetails(
          name: title,
          address: description,
          latitude: latitude.toDouble(),
          longitude: longitude.toDouble(),
        ),
      );
    }

    return PlacePrediction(placeId: id, title: title, description: description);
  }
}

class PlaceDetails {
  final String name;
  final String address;
  final double latitude;
  final double longitude;

  const PlaceDetails({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
      };

  factory PlaceDetails.fromJson(Map<String, dynamic> json) => PlaceDetails(
        name: json['name'] as String,
        address: json['address'] as String,
        latitude: json['latitude'] as double,
        longitude: json['longitude'] as double,
      );
}
