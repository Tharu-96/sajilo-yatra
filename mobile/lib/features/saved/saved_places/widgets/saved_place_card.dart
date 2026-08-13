import 'package:flutter/material.dart';
import '../models/place_icon_type.dart';
import '../models/saved_place.dart';

/// ===============================================================
/// Saved Place Card
/// ---------------------------------------------------------------
/// Displays a saved place on the Saved Places screen.
///
/// Used in:
/// • SavedPlacesScreen
///
/// ===============================================================

class SavedPlaceCard extends StatelessWidget {
  final SavedPlace place;

  /// Called when user taps the card.
  final VoidCallback? onTap;

  /// Called when user taps the three-dot menu.
  final VoidCallback? onMorePressed;

  const SavedPlaceCard({
    super.key,
    required this.place,
    this.onTap,
    this.onMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor:
                    theme.colorScheme.primaryContainer,
                child: Icon(
                  place.icon.icon,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      place.address,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(
                        color: theme
                            .colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              IconButton(
                tooltip: 'More',
                onPressed: onMorePressed,
                icon: const Icon(
                  Icons.more_vert_rounded,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}