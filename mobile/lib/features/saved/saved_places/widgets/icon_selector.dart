import 'package:flutter/material.dart';

import '../models/place_icon_type.dart';

/// ===============================================================
/// Icon Selector
/// ---------------------------------------------------------------
/// Lets the user choose one icon for a saved place.
///
/// Available icons:
/// • Home
/// • Office
/// • Favorite
/// • Pin
///
/// Used in:
/// • Save Location Screen
/// • Change Icon Bottom Sheet
/// ===============================================================

class IconSelector extends StatelessWidget {
  final PlaceIconType selectedIcon;
  final ValueChanged<PlaceIconType> onIconSelected;

  const IconSelector({
    super.key,
    required this.selectedIcon,
    required this.onIconSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: PlaceIconType.values.map((iconType) {
        final bool isSelected = iconType == selectedIcon;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: GestureDetector(
              onTap: () => onIconSelected(iconType),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                constraints: const BoxConstraints(
                  minHeight: 90,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      iconType.icon,
                      size: 28,
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant,
                    ),

                    const SizedBox(height: 8),

                    Text(
                      iconType.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context)
                                .colorScheme
                                .onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
