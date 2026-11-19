import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:supermapper_app/configuration/contribution_category.dart';
import 'package:supermapper_app/screens/filter_screen.dart';
import 'package:supermapper_app/screens/search_screen.dart';
import 'package:supermapper_app/services/POI_service.dart';
import 'package:supermapper_app/services/places_service.dart';
import 'package:supermapper_app/theme.dart';
import 'package:supermapper_app/widgets/map.dart';
import 'package:supermapper_app/transitions/customSlideTransition.dart';
import 'package:supermapper_app/services/spots_service.dart';
import 'package:supermapper_app/widgets/poi.dart';
import 'package:supermapper_app/widgets/spot.dart';
import 'package:supermapper_app/widgets/spotInfo.dart';
import 'dart:ui';

import 'package:supermapper_app/widgets/toolNavButton.dart';
import 'package:supermapper_app/widgets/userPositionButton.dart';

const double _borderWidth = 3.0;

class MapScreen extends StatefulWidget {
  final VoidCallback onAddButtonPressed;

  const MapScreen({
    super.key,
    required this.onAddButtonPressed,
  });


  @override
  State<MapScreen> createState() => MapScreenState();

}
class MapScreenState extends State<MapScreen> {

  //Spots fetch from Supabase
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

  //Position sur la map, target
  double? _targetLat;
  double? _targetLng;
  double? _zoom;

  //Camera position
  double? _cameraLat;
  double? _cameraLng;
  double? _cameraZoom;

  //Filtered from the filter_screen
  bool get _isFiltered => _categoriesFiltered.isNotEmpty || _countriesFiltered.isNotEmpty;  
  Set<ContributionCategory> _categoriesFiltered = {};
  Set<String> _countriesFiltered = {};

  //Place service to display place from search_screen
  final _placeService = PlaceService();
  List<BoundaryResult> _boundary = [];
  bool _boundariesDisplay = false;
  int _boundaryRequestId = 0;
  String? _placeTitle;
  String? _placeSubtitles;

  //POI service
  final _poiService = PoiService();
  List<Poi> _currentPois = [];
  Timer? _debounceTimer;

  Future<void> _loadPoisForCurrentBounds(double south, double west, double north, double east) async {
    //Fucntion to fetch all the poi from database and set _currentPois so it can be displayed on the map
    //Function called by _mapCenterChanged after a delay, to avoid calling it every millisecond

    final pois = await _poiService.getPoi(south, west, north, east);

    if (!mounted) return;

    setState(() {
      _currentPois = pois;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchSpotsData();
  }

  ({double lat, double lng, double zoom})? get currentCamera {
    final lat = _cameraLat;
    final lng = _cameraLng;
    final zoom = _cameraZoom;
    if (lat == null || lng == null || zoom == null) return null;
    return (lat: lat, lng: lng, zoom: zoom);
  }

  Future<void> fetchSpotsData() async {
    final spots = await _spotService.getSpots();
    if (!mounted) return;
    setState(() {
      _fetchedSpots = spots; // Met à jour l'interface quand les données arrivent
    });
  }

  Future<void> openSpot(Spot spot) async {
    setState(() {
      _targetLat = spot.lat;
      _targetLng = spot.lng;
      _zoom = 10.0;
      _selectedSpotId = null;
    });
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _selectedSpotId = spot.id);
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
    final place = result['place'] as PlaceResult?;

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

    setState(() => _boundary = []);         
    if (place != null) {
      _boundariesDisplay = true;
      _loadBoundary(place);
      _placeTitle = place.name;
      _placeSubtitles = place.subtitle;
    }   

  }

  Future<void> _navigateToFilterScreen() async {
    
    setState(() {
      _selectedSpotId = null;
    });

    final result = await Navigator.of(context).push<({Set<ContributionCategory> categories, Set<String> countries})>(
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

  Future<void> _loadBoundary(PlaceResult place) async {
  final requestId = ++_boundaryRequestId;
  try {
    final shapes = await _placeService.fetchBoundary(place);

    if (!mounted || requestId != _boundaryRequestId) return;

    setState(() => _boundary = shapes);
  } catch (e) {
    debugPrint('Boundary error: $e');
  }
}

  void _mapCenterChanged(double lat, double lng, double zoom, LatLngBounds bounds) {
    // Callback function from the map widget. 
    // Verify the zoom level, to avoid fetching the pois too soon.
    // arguments based on camera position.

    _cameraLat = lat;
    _cameraLng = lng;
    _cameraZoom = zoom;

    if (zoom < 14.0) {
      if (_currentPois.isNotEmpty) {
        setState(() => _currentPois = []);
      }
      return;
    }

    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 200), () {
      _loadPoisForCurrentBounds(
        bounds.south,
        bounds.west,
        bounds.north,
        bounds.east,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          
          MapWidget(
            spots: _filteredSpots,
            pois: _currentPois,
            targetLat: _targetLat,
            targetLng: _targetLng,
            targetZoom : _zoom,
            initialLat: 38.9,
            initialLng: 2.11,
            initialZoom: 3.5,
            onSpotSelected: (spotId) {
              setState(() {
                _selectedSpotId = spotId;
              });
            },
            onCenterChanged: (lat, lng, zoom, bounds) {
              _mapCenterChanged(lat,lng, zoom, bounds);
            },
            boundary: _boundary,
            bottomAttributionPadding: 110,
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsetsGeometry.fromLTRB(20, 0, 20, 10),
              child : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ToolNavButton(
                          icon: Icons.search,
                          onPressed: _navigateToSearchScreen,
                        ),

                        SizedBox(width: 20,),
                        
                        if(_boundariesDisplay)
                          Expanded(
                            child: Container(
                              height: 70.0, // Hauteur fixe
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14.0),
                                border: Border.all(
                                  color: Colors.black,
                                  width: _borderWidth,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsetsGeometry.all(10),
                                child : Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 36.0,
                                      width: 36.0,
                                      child: Icon(Icons.place_outlined, size: 32.0, color: Colors.black,),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          _placeTitle ?? '',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        if (_placeSubtitles != null && _placeSubtitles!.isNotEmpty) ...[
                                          const SizedBox(height: 2.0),
                                          Text(
                                            _placeSubtitles ?? '',
                                            style: TextStyle(
                                            fontSize: 11.0,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black54,
                                          ),
                                          ),
                                        ]
                                      ],
                                    ),
                                    SizedBox(
                                      height: 36.0,
                                      width: 36.0,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        icon : Icon(Icons.close_outlined,
                                        size: 24.0,
                                        color: Colors.black,
                                      ),
                                        onPressed: () {
                                          setState(() {
                                            _boundary = [];
                                            _boundariesDisplay = false;
                                            _targetLat = null;
                                            _targetLng = null;
                                          });
                                        } 
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        
                        SizedBox(width: 20,),
                        
                        Badge(
                          isLabelVisible: _isFiltered,
                          alignment: AlignmentDirectional.topStart,
                          smallSize: 16,
                          backgroundColor: Colors.black,
                          child: ToolNavButton(
                            icon: Icons.filter_list,
                            onPressed: _navigateToFilterScreen,
                          ),
                        ),                    
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          
          SafeArea(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 20, 24),
                child: UserPositionButton(
                  onPositionFetched: (lat, lng, zoom) {
                    setState(() {
                      _targetLat = lat;
                      _targetLng = lng;
                    });
                  },
                ),
              ),
            ),
          ),
         

          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: FilledButton.icon(
                  onPressed: widget.onAddButtonPressed,
                  icon: const Icon(Icons.add, size: 36),
                  label: const Text(
                    'Add a spot',
                    style: TextStyle(fontSize: 16.0),
                    ),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.amber,
                    foregroundColor: Colors.black,
                    elevation: 2,
                    fixedSize: const Size(220, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: const BorderSide(color: Colors.black, width: _borderWidth),
                    ),
                  ),
                ),
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
                
                
                
              ],
            ),
          ),

        ]
      );
  }
}