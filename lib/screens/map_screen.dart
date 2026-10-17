import 'package:flutter/material.dart';
import 'package:supermapper_app/configuration/feedback_category.dart';
import 'package:supermapper_app/screens/filter_screen.dart';
import 'package:supermapper_app/screens/search_screen.dart';
import 'package:supermapper_app/widgets/map.dart';
import 'package:supermapper_app/transitions/customSlideTransition.dart';
import 'package:supermapper_app/services/spots_service.dart';
import 'package:supermapper_app/widgets/spot.dart';
import 'package:supermapper_app/widgets/spotInfo.dart';
import 'dart:ui';

import 'package:supermapper_app/widgets/toolNavButton.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapScreenState();

}
class MapScreenState extends State<MapScreen> {

  final SpotService _spotService = SpotService();
  List<Spot> _fetchedSpots = [];
  List<Spot> get _filteredSpots {
    if (!_isFiltered) return _fetchedSpots;

    return _fetchedSpots.where((spot) {
      final categoryOk = _categoriesFiltered.isEmpty || _categoriesFiltered.contains(spot.category);
      final countryOk = _countriesFiltered.isEmpty || _countriesFiltered.contains(spot.countryCode);
      return categoryOk && countryOk;
    }).toList();
  }
  int? _selectedSpotId;

  double? _targetLat;
  double? _targetLng;
  double? _zoom;

  bool get _isFiltered => _categoriesFiltered.isNotEmpty || _countriesFiltered.isNotEmpty;  
  Set<FeedbackCategory> _categoriesFiltered = {};
  Set<String> _countriesFiltered = {};

  @override
  void initState() {
    super.initState();
    fetchSpotsData();
  }

  Future<void> fetchSpotsData() async {
    final spots = await _spotService.getSpots();
    if (!mounted) return;
    setState(() {
      _fetchedSpots = spots; // Met à jour l'interface quand les données arrivent
    });
  }

  Future<void> _navigateToSearchScreen() async {
    
    setState(() {
      _selectedSpotId = null;
    });

    final dynamic result = await Navigator.of(context).push(
      customSlidefromLeft(const SearchScreen()),
    );

    if(!mounted) return;
    if (result == null || result is! Map<String, dynamic>) return; //No move if no spot selected from search

    //getting data from selected spot
    final spotId = result['id'] as int?;
    final lat = result['lat'] as double?;
    final lng = result['lng'] as double?;
    final zoom = result['zoom'] as double?;

    //set Target lat and lng to move the map
    if (lat != null && lng != null) {
      setState(() {
        _targetLat = lat;
        _targetLng = lng;
        _zoom = zoom;
      });

      if(spotId != null) {
        await Future.delayed(const Duration(milliseconds: 800)); //delay
        setState(() {
          _selectedSpotId = spotId; //set selectedSpot to display spot Info Popup
        });
      }  
    }    
  }

  Future<void> _navigateToFilterScreen() async {
    
    setState(() {
      _selectedSpotId = null;
    });

    final result = await Navigator.of(context).push<({Set<FeedbackCategory> categories, Set<String> countries})>(
      customSlidefromRight(FilterScreen(
        initialCategories: _categoriesFiltered,
        initialCountries: _countriesFiltered,
        )
      ),
    );

    if (result == null) return;

    setState(() {
      _categoriesFiltered = result.categories;
      _countriesFiltered = result.countries;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          
          MapWidget(
            spots: _filteredSpots,
            targetLat: _targetLat,
            targetLng: _targetLng,
            targetZoom : _zoom,
            onSpotSelected: (spotId) {
              setState(() {
                _selectedSpotId = spotId;
              });
            },
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 10),
              child : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ToolNavButton(
                        icon: Icons.search,
                        onPressed: _navigateToSearchScreen,
                      ),
                      Badge(
                        isLabelVisible: _isFiltered,
                        alignment: AlignmentDirectional.topStart,
                        smallSize: 16,
                        child: ToolNavButton(
                          icon: Icons.filter_list,
                          onPressed: _navigateToFilterScreen,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          if (_selectedSpotId != null)
            Positioned.fill(
            child: Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedSpotId = null;
                      });
                    },
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 5.0, // Intensité du flou horizontal
                        sigmaY: 5.0, // Intensité du flou vertical
                      ),
                      child: Container(
                        color: Colors.black.withAlpha(100), 
                      ),
                    ),
                  ),
                ),

                Center(
                  child: SingleChildScrollView(
                    child: SpotInfo(
                      spotId: _selectedSpotId!,
                      onClose: () {
                        setState(() {
                          _selectedSpotId = null;
                          _targetLat = null;
                          _targetLng = null;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

        ]
      );
  }
}