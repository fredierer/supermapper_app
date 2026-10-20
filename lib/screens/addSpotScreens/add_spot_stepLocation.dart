import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supermapper_app/configuration/feedback_category.dart';
import 'package:supermapper_app/services/places_service.dart';

class AddSpotStepLocation extends StatefulWidget {
  const AddSpotStepLocation({super.key});

  @override
  State<AddSpotStepLocation> createState() => _AddSpotStepLocationState();
}

class _AddSpotStepLocationState extends State<AddSpotStepLocation> {
  final TextEditingController _searchController = TextEditingController();
  final _placeService = PlaceService();

  List<PlaceResult> _placeResults = [];             // country, city, ...

  bool _isLoading = false;

  Timer? _debounce;  
  int _requestId = 0; 

  Future<List<PlaceResult>> _searchPlacesFromService(String query) async {
    try {
      return await _placeService
        .search(query)
        .timeout(const Duration(seconds: 15));
    } catch (e) {
      debugPrint('Place search error: $e');
      return [];
    }
  }

  // Lance les deux recherches en parallèle.
  Future<void> _runSearch(String query) async {
    final requestId = ++_requestId;

    final (places) = await (_searchPlacesFromService(query));

    if (!mounted || requestId != _requestId) return;
    setState(() {
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

  void _selectPlace(PlaceResult place) {
    
  }

  // Carte commune aux spots et aux lieux : un seul endroit pour le style.
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
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
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
                        ),
                      ),
                      if (subtitle.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
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

  Widget _buildPlaceTile(PlaceResult place) {
    return _buildResultCard(
      leading: const Icon(Icons.place_outlined, size: 24),
      title: place.name,
      subtitle: place.subtitle,
      onTap: () => _selectPlace(place),
    );
  }

  Widget _buildResults() {
    final hasQuery = _searchController.text.trim().length >= 2;
    final hasResults = _placeResults.isNotEmpty;

    if (!hasQuery) return const SizedBox.shrink();

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!hasResults) {
      return const Center(child: Text('No results ...'));
    }

    return ListView(
      children: [
        if (_placeResults.isNotEmpty) ...[
          ..._placeResults.map(_buildPlaceTile),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              SizedBox(height: 20),
              TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: _onQueryChanged,
                decoration: const InputDecoration(
                  hintStyle: TextStyle(color: Colors.grey),
                  labelText: 'Search',
                  hintText: 'Seoul, Lisbon, ...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              (_searchController.text.length < 2) 
                ? Column( 
                  children: [
                    Row(
                      children: [
                        Icon(Icons.history_outlined, 
                          size: 20.0, 
                          color: Colors.grey,
                        ),
                        Text(" Recent",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16.0,
                          ),
                        )
                      ],
                    ),
                    //TODO : Ajouter les récents qui sont stockés quelquepart (?)
                  ]
                )
                : Expanded(child: _buildResults()),
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