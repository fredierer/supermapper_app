import 'package:flutter/material.dart';
import 'package:supermapper_app/screens/filter_screen.dart';
import 'package:supermapper_app/screens/search_screen.dart';
import 'package:supermapper_app/widgets/map.dart';
import 'package:supermapper_app/transitions/customSlideTransition.dart';
import 'package:supermapper_app/services/spots_service.dart';
import 'package:supermapper_app/widgets/spot.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _mapScreenState();

}
class _mapScreenState extends State<MapScreen> {

  final SpotService _spotService = SpotService();
  List<Spot> _spots = [];

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

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          MapWidget(spots: _spots),
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
                            IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () {
                                Navigator.of(context).push(
                                  customSlidefromLeft(const SearchScreen()),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.filter_list),
                              onPressed: () {
                                Navigator.of(context).push(
                                  customSlidefromRight(const FilterScreen()),
                                );
                              },
                            ),

                          ],
                        ),
                      ],
                    ),
                  ),
                ),
          ),
        ]
      );
  }
}