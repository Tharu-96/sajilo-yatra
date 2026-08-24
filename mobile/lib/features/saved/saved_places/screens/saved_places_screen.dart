import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/place_icon_type.dart';
import '../models/saved_place.dart';
import '../providers/saved_places_provider.dart';
import '../widgets/icon_selector.dart';

class SavedPlacesScreen extends ConsumerWidget {
  const SavedPlacesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final placesAsync = ref.watch(savedPlacesProvider);

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        backgroundColor: scheme.surface,
        elevation: 0,
        title: Text(
          'SAJILO YATRA',
          style: TextStyle(
            color: scheme.primary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: placesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Text('Failed to load saved places', style: TextStyle(color: scheme.error)),
        ),
        data: (places) => ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            Text(
              'Saved Places',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: scheme.onSurface),
            ),
            const SizedBox(height: 4),
            Text(
              'Saved your favourite locations',
              style: TextStyle(fontSize: 13, color: scheme.primary),
            ),
            const SizedBox(height: 20),
            if (places.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text('No saved places yet', style: TextStyle(color: scheme.onSurfaceVariant)),
                ),
              )
            else
              for (final place in places) ...[
                _PlaceCard(
                  place: place,
                  icon: place.icon.icon,
                  onMorePressed: () => _showOptions(context, ref, place),
                  onTap: () => context.push('/nearby-place', extra: {
                    'lat': place.latitude,
                    'lng': place.longitude,
                    'label': place.name,
                  }),
                ),
                const SizedBox(height: 12),
              ],
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => context.push('/saved/add-location'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: scheme.outlineVariant),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: scheme.primaryContainer.withValues(alpha: 0.25),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.add, color: scheme.primary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add New Location',
                      style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOptions(BuildContext context, WidgetRef ref, SavedPlace place) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (sheetContext) => SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(sheetContext).bottom + 100),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            ListTile(
              leading: const Icon(Icons.edit_rounded),
              title: const Text('Edit Name'),
              onTap: () {
                Navigator.pop(sheetContext);
                _editName(context, ref, place);
              },
            ),
            ListTile(
              leading: const Icon(Icons.category_rounded),
              title: const Text('Change Icon'),
              onTap: () {
                Navigator.pop(sheetContext);
                _changeIcon(context, ref, place);
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: Icon(Icons.delete_outline_rounded, color: schemeFor(context).error),
              title: Text('Remove Place', style: TextStyle(color: schemeFor(context).error)),
              onTap: () {
                Navigator.pop(sheetContext);
                _removePlace(context, ref, place);
              },
            ),
          ]),
        ),
      ),
    );
  }

  ColorScheme schemeFor(BuildContext context) => Theme.of(context).colorScheme;

  Future<void> _editName(BuildContext context, WidgetRef ref, SavedPlace place) async {
    final controller = TextEditingController(text: place.name);
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Name'),
        content: TextField(controller: controller, autofocus: true, textInputAction: TextInputAction.done,
          onSubmitted: (value) => Navigator.pop(dialogContext, value.trim())),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, controller.text.trim()), child: const Text('Save')),
        ],
      ),
    );
    controller.dispose();
    if (name == null || name.isEmpty || name == place.name) return;
    try {
      await ref.read(savedPlacesProvider.notifier).updatePlace(place.copyWith(name: name));
    } catch (error) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  Future<void> _changeIcon(BuildContext context, WidgetRef ref, SavedPlace place) async {
    var selectedIcon = place.icon;
    final icon = await showModalBottomSheet<PlaceIconType>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (sheetContext) => StatefulBuilder(builder: (context, setSheetState) => SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 16, 20, 100 + MediaQuery.viewInsetsOf(sheetContext).bottom),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Change Icon', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 20),
            IconSelector(selectedIcon: selectedIcon, onIconSelected: (icon) => setSheetState(() => selectedIcon = icon)),
            const SizedBox(height: 20),
            SizedBox(width: double.infinity, child: FilledButton(onPressed: () => Navigator.pop(sheetContext, selectedIcon), child: const Text('Save Icon'))),
          ]),
        ),
      )),
    );
    if (icon == null || icon == place.icon) return;
    await ref.read(savedPlacesProvider.notifier).updatePlace(place.copyWith(icon: icon));
  }

  Future<void> _removePlace(BuildContext context, WidgetRef ref, SavedPlace place) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remove Place?'),
        content: Text('Remove ${place.name} from your saved places?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Remove')),
        ],
      ),
    );
    if (confirmed == true) await ref.read(savedPlacesProvider.notifier).deletePlace(place.id);
  }
}

class _PlaceCard extends StatelessWidget {
  const _PlaceCard({required this.place, required this.icon, required this.onMorePressed, this.onTap});
  final SavedPlace place;
  final IconData icon;
  final VoidCallback onMorePressed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant),
        boxShadow: [
          BoxShadow(color: scheme.onSurface.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: scheme.primaryContainer.withValues(alpha: 0.25),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: scheme.primary, size: 20), // color explicitly set — this was likely missing before
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(place.name, style: TextStyle(fontWeight: FontWeight.w700, color: scheme.onSurface)),
                const SizedBox(height: 2),
                Text(place.address, style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
              ],
            ),
          ),
          IconButton(icon: Icon(Icons.more_vert, color: scheme.outline), onPressed: onMorePressed),
        ],
      ),
      ),
    );
  }
}
