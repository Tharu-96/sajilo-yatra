import 'package:flutter/material.dart';

/// ===============================================================
/// Place Options Bottom Sheet
/// ---------------------------------------------------------------
/// Shown when the user taps the three-dot menu on a saved place.
///
/// Options:
/// • Edit Name
/// • Change Icon
/// • Remove Location
/// ===============================================================

class PlaceOptionsBottomSheet extends StatelessWidget {
  final VoidCallback? onEditName;
  final VoidCallback? onChangeIcon;
  final VoidCallback? onRemove;

  const PlaceOptionsBottomSheet({
    super.key,
    this.onEditName,
    this.onChangeIcon,
    this.onRemove,
  });

  Future<void> showPlaceOptionsBottomSheet({
  required BuildContext context,
  VoidCallback? onEditName,
  VoidCallback? onChangeIcon,
  VoidCallback? onRemove,
}) {
  return showModalBottomSheet(
    context: context,
    showDragHandle: false,
    useSafeArea: false,
    isScrollControlled: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(24),
      ),
    ),
    builder: (_) {
      return PlaceOptionsBottomSheet(
        onEditName: onEditName,
        onChangeIcon: onChangeIcon,
        onRemove: onRemove,
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
        padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(context).padding.bottom + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(100),
              ),
            ),

            const SizedBox(height: 20),

            ListTile(
              leading: const Icon(Icons.edit_rounded),
              title: const Text('Edit Name'),
              onTap: () {
                Navigator.pop(context);
                onEditName?.call();
              },
            ),

            ListTile(
              leading: const Icon(Icons.category_rounded),
              title: const Text('Change Icon'),
              onTap: () {
                Navigator.pop(context);
                onChangeIcon?.call();
              },
            ),

            const Divider(height: 24),

            ListTile(
              leading: Icon(
                Icons.delete_outline_rounded,
                color: theme.colorScheme.error,
              ),
              title: Text(
                'Remove Location',
                style: TextStyle(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                onRemove?.call();
              },
            ),
          ],
        ),
    );
  }
}