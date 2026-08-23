import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:dio_cache_interceptor_file_store/dio_cache_interceptor_file_store.dart';
import 'package:path_provider/path_provider.dart';

class AppTileLayer extends StatelessWidget {
  const AppTileLayer({super.key});

  static Future<String> get _cachePath async {
    final dir = await getTemporaryDirectory();
    return '${dir.path}/map_tiles_cache';
  }

  @override
  Widget build(BuildContext context) {
    final apiKey = dotenv.env['MAPTILER_API_KEY'] ?? 'a5GzMCrI4tf8ocuiuQiW';
    final urlTemplate = 'https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=$apiKey';

    return FutureBuilder<String>(
      future: _cachePath,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return TileLayer(
            urlTemplate: urlTemplate,
            userAgentPackageName: 'com.sajiloyatra.app',
            maxZoom: 19,
          );
        }

        return TileLayer(
          urlTemplate: urlTemplate,
          userAgentPackageName: 'com.sajiloyatra.app',
          maxZoom: 19,
          tileProvider: CachedTileProvider(
            maxStale: const Duration(days: 30),
            store: FileCacheStore(snapshot.data!),
          ),
        );
      },
    );
  }
}
