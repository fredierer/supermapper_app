import 'package:flutter/material.dart';
import 'package:supermapper_app/screens/filter_screen.dart';
import 'package:supermapper_app/screens/search_screen.dart';
import 'package:supermapper_app/widgets/map.dart';
import 'package:supermapper_app/transitions/customSlideTransition.dart';
import 'package:supermapper_app/services/spots_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _mapScreenState();

}
class _mapScreenState extends State<MapScreen> {

  final SpotService _spotService = SpotService();

  @override
  void initState() {
    super.initState();
    _fetchSpotsData();
  }

  Future<void> _fetchSpotsData() async {
    await _spotService.getSpots();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          MapWidget(),
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