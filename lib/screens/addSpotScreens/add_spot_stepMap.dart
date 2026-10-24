import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supermapper_app/services/places_service.dart';
import 'package:supermapper_app/widgets/map.dart';
import 'dart:async';

import 'package:supermapper_app/widgets/userPositionButton.dart';


class AddSpotStepMap extends StatefulWidget {
  const AddSpotStepMap({
    super.key,
    required this.initialLatitude,
    required this.initialLongitude,
    required this.initialZoom,
    required this.onLocationChanged,
  });

  final double? initialLatitude;
  final double? initialLongitude;
  final double? initialZoom;
  final void Function(double lat, double lng, double zoom) onLocationChanged;

  @override
  State<AddSpotStepMap> createState() => _AddSpotStepMapState();
}

class _AddSpotStepMapState extends State<AddSpotStepMap> {

  final FocusNode _searchFocus = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  final _placeService = PlaceService();
  List<PlaceResult> _placesSearched = [];
  bool _isLoading = false;
  Timer? _debounce;
  int _requestId = 0;

  double? _targetLat;
  double? _targetLng;
  
  
  void _onQueryChanged(String query) {
    _debounce?.cancel();

    if (query.trim().length < 2) {
      _requestId++; // invalide toute recherche en cours
      setState(() => _placesSearched = []);
      return;
    }

    _debounce = Timer(
      const Duration(milliseconds: 500),
      () => _searchPlaces(query.trim()),
    );
  }

  Future<void> _searchPlaces(String query) async {
    final requestId = ++_requestId;
    setState(() => _isLoading = true);
    try {
      final places = await _placeService
          .searchPlaces(query, maxResults: 3)
          .timeout(const Duration(seconds: 15));

      if (!mounted || requestId != _requestId) return;
      setState(() {
        _placesSearched = places;
        _isLoading = false;
      } );

    } catch (e) {
      debugPrint('Error while searching places : $e');
      setState(() => _isLoading = true);
    }
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


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Listener(
          onPointerDown: (_) => _searchFocus.unfocus(),
          child: MapWidget(
            initialLat: widget.initialLatitude,
            initialLng: widget.initialLongitude,
            initialZoom: widget.initialZoom,
            onCenterChanged: widget.onLocationChanged,
            targetLat: _targetLat,
            targetLng: _targetLng,
            bottomAttributionPadding: 50,
          ),
        ),
        Center(
          child: Transform.translate(
            offset: const Offset(0, -14), // la pointe du pin tombe sur le centre
            child: const Text('📍', style: TextStyle(fontSize: 28)),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: EdgeInsetsGeometry.all(20), 
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  focusNode: _searchFocus,
                  autofocus: true,
                  onChanged: _onQueryChanged,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.grey),
                    labelText: 'Search',
                    labelStyle: TextStyle(color: Colors.grey),
                    hintText: 'Seoul, Lisbon, ...',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search, size: 18.0, color: Colors.grey,),
                    suffixIcon: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _searchController,
                      builder: (context, value, _) {
                        if (value.text.isEmpty) return const SizedBox.shrink();

                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_isLoading)
                              const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.grey),
                              ),
                            IconButton(
                              icon: const Icon(Icons.close, size: 18.0, color: Colors.grey),
                              tooltip: 'Clear',
                              onPressed: () {
                                _searchController.clear();
                                _onQueryChanged('');
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                if (_placesSearched.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                      child: ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        children: _placesSearched.map((place) {
                          return _buildResultCard(
                            leading: const Icon(Icons.place_outlined, size: 24),
                            title: place.name,
                            subtitle: place.subtitle,
                            onTap: () {
                              setState(() {  
                                _targetLat = place.lat;
                                _targetLng = place.lng;

                                //Clear search bar
                                _searchController.clear();
                                _placesSearched.clear();
                                _searchFocus.unfocus();
                                
                              });

                            },
                          );
                        }).toList(),
                      ),
                    ),
                
              ],
            ) 
            
          )
        ),
        Positioned(
          bottom: 50,
          right: 20,
          child: UserPositionButton(
            onPositionFetched: (lat, lng, zoom) {
              setState(() {
                _targetLat = lat;
                _targetLng = lng;
              });              
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }
}