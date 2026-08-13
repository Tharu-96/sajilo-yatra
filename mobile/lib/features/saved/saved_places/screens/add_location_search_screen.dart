import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/places_service.dart';
import '../services/recent_places_service.dart';
import '../utils/debouncer.dart';
import '../widgets/search_field.dart';

class AddLocationSearchScreen extends StatefulWidget {
  const AddLocationSearchScreen({
    super.key,
  });

  @override
  State<AddLocationSearchScreen> createState() =>
      _AddLocationSearchScreenState();
}

class _AddLocationSearchScreenState
    extends State<AddLocationSearchScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  final Debouncer _debouncer =
      Debouncer(
    delay: const Duration(
      milliseconds: 300,
    ),
  );

  bool _isLoading = false;

  bool _hasError = false;

  String _errorMessage = '';

  List<PlacePrediction> _predictions = [];

  List<PlaceDetails> _recentPlaces = [];

  @override
  void initState() {
    super.initState();

    _searchController.addListener(
      _onSearchChanged,
    );
    _loadRecentPlaces();
  }

  Future<void> _loadRecentPlaces() async {
    final places = await RecentPlacesService.getRecentPlaces();
    if (mounted) {
      setState(() {
        _recentPlaces = places;
      });
    }
  }

  void _onSearchChanged() {
    final query =
        _searchController.text.trim();

    _debouncer.run(
      () {
        _search(query);
      },
    );
  }

  Future<void> _search(
    String query,
  ) async {
    if (query.isEmpty) {
      if (!mounted) return;

      setState(() {
        _predictions.clear();
        _isLoading = false;
        _hasError = false;
      });

      return;
    }

    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      final result =
          await PlacesService.autocomplete(
        query,
      );

      if (!mounted) return;

      setState(() {
        _predictions = result;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _selectPrediction(
    PlacePrediction prediction,
  ) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final details =
          await PlacesService.getPlaceDetails(
        prediction.placeId,
      );

      await RecentPlacesService.addRecentPlace(details);

      if (!mounted) return;

      context.push(
        '/saved/map-picker',
        extra: details,
      );
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
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _selectRecentPlace(PlaceDetails details) async {
    await RecentPlacesService.addRecentPlace(details);
    if (!mounted) return;
    context.push(
      '/saved/map-picker',
      extra: details,
    );
  }

  void _openMapPicker() {
    context.push(
      '/saved/map-picker',
    );
  }
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black87,
          ),
        ),
        title: const Text(
          'Add Location',
          style: TextStyle(
            color: Color(0xff0D5C8F),
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: SearchField(
                controller: _searchController,
                hintText: 'Search for a place',
              ),
            ),

            const SizedBox(height: 18),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: InkWell(
                borderRadius:
                    BorderRadius.circular(18),
                onTap: _openMapPicker,
                child: Container(
                  padding:
                      const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor:
                            const Color(
                          0xffEAF3FF,
                        ),
                        child: const Icon(
                          Icons.map_outlined,
                          color:
                              Color(0xff0D5C8F),
                        ),
                      ),

                      const SizedBox(width: 16),

                      const Expanded(
                        child: Text(
                          'Set location on map',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ),

                      const Icon(
                        Icons.chevron_right,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Expanded(
              child: Builder(
                builder: (_) {
                  if (_isLoading) {
                    return const Center(
                      child:
                          CircularProgressIndicator(),
                    );
                  }

                  if (_hasError) {
                    return Center(
                      child: Padding(
                        padding:
                            const EdgeInsets.all(
                                24),
                        child: Text(
                          _errorMessage,
                          textAlign:
                              TextAlign.center,
                        ),
                      ),
                    );
                  }

                  if (_searchController
                      .text
                      .trim()
                      .isEmpty) {
                    return _buildRecentPlaces();
                  }

                  if (_predictions.isEmpty) {
                    return const Center(
                      child: Text(
                        'No locations found',
                      ),
                    );
                  }

                  return ListView.separated(
                    padding:
                        const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 24,
                    ),
                    itemCount:
                        _predictions.length,
                    separatorBuilder:
                        (_, __) =>
                            const Divider(
                      height: 1,
                    ),
                    itemBuilder:
                        (context, index) {
                      final place =
                          _predictions[index];

                      return ListTile(
                        contentPadding:
                            EdgeInsets.zero,

                        leading:
                            const CircleAvatar(
                          backgroundColor:
                              Color(
                            0xffEDF5FF,
                          ),
                          child: Icon(
                            Icons.location_on,
                            color:
                                Color(
                              0xff0D5C8F,
                            ),
                          ),
                        ),

                        title: Text(
                          place.title,
                          maxLines: 1,
                          overflow:
                              TextOverflow
                                  .ellipsis,
                        ),

                        subtitle: Text(
                          place.description,
                          maxLines: 2,
                          overflow:
                              TextOverflow
                                  .ellipsis,
                        ),

                        onTap: () =>
                            _selectPrediction(
                          place,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildRecentPlaces() {
    if (_recentPlaces.isEmpty) {
      return const Center(
        child: Text('No recent places'),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      children: [
        const Text(
          'Recent Places',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 18),

        ..._recentPlaces.map(
          (place) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const CircleAvatar(
              backgroundColor: Color(0xffEDF5FF),
              child: Icon(
                Icons.history,
                color: Color(0xff0D5C8F),
              ),
            ),
            title: Text(
              place.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              place.address,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () => _selectRecentPlace(place),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer.dispose();
    super.dispose();
  }
}