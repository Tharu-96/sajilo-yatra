import 'package:flutter/material.dart';

import 'primary_button.dart';

/// ===============================================================
/// Confirm Location Card
/// ---------------------------------------------------------------
/// Floating card displayed at the bottom of the map.
///
/// Used in:
/// • LocationPickerScreen
///
/// Shows:
/// • Selected address
/// • Latitude & Longitude (optional)
/// • Confirm button
/// ===============================================================

class ConfirmLocationCard extends StatelessWidget {
  /// Human-readable address.
  final String address;

  /// Optional latitude.
  final double? latitude;

  /// Optional longitude.
  final double? longitude;

  /// Called when Confirm is pressed.
  final VoidCallback onConfirm;

  /// Loading state.
  final bool isLoading;

  const ConfirmLocationCard({
    super.key,
    required this.address,
    required this.onConfirm,
    this.latitude,
    this.longitude,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 10,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selected Location',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on_rounded,
                  color: theme.colorScheme.primary,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    address,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),

            if (latitude != null && longitude != null) ...[
              const SizedBox(height: 12),

              Text(
                'Latitude : ${latitude!.toStringAsFixed(6)}',
                style: theme.textTheme.bodySmall,
              ),

              const SizedBox(height: 4),

              Text(
                'Longitude : ${longitude!.toStringAsFixed(6)}',
                style: theme.textTheme.bodySmall,
              ),
            ],

            const SizedBox(height: 20),

            PrimaryButton(
              text: 'Confirm',
              icon: Icons.check_circle_outline_rounded,
              isLoading: isLoading,
              onPressed: onConfirm,
            ),
          ],
        ),
      ),
    );
  }
}