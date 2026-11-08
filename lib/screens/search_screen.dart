import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supermapper_app/configuration/contribution_category.dart';
import 'package:supermapper_app/services/places_service.dart';
import 'package:supermapper_app/theme.dart';

const double _borderWidth = 3.0;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final _placeService = PlaceService();

  List<Map<String, dynamic>> _databaseResults = []; // spots from database
  List<PlaceResult> _placeResults = [];             // country, city, ...

  bool _isLoading = false;

  Timer? _debounce;  
  int _requestId = 0; 

  Future<List<Map<String, dynamic>>> _searchSpotsFromDatabase(String query) async {
    try {
      final response = await Supabase.instance.client
          .from('spots')
          .select()
          .textSearch('fts', query, type: TextSearchType.websearch);

      return List<Map<String, dynamic>>.from(response);

    } catch (e) {
      debugPrint('Error while searching in database : $e');
      return [];
    }
  }

  Future<List<PlaceResult>> _searchPlacesFromService(String query) async {
    try {
      return await _placeService
        .searchPlaces(query)
        .timeout(const Duration(seconds: 5));
    } catch (e) {
      debugPrint('Place search error: $e');
      return [];
    }
  }

  Future<void> _runSearch(String query) async {
    final requestId = ++_requestId;

    final (spots, places) = await (
      _searchSpotsFromDatabase(query),
      _searchPlacesFromService(query),
    ).wait;

    if (!mounted || requestId != _requestId) return;
    setState(() {
      _databaseResults = spots;
      _placeResults = places;
      _isLoading = false;
    }
    );
  }

  void _onQueryChanged(String query) {
    _debounce?.cancel();

    if (query.trim().length < 2) {
      _requestId++; // invalide les recherches encore en cours
      setState(() {
        _databaseResults = [];
        _placeResults = [];
        _isLoading = false;
      });
      return;
    }

    setState(() => _isLoading = true);
    _debounce = Timer(
      const Duration(milliseconds: 500),
      () => _runSearch(query.trim()),
    );
  }

  void _selectSpot(Map<String, dynamic> spot) {
    Navigator.pop(context, {
      'id': spot['id'],
      'lat': (spot['lat'] as num?)?.toDouble(),
      'lng': (spot['lng'] as num?)?.toDouble(),
    });
  }

  void _selectPlace(PlaceResult place) {
    Navigator.pop(context, {
      'id': null,
      'lat': place.lat,
      'lng': place.lng,
      'zoom': place.zoom,
      'place' : place,
    });
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildResultCard({
    required Widget leading,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: _borderWidth),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                leading,
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      if (subtitle.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpotTile(Map<String, dynamic> spot) {
    final category = ContributionCategory.fromString(spot['category']);
    return _buildResultCard(
      leading: Text(category.emoji, style: const TextStyle(fontSize: 24)),
      title: spot['title'] ?? 'No title',
      subtitle: spot['description'] ?? '',
      onTap: () => _selectSpot(spot),
    );
  }

  Widget _buildPlaceTile(PlaceResult place) {
    return _buildResultCard(
      leading: const Icon(Icons.place_outlined, size: 24, color: Colors.black),
      title: place.name,
      subtitle: place.subtitle,
      onTap: () => _selectPlace(place),
    );
  }

  Widget _buildResults() {
    final hasQuery = _searchController.text.trim().length >= 2;
    final hasResults = _databaseResults.isNotEmpty || _placeResults.isNotEmpty;

    if (!hasQuery) return const SizedBox.shrink();

    if (_isLoading) {
      return const Center(
        child: SizedBox(
          height: 32,
          width: 32,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: Colors.black,
          ),
        ),
      );
    }

    if (!hasResults) {
      return const Center(child: Text('No results ...'));
    }

    return ListView(
      children: [
        if (_databaseResults.isNotEmpty) ...[
          _buildSectionTitle('SPOTS'),
          ..._databaseResults.map(_buildSpotTile),
        ],
        if (_placeResults.isNotEmpty) ...[
          _buildSectionTitle('PLACES'),
          ..._placeResults.map(_buildPlaceTile),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final fieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Colors.black, width: _borderWidth),
    );

    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      extendBody: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 22,
                      color: Colors.black,
                    ),
                    onPressed: () => Navigator.pop(context),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      fixedSize: const Size(52, 52),
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      side: const BorderSide(
                        color: Colors.black,
                        width: _borderWidth,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      onChanged: _onQueryChanged,
                      style: const TextStyle(color: Colors.black),
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(color: Colors.black45),
                        labelText: 'Search',
                        labelStyle: const TextStyle(color: Colors.black),
                        floatingLabelStyle: const TextStyle(color: Colors.black),
                        hintText: 'Seoul, Lisbon, ...',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        border: fieldBorder,
                        enabledBorder: fieldBorder,
                        focusedBorder: fieldBorder,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(child: _buildResults()),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }
}