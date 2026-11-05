import 'package:flutter/material.dart';
import 'package:supermapper_app/screens/addSpotScreens/add_spot_screen.dart';
import 'package:supermapper_app/screens/home_screen.dart';
import 'package:supermapper_app/screens/map_screen.dart';
import 'package:supermapper_app/screens/profile_screen.dart';
import 'package:supermapper_app/screens/settings_screen.dart';
import 'package:supermapper_app/theme.dart';
import 'package:supermapper_app/widgets/navBarButton.dart';
import 'package:supermapper_app/transitions/customSlideTransition.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}              

class _HomeShellState extends State<HomeShell> with SingleTickerProviderStateMixin {
  final _mapKey = GlobalKey<MapScreenState>();
  final _profileKey = GlobalKey<ProfileScreenState>();
  
  int _currentIndex = 0;
  late final List<Widget> _screens = [
    HomeScreen(onProfileButtonPressed: _navigateToProfileScreen, onMapCardPressed : _navigateToMapScreen),
    MapScreen(key: _mapKey, onAddButtonPressed: _navigateToAddSpotScreen),
    ProfileScreen(key: _profileKey),
    SettingsScreen(),
  ];
  late AnimationController _addButtonController;
  late Animation<double> _curvedAnimation;
  late final Animation<Offset> _spotOffsetAnimation;
  late final Animation<Offset> _routeOffsetAnimation;

  bool _addMenuOpen = false;

  Future<void> _navigateToAddSpotScreen() async {

    final camera = _mapKey.currentState?.currentCamera;

    final added = await Navigator.of(context).push(
      customSlidefromBottom(AddSpotScreen(
        initialLat: camera?.lat,
        initialLng: camera?.lng, 
        initialZoom: camera?.zoom,  
      )),
    );
    if (added == true) {
      _mapKey.currentState?.fetchSpotsData();
    }
  }

  void _navigateToProfileScreen() {
    setState(() {
      _currentIndex = 2;
      _profileKey.currentState?.reload();
    });
  }

  void _navigateToMapScreen() {
    setState(() {
      _currentIndex = 1;
    });
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
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),    
        ]
      ),         
      
      bottomNavigationBar:  BottomAppBar(
        color: AppColors.surfaceLight,
        elevation: 4,
        shadowColor: Colors.black,
        shape: const CircularNotchedRectangle(),
        notchMargin: _currentIndex == 0 ? 12.0 : 0.0, 
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Bouton gauche (Map)
              NavBarButton(
                icon: Icons.home_filled,
                textColor: _currentIndex == 0 ? Colors.black : Colors.grey,
                onPressed: () {setState(() => _currentIndex = 0);},
              ),
              
              //const SizedBox(width: 40),
              
              NavBarButton(
                icon: Icons.map_outlined,
                textColor: _currentIndex == 1 ? Colors.black : Colors.grey,
                onPressed: () {setState(() => _currentIndex = 1);},
              ),

              //const SizedBox(width: 120), 

              //Bouton droite (Settings)
              NavBarButton(
                icon: Icons.person_outline_outlined,
                textColor: _currentIndex == 2 ? Colors.black : Colors.grey,
                onPressed: () {
                  setState(() {
                    _profileKey.currentState?.reload();
                    _currentIndex = 2;
                  });
                },
              ),

              //const SizedBox(width: 40),

              NavBarButton(
                icon: Icons.settings_outlined,
                textColor: _currentIndex == 3 ? Colors.black : Colors.grey,
                onPressed: () {setState(() => _currentIndex = 3);},
              ),
            ],
          ),
        ),
      ), 
    );
    
  }

  @override
  void dispose() {
    _addButtonController.dispose();
    super.dispose();
  }
}