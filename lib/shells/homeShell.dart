import 'package:flutter/material.dart';
import 'package:supermapper_app/screens/addSpotScreens/add_spot_screen.dart';
import 'package:supermapper_app/screens/map_screen.dart';
import 'package:supermapper_app/screens/settings_screen.dart';
import 'package:supermapper_app/services/spots_service.dart';
import 'package:supermapper_app/theme.dart';
import 'package:supermapper_app/widgets/AddFeedbackButton.dart';
import 'package:supermapper_app/widgets/navBarButton.dart';
import 'package:supermapper_app/transitions/customSlideTransition.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}              

class _HomeShellState extends State<HomeShell> with SingleTickerProviderStateMixin {
  final _mapKey = GlobalKey<MapScreenState>();
  
  int _currentIndex = 0;
  late final List<Widget> _screens = [
    MapScreen(key: _mapKey,),
    SettingsScreen(),
  ];
  late AnimationController _addButtonController;
  late Animation<double> _curvedAnimation;
  late final Animation<Offset> _spotOffsetAnimation;
  late final Animation<Offset> _routeOffsetAnimation;

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

  Future<void> _navigateToAddSpotScreen() async {
    final added = await Navigator.of(context).push(
      customSlidefromBottom(AddSpotScreen()),
    );
    if (added == true) {
      _mapKey.currentState?.fetchSpotsData();
    }
  }
  @override
  void initState() {
    super.initState();
    _addButtonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 250),
    );

    _curvedAnimation = CurvedAnimation(
      parent: _addButtonController,
      curve: Curves.easeOutBack, 
      reverseCurve: Curves.easeInQuad,
    );

    _spotOffsetAnimation = Tween<Offset>(
    begin: const Offset(1, -1.25), 
    end: const Offset(0, -1.25),   
  ).animate(_curvedAnimation);

  _routeOffsetAnimation = Tween<Offset>(
    begin: const Offset(-1, -2.35),
    end: const Offset(0, -2.35),
  ).animate(_curvedAnimation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          _screens[_currentIndex],
          SafeArea(
            child: IgnorePointer(
              ignoring: !_addMenuOpen,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 300,
                  child : AnimatedBuilder(
                    animation: _curvedAnimation,
                    builder: (context, child) {
                      final double opacity = _addButtonController.value.clamp(0.0, 1.0);
                      return Stack(
                        alignment: Alignment.bottomCenter,
                        clipBehavior: Clip.none,
                        children: [
                          SlideTransition(
                            position: _spotOffsetAnimation,
                            child: Opacity(
                              opacity: opacity,
                              child: AddFeedBackButton(
                                icon: Icons.add_location_alt_outlined,
                                textColor: Colors.black,
                                label: 'Add a spot',
                                onPressed: () { // referme le petit menu
                                  // _navigateToAddSpotScreen(); Mise en commentaire pour l'instant. A voir quand on mettra les routes TO DO

                                },
                              ),
                            ),
                          ),

                          // Bouton Route
                          SlideTransition(
                            position: _routeOffsetAnimation,
                            child: Opacity(
                              opacity: opacity,
                              child: AddFeedBackButton(
                                icon: Icons.route_outlined,
                                textColor: Colors.black,
                                label: 'Add a route',
                                onPressed: () {
                                  
                                },
                              )
                            )
                          )
                        ]
                      );
                    }
                  )
                )
              )
            ),
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
              //Bouton gauche (Map)
              NavBarButton(
                icon: Icons.map_outlined,
                textColor: _currentIndex == 0 ? Colors.black : Colors.grey,
                onPressed: () {setState(() => _currentIndex = 0);},
              ),
            

            // Espace vide au centre pour laisser place au bouton flottant
            const SizedBox(width: 120), 

            //Bouton droite (Settings)
            NavBarButton(
              icon: Icons.settings_outlined,
              textColor: _currentIndex == 1 ? Colors.black : Colors.grey,
              onPressed: () {setState(() => _currentIndex = 1);},
            ),
          ],
        ),
      ),

      floatingActionButton: Visibility(
          visible: _currentIndex == 0,
          child: RawMaterialButton(
            onPressed: _navigateToAddSpotScreen,
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