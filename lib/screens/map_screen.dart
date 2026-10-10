import 'package:flutter/material.dart';
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
  State<MapScreen> createState() => _mapScreenState();

}
class _mapScreenState extends State<MapScreen> {

  final SpotService _spotService = SpotService();
  List<Spot> _spots = [];
  int? _selectedSpotId;

  double? _targetLat;
  double? _targetLng;

  @override
  void initState() {
    super.initState();
    _fetchSpotsData();
  }

  Future<void> _fetchSpotsData() async {
    final spots = await _spotService.getSpots();
    setState(() {
      _spots = spots; // Met à jour l'interface quand les données arrivent
    });
  }

  void _navigateToSearchScreen() async {

    final dynamic result = await Navigator.of(context).push(
      customSlidefromLeft(const SearchScreen()),
    );

    if (result == null || result is! Map<String, dynamic>) return; //No move if no spot selected from search

    //getting data from selected spot
    final spotId = result['id'] as int;
    final lat = result['lat'] as double?;
    final lng = result['lng'] as double?;

    //set Target lat and lng to move the map
    if (lat != null && lng != null) {
      setState(() {
        _targetLat = lat;
        _targetLng = lng;
      });

      await Future.delayed(const Duration(milliseconds: 800)); //delay
    }

    //set selectedSpot to display spot Info Popup
    setState(() {
      _selectedSpotId = spotId;
    });
    
  }

  void _navigateToFilterScreen() async {

    final dynamic selectedSpotId = await Navigator.of(context).push(
      customSlidefromRight(const SearchScreen()),
    );

    if (selectedSpotId != null) {
      setState(() {
        _selectedSpotId = selectedSpotId as int; 
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          
          MapWidget(
            spots: _spots,
            targetLat: _targetLat, // Transmettez la latitude cible
            targetLng: _targetLng,
            onSpotSelected: (spotId) {
              setState(() {
                _selectedSpotId = spotId;
              });
            },
          ),
          SafeArea(
                child: Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 10),
                  child: Expanded(
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
                            ToolNavButton(
                              icon: Icons.filter_list,
                              onPressed: _navigateToFilterScreen,
                            ),

                          ],
                        ),
                      ],
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