import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../../shared/widgets/elevated_card.dart';

class StopDetailScreen extends StatelessWidget {
  const StopDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ratnapark Station'),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ElevatedCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Arriving Soon', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.sapphireBlue)),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.directions_bus, color: AppColors.onSurface),
                  title: const Text('RT-202 Ring Road Express'),
                  trailing: const Text('2 min', style: TextStyle(color: AppColors.sapphireBlue, fontWeight: FontWeight.bold)),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.directions_bus, color: AppColors.onSurface),
                  title: const Text('MC-01 City Micro'),
                  trailing: const Text('5 min', style: TextStyle(color: AppColors.sapphireBlue, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
