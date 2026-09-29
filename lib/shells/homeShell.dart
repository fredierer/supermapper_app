import 'package:flutter/material.dart';
import 'package:supermapper_app/screens/map_screen.dart';
import 'package:supermapper_app/screens/settings_screen.dart';
import 'package:supermapper_app/theme.dart';
import 'package:supermapper_app/widgets/nav_bar_icon.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    MapScreen(),
    SettingsScreen(),
  ];
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
      extendBody: true,
      body: Stack(
        children: [
          _screens[_currentIndex],
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
      
      bottomNavigationBar:  BottomAppBar(
        color: AppColors.surfaceLight,
        elevation: 4,
        shadowColor: Colors.black,
        shape: const CircularNotchedRectangle(),
        notchMargin: _currentIndex == 0 ? 12.0 : 0.0, 
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
                onPressed: () {setState(() => _currentIndex = 0);},
                padding: EdgeInsets.zero,
                style: IconButton.styleFrom(
                  iconSize: 32,
                  backgroundColor: Colors.transparent,
                  foregroundColor: AppColors.darkNavy.withAlpha(_currentIndex == 0 ? 255 : 60),
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
                onPressed: () {
                  setState(() {
                    _currentIndex = 1;
                    if(_addMenuOpen) {
                      _toggleAddMenu();
                    }
                  });
                },
                padding: EdgeInsets.zero,
                style: IconButton.styleFrom(
                  iconSize: 32,
                  backgroundColor: Colors.transparent,
                  foregroundColor: AppColors.darkNavy.withAlpha(_currentIndex == 1 ? 255 : 60),
                ),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: Visibility(
          visible: _currentIndex == 0,
          child: RawMaterialButton(
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