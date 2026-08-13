import 'package:flutter/material.dart';
import '../../core/api_service.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/elevated_card.dart';

class StopDetailScreen extends StatefulWidget {
  final Map<String, dynamic> stop;

  const StopDetailScreen({super.key, required this.stop});

  @override
  State<StopDetailScreen> createState() => _StopDetailScreenState();
}

class _StopDetailScreenState extends State<StopDetailScreen> {
  Map<String, dynamic>? _detail;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    try {
      final detail = await ApiService.getStopDetail(widget.stop['id'] as String);
      if (mounted) setState(() { _detail = detail; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final stopName = widget.stop['name'] as String? ?? 'Stop Details';

    return Scaffold(
      appBar: AppBar(
        title: Text(stopName),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: AppColors.outline),
                      const SizedBox(height: 12),
                      const Text('Could not load stop details'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() { _error = null; _isLoading = true; });
                          _loadDetail();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _buildBody(stopName),
    );
  }

  Widget _buildBody(String stopName) {
    final detail = _detail!;
    final routes = (detail['routes'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: [
        // ── Stop header card ─────────────────────────────────────────────
        ElevatedCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _BusStopChip(),
              const SizedBox(height: 10),
              Text(
                stopName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 14, color: AppColors.outline),
                  const SizedBox(width: 4),
                  Text(
                    '${(detail['latitude'] as num).toStringAsFixed(5)}, '
                    '${(detail['longitude'] as num).toStringAsFixed(5)}',
                    style: const TextStyle(color: AppColors.outline, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // ── Routes serving this stop ─────────────────────────────────────
        ElevatedCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Routes Through This Stop',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.sapphireBlue,
                ),
              ),
              const SizedBox(height: 12),
              if (routes.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'No route information available.',
                    style: TextStyle(color: AppColors.outline),
                  ),
                )
              else
                ...routes.map((route) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.directions_bus, color: AppColors.onSurface),
                      title: Text(route['name'] as String? ?? 'Unknown Route'),
                      subtitle: route['operator'] != null
                          ? Text(route['operator'] as String)
                          : null,
                      trailing: _VehicleChip(
                        type: route['vehicle_type'] as String? ?? 'bus',
                      ),
                    )),
            ],
          ),
        ),
      ],
    );
  }
}

class _BusStopChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryBright,
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.directions_bus, size: 12, color: AppColors.sapphireBlue),
          SizedBox(width: 4),
          Text(
            'BUS STOP',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.sapphireBlue,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _VehicleChip extends StatelessWidget {
  final String type;
  const _VehicleChip({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        type.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          color: AppColors.sapphireBlue,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

