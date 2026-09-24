import 'package:flutter/material.dart';
import 'package:supermapper_app/screens/filter_screen.dart';
import 'package:supermapper_app/screens/search_screen.dart';
import 'package:supermapper_app/widgets/map.dart';
import 'package:supermapper_app/theme.dart';


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
                              icon: const Icon(Icons.search, size: 24,),
                              onPressed: () {
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return SearchScreen();
                                    }
                                  )
                                );
                              },
                              style: IconButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(14),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.filter_list, size: 24,),
                              onPressed: () {
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return FilterScreen();
                                    }
                                  )
                                );
                              },
                              style: IconButton.styleFrom(
                                shape: const CircleBorder(),
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.all(14),
                              ),
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
              final double offsetY = 50 * _addButtonController.value;
              final double offsetX = 15 * _addButtonController.value;

              return SafeArea(
                child: Padding(
                  padding: EdgeInsetsGeometry.all(0),
                  child: Expanded(
                    child : Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Transform.translate(
                              offset: Offset(-offsetX, -offsetY), // Décalage diagonal haut-droite
                              child: Opacity(
                                opacity: _addButtonController.value, // Apparaît progressivement
                                child: IconButton(
                                  icon: const Icon(Icons.add_location_alt_outlined, size: 28,),
                                  onPressed: () {},
                                  style: IconButton.styleFrom(
                                    shape: const CircleBorder(),
                                    backgroundColor: Color.fromARGB(255, 143, 197, 241),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.all(20),
                                  ),
                                ),
                              ),
                            ),
                            
                            // Bouton Orange (Bas-Gauche)
                            Transform.translate(
                              offset: Offset(offsetX, -offsetY), // Décalage diagonal haut-droite
                              child: Opacity(
                                opacity: _addButtonController.value, // Apparaît progressivement
                                child: IconButton(
                                  icon: const Icon(Icons.route, size: 28,),
                                  onPressed: () {},
                                  style: IconButton.styleFrom(
                                    shape: const CircleBorder(),
                                    backgroundColor: Color.fromARGB(255, 143, 197, 241),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.all(20),
                                  ),
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
        color: const Color.fromARGB(255, 193, 227, 255),
        shape: const CircularNotchedRectangle(),
        notchMargin: 12.0, 
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Bouton gauche (Carte)
            IconButton(
              icon: const Icon(Icons.map_outlined, size: 30),
              style: IconButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: Colors.blue.withValues(alpha: 0.2),
                foregroundColor: Colors.white.withValues(alpha: 0.8),
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.settings_outlined, size: 30),
              style: IconButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.black.withValues(alpha: 0.4),
              ),
              onPressed: () {},
            ),
            
            // Espace vide au centre pour laisser place au bouton flottant
            const SizedBox(width: 120), 
            
            // Bouton droit (Paramètres)
            IconButton(
              icon: const Icon(Icons.settings_outlined, size: 30),
              style: IconButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.black.withValues(alpha: 0.4),
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.settings_outlined, size: 30),
              style: IconButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.black.withValues(alpha: 0.4),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),


      floatingActionButton: RawMaterialButton(
        onPressed: _toggleAddMenu,
        fillColor: const Color.fromARGB(255, 33, 150, 243),
        elevation: 4,
        shape: const CircleBorder(),
        constraints: const BoxConstraints(
          minWidth: 80,
          minHeight: 80,
        ),
        child: const Icon(Icons.add, size: 40, color: Colors.white),
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
