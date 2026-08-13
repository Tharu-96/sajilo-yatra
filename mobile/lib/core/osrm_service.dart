import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class OsrmService {
  /// Fetches the route geometry between multiple waypoints using OSRM.
  /// [mode] should be 'foot' for walking or 'driving' for bus/car routes.
  static Future<List<LatLng>> getRoute(List<LatLng> waypoints, {String mode = 'driving'}) async {
    if (waypoints.length < 2) return waypoints;

    try {
      final coordinates = waypoints.map((p) => '${p.longitude},${p.latitude}').join(';');
      
      final url = Uri.parse(
        'https://router.project-osrm.org/route/v1/$mode/$coordinates?geometries=geojson&overview=full',
      );
      
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final routes = data['routes'] as List<dynamic>;
        if (routes.isNotEmpty) {
          final coords = (routes[0]['geometry']['coordinates'] as List<dynamic>)
              .map((c) => LatLng(
                    ((c as List<dynamic>)[1] as num).toDouble(),
                    (c[0] as num).toDouble(),
                  ))
              .toList();
          return coords;
        }
      }
    } catch (e) {
      // Return the original straight-line waypoints if routing fails
      print('OSRM Routing error: $e');
    }
    
    return waypoints;
  }
}
