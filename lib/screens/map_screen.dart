import 'package:flutter/material.dart';
import 'package:supermapper_app/widgets/lowBandButton.dart';
import 'package:supermapper_app/widgets/map.dart';
import 'package:supermapper_app/theme.dart';
import 'package:supermapper_app/widgets/add_window.dart';


class mapScreen extends StatefulWidget {
  const mapScreen({super.key});

  @override
  State<mapScreen> createState() => _mapScreenState();


}
class _mapScreenState extends State<mapScreen> {
  bool _addDialogShown = false;
  bool _lowBandExtended = false;

  final List<Widget> _lowBandButtons = [
    InkWell(
      onTap: () {
        //To determine
      },
      borderRadius: BorderRadius.circular(16),
      child: Card(
        color: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Bordure subtile
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.search, size:40),
            Text("Search", style: TextStyle(fontSize: 10),)
          ],
        ),
      ),
    ),
    FilterButton(
      icon: Icons.airport_shuttle, 
      label: "Transport", 
      color: Colors.green.shade300,
      onPressed: () => print("Filtre transport"),
    ),
    FilterButton(
      icon: Icons.work, 
      label: "Borders", 
      color: Colors.lightBlue,
      onPressed: () => print("Filtre Borders"),
    ),
    FilterButton(
      icon: Icons.restaurant_menu_rounded, 
      label: "Restaurant", 
      color: Colors.orange,
      onPressed: () => print("Filtre Restaurant"),
    ),
    FilterButton(
      icon: Icons.landscape_rounded, 
      label: "Scenic view", 
      color: Colors.green.shade700,
      onPressed: () => print("Scenic view"),
    ),
    FilterButton(
      icon: Icons.account_balance_rounded, 
      label: "Administation", 
      color: Colors.deepPurpleAccent.shade200,
      onPressed: () => print("Administration"),
    ),
    FilterButton(
      icon: Icons.window_outlined, 
      label: "Others", 
      color: Colors.brown.shade700,
      onPressed: () => print("Others"),
    ),
  ];
  final List<Widget> _bigFilterButtons = [
    InkWell(
      onTap: () {
        //To determine
      },
      borderRadius: BorderRadius.circular(16),
      child: Card(
        color: AppColors.primary.withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Bordure subtile
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.flag_outlined, size : 40, color: Colors.grey.shade800),
            Text("Filter by country", style: TextStyle(color: Colors.grey.shade800, fontSize: 15),)
          ],
        ),
      ),
    ),
    InkWell(
      onTap: () {
        //To determine
      },
      borderRadius: BorderRadius.circular(16),
      child: Card(
        color: AppColors.primary.withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Bordure subtile
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.date_range, size : 40, color: Colors.grey.shade800),
            Text("Filter by dates", style: TextStyle(color: Colors.grey.shade800, fontSize: 15),)
          ],
        ),
      ),
    ),
  ];

  void _showAddDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AddWindow();
    },
  );
}
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: Stack(
        children: [
          MapWidget(),
          SafeArea(child: 
            Padding(padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15), child: 
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.search, size: 24,),
                    onPressed: () {},
                    style: IconButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(14),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_list, size: 24,),
                    onPressed: () {},
                    style: IconButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(14),
                    ),
                  ),
                ],
              )
            )
          )
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
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.settings_outlined, size: 30),
              onPressed: () {},
            ),
            
            // Espace vide au centre pour laisser place au bouton flottant
            const SizedBox(width: 120), 
            
            // Bouton droit (Paramètres)
            IconButton(
              icon: const Icon(Icons.settings_outlined, size: 30),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.settings_outlined, size: 30),
              onPressed: () {},
            ),
          ],
        ),
      ),


      floatingActionButton: RawMaterialButton(
        onPressed: () {},
        fillColor: Colors.blue,
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
}
