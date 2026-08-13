import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../core/theme/app_theme.dart';

class RoutePreferenceScreen extends StatefulWidget {
  final Map<String, dynamic> searchData;
  const RoutePreferenceScreen({super.key, required this.searchData});

  @override
  State<RoutePreferenceScreen> createState() => _RoutePreferenceScreenState();
}

class _RoutePreferenceScreenState extends State<RoutePreferenceScreen> {
  String _selectedPref = 'shortest';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Preferences'),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildPrefOption('Fewer Transfers', 'fewer_transfers'),
            const SizedBox(height: 16),
            _buildPrefOption('Least Walking', 'least_walking'),
            const SizedBox(height: 16),
            _buildPrefOption('Shortest', 'shortest'),
            const Spacer(),
            PrimaryButton(
              text: 'Apply Preferences',
              onPressed: () {
                final searchRequest = Map<String, dynamic>.from(widget.searchData);
                searchRequest['preference'] = _selectedPref;
                context.push('/results', extra: searchRequest);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrefOption(String label, String value) {
    final isSelected = _selectedPref == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedPref = value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.sapphireBlue.withOpacity(0.1) : AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: isSelected ? AppColors.sapphireBlue : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? AppColors.sapphireBlue : AppColors.outline,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.sapphireBlue : AppColors.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
