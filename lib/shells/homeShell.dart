import 'package:flutter/material.dart';
import 'package:supermapper/screens/addSpotScreens/add_spot_screen.dart';
import 'package:supermapper/screens/home_screen.dart';
import 'package:supermapper/screens/map_screen.dart';
import 'package:supermapper/screens/profile_screen.dart';
import 'package:supermapper/screens/settings_screen.dart';
import 'package:supermapper/theme.dart';
import 'package:supermapper/widgets/navBarButton.dart';
import 'package:supermapper/transitions/customSlideTransition.dart';
import 'package:supermapper/widgets/spot.dart';

const double _borderWidth = 3.0;

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  static const _homeIndex = 0;
  static const _mapIndex = 1;
  static const _profileIndex = 2;
  

  final _mapKey = GlobalKey<MapScreenState>();
  final _profileKey = GlobalKey<ProfileScreenState>();
  final _homeKey = GlobalKey<HomeScreenState>();

  int _currentIndex = _homeIndex;

  late final List<Widget> _screens = [
    HomeScreen(
      key: _homeKey,
      onProfileButtonPressed: () => _goTo(_profileIndex),
      onMapCardPressed: () => _goTo(_mapIndex),
      onSpotCardPressed: _openSpotOnMap,
    ),
    MapScreen(key: _mapKey, onAddButtonPressed: _navigateToAddSpotScreen),
    ProfileScreen(
      key: _profileKey,
      onSpotDeleted: () {
        _mapKey.currentState?.fetchSpotsData();
      },
    ),
   // SettingsScreen(),
  ];

  void _openSpotOnMap(Spot spot) {
    setState(() {
      _currentIndex = _mapIndex;
    });
    _mapKey.currentState?.openSpot(spot);
  }


  void _goTo(int index) {
    setState(() => _currentIndex = index);
    if (index == _homeIndex) {
      _homeKey.currentState?.reload();
    }
      
    if (index == _profileIndex) {
      _profileKey.currentState?.reload();
    }
  
  }

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

  Widget _navButton(IconData icon, int index) {
    final isActive = _currentIndex == index;

    return NavBarButton(
      icon: icon,
      isActive: isActive,
      textColor: isActive ? Colors.black : Colors.grey,
      onPressed: () => _goTo(index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.black, width: _borderWidth),
          ),
        ),
        child: BottomAppBar(
          color: AppColors.surfaceLight,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 100),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _navButton(Icons.home_filled, _homeIndex),
              _navButton(Icons.map_outlined, _mapIndex),
              _navButton(Icons.person_outline_outlined, _profileIndex),
              //_navButton(Icons.settings_outlined, _settingsIndex),
            ],
          ),
        ),
      ),
    );
  }
}