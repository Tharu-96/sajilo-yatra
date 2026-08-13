import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

import '../models/place_icon_type.dart';
import '../models/saved_place.dart';
import '../models/selected_location.dart';
import '../providers/saved_places_provider.dart';
import '../widgets/icon_selector.dart';

class SaveLocationScreen extends ConsumerStatefulWidget {
  final SelectedLocation selectedLocation;

  const SaveLocationScreen({
    super.key,
    required this.selectedLocation,
  });

  @override
  ConsumerState<SaveLocationScreen> createState() =>
      _SaveLocationScreenState();
}

class _SaveLocationScreenState
    extends ConsumerState<SaveLocationScreen> {
  final TextEditingController _nameController =
      TextEditingController();

  PlaceIconType _selectedIcon =
      PlaceIconType.favorite;

  bool _saving = false;

  @override
  void initState() {
    super.initState();

    _nameController.text = '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveLocation() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a location name.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      final now = DateTime.now();

      final place = SavedPlace(
        id: const Uuid().v4(),
        name: name,
        address: widget.selectedLocation.address,
        latitude: widget.selectedLocation.latitude,
        longitude: widget.selectedLocation.longitude,
        icon: _selectedIcon,
        createdAt: now,
        updatedAt: now,
      );

      await ref
          .read(savedPlacesProvider.notifier)
          .addPlace(place);

      if (!mounted) return;

      context.go('/saved');
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black87,
          ),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Save Location',
          style: TextStyle(
            color: Color(0xff0D5C8F),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.fromLTRB(20, 20, 20, 24 + MediaQuery.viewInsetsOf(context).bottom),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              /// -----------------------------
              /// Map Preview
              /// -----------------------------
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(18),
                child: SizedBox(
                  height: 200,
                  child: IgnorePointer(
                    // This is a static preview. Let vertical drags reach the
                    // parent scroll view on compact devices.
                    child: FlutterMap(
                      options: MapOptions(
                      initialCenter: LatLng(
                        widget.selectedLocation.latitude,
                        widget.selectedLocation.longitude,
                      ),
                      initialZoom: 17,
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.none,
                      ),
                    ),
                      children: [
                      TileLayer(
                        urlTemplate: 'https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=${dotenv.env['MAPTILER_API_KEY']}',
                        userAgentPackageName: 'com.sajiloyatra.app',
                        tileProvider: CancellableNetworkTileProvider(),
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(
                              widget.selectedLocation.latitude,
                              widget.selectedLocation.longitude,
                            ),
                            child: const Icon(Icons.location_pin, color: Color(0xff0D5C8F), size: 42),
                          ),
                        ],
                      ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Full Address',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 8),

              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  widget.selectedLocation.address,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Location Name',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'e.g. Home, Office, Gym',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xff0D5C8F),
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'Choose Icon',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 16),

              IconSelector(
                selectedIcon:
                    _selectedIcon,
                onIconSelected:
                    (icon) {
                  setState(() {
                    _selectedIcon = icon;
                    if (icon == PlaceIconType.pin) {
                      // Don't auto-fill or maybe clear it if it was filled by another choice
                      // _nameController.text = ''; // uncomment if you want it to clear on 'pinned'
                    } else if (icon == PlaceIconType.home) {
                      _nameController.text = 'Home';
                    } else if (icon == PlaceIconType.office) {
                      _nameController.text = 'Office';
                    } else if (icon == PlaceIconType.favorite) {
                      _nameController.text = 'Favorite';
                    } else {
                      final name = icon.name;
                      _nameController.text = name[0].toUpperCase() + name.substring(1);
                    }
                  });
                },
              ),

              const SizedBox(height: 36),               
                            SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: _saving
                      ? null
                      : _saveLocation,
                  style: FilledButton.styleFrom(
                    backgroundColor:
                        const Color(0xff0D5C8F),
                    foregroundColor: Colors.white,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        16,
                      ),
                    ),
                  ),
                  child: _saving
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Save Location',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
