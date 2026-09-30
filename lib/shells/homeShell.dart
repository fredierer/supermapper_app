import 'package:flutter/material.dart';
import 'package:supermapper_app/screens/map_screen.dart';
import 'package:supermapper_app/screens/settings_screen.dart';
import 'package:supermapper_app/services/spots_service.dart';
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
  late Animation<double> _curvedAnimation;
  late final Animation<Offset> _spotOffsetAnimation;
  late final Animation<Offset> _routeOffsetAnimation;

  bool _addMenuOpen = false;
  
  void _toggleAddMenu() {
    print ("TOOOOGLLLGLLELLLEEEE ++");
    SpotService().getSpots();
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
    _addButtonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 250),
    );

    // Courbe dynamique pour l'ouverture, nette pour la fermeture
    _curvedAnimation = CurvedAnimation(
      parent: _addButtonController,
      curve: Curves.easeOutBack, // Petit effet élastique moderne
      reverseCurve: Curves.easeInQuad,
    );

    // Pré-calcul des décalages (Traductions)
    _spotOffsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -105), // Décalage final vers le haut
    ).animate(_curvedAnimation);

    _routeOffsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -55),
    ).animate(_curvedAnimation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          _screens[_currentIndex],

          // Menu d'ajout optimisé
          SafeArea(
            child: IgnorePointer(
              ignoring: !_addMenuOpen, // Empêche d'intercepter les clics quand fermé
              child: Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedBuilder(
                  animation: _curvedAnimation,
                  builder: (context, child) {
                    final double opacity = _addButtonController.value.clamp(0.0, 1.0);

                    return Stack(
                      alignment: Alignment.bottomCenter,
                      clipBehavior: Clip.none,
                      children: [

                              // Bouton spot
                              Transform.translate(
                          offset: _spotOffsetAnimation.value,
                          child: Opacity(
                            opacity: opacity,
                            child: NavBarIcon(
                              icon: Icons.add_location_alt_outlined,
                              textColor: AppColors.surfaceLight,
                              backgroundColor: AppColors.orange,
                              label: 'Add a spot',
                              onPressed: () {},
                            ),
                          ),
                        ),

                        // Bouton Route
                        Transform.translate(
                          offset: _routeOffsetAnimation.value,
                          child: Opacity(
                            opacity: opacity,
                            child: NavBarIcon(
                              icon: Icons.route_outlined,
                              textColor: AppColors.surfaceLight,
                              backgroundColor: AppColors.orange,
                              label: 'Add a route',
                              onPressed: () {},
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