import 'package:flutter/material.dart';
import 'package:supermapper_app/screens/filter_screen.dart';
import 'package:supermapper_app/screens/search_screen.dart';
import 'package:supermapper_app/theme.dart';
import 'package:supermapper_app/widgets/map.dart';
import 'package:supermapper_app/widgets/nav_bar_icon.dart';
import 'package:supermapper_app/transitions/customSlideTransition.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _mapScreenState();

}
class _mapScreenState extends State<MapScreen> with SingleTickerProviderStateMixin {

  late AnimationController _addButtonController;
  bool _addMenuOpen = false;

  
  void _toggleAddMenu() {
    setState(() {
      _addMenuOpen = !_addMenuOpen;
    });

    if(_addMenuOpen) {
      _addButtonController.forward();
    } else {
      _addButtonController.reverse();
    }

  }


  @override
  void initState() {
    super.initState();
    _addButtonController = AnimationController(vsync: this,duration: const Duration(milliseconds: 300));
    _addButtonController.reverseDuration = Duration(milliseconds: 200);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: Stack(
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
          AnimatedBuilder(
            animation: _addButtonController, 
            builder: (context, child) {
              final double offsetY = 60 * _addButtonController.value;
              final double offsetX = 0 * _addButtonController.value;

              return SafeArea(
                child: Padding(
                  padding: EdgeInsetsGeometry.all(0),
                  child: Expanded(
                    child : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Bouton spot
                            Transform.translate(
                              offset: Offset(offsetX, -offsetY), // Décalage diagonal haut-droite
                              child: Opacity(
                                opacity: _addButtonController.value, // Apparaît progressivement
                                child: NavBarIcon(
                                  icon: Icons.add_location_alt_outlined,
                                  textColor: AppColors.surfaceLight,
                                  backgroundColor: AppColors.orange,
                                  label: 'Add a spot',
                                  onPressed: () {},
                                ),
                              ),
                            ),

                            SizedBox(height: 4,),

                            //Bouton route
                            Transform.translate(
                              offset: Offset(offsetX, -offsetY), // Décalage diagonal haut-droite
                              child: Opacity(
                                opacity: _addButtonController.value, // Apparaît progressivement
                                child: NavBarIcon(
                                  icon: Icons.route_outlined,
                                  textColor: AppColors.surfaceLight,
                                  backgroundColor: AppColors.orange,
                                  label: 'Add a route',
                                  onPressed: () {},
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  )
                )
              );
            }
          ),
        ]
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.surfaceLight,
        shape: const CircularNotchedRectangle(),
        notchMargin: 12.0, 
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Bouton gauche (Carte)
            SizedBox(
              width: 64,
              height: 64,
              child: IconButton(
                icon: const Icon(Icons.map_outlined),
                onPressed: () {},
                padding: EdgeInsets.zero,
                style: IconButton.styleFrom(
                  iconSize: 32,
                  backgroundColor: Colors.transparent,
                  foregroundColor: AppColors.darkNavy.withAlpha(255),
                ),
              ),
            ),

            // Espace vide au centre pour laisser place au bouton flottant
            const SizedBox(width: 120), 

            //Bouton droite (Settings)
            SizedBox(
              width: 64,
              height: 64,
              child: IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () {},
                padding: EdgeInsets.zero,
                style: IconButton.styleFrom(
                  iconSize: 32,
                  backgroundColor: Colors.transparent,
                  foregroundColor: AppColors.darkNavy.withAlpha(80),
                ),
              ),
            ),
          ],
        ),
      ),

// N'oublie pas d'importer dart:ui pour ImageFilter

      floatingActionButton: RawMaterialButton(
        onPressed: _toggleAddMenu,
        fillColor: AppColors.darkNavy,
        elevation: 4,
        shape: const CircleBorder(),
        constraints: const BoxConstraints(
          minWidth: 100,
          minHeight: 100,
        ),
        child: const Icon(Icons.add, size: 64, color: Colors.white),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }


  @override
  void dispose() {
    _addButtonController.dispose();
    super.dispose();
  }
}
