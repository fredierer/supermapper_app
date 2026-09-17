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
      body: Stack(
        children: [
          MapWidget(),
          SafeArea(child: 
            Padding(padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15), child: 
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary, // Fond blanc épuré
                          foregroundColor: AppColors.background, // Couleur du texte / icône
                          elevation: 0,
                          fixedSize: const Size(80, 40), // Hauteur fixe de 52px, largeur responsive
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16), // Bordure fine
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Join",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 10), // Fond blanc épuré
                          foregroundColor: Colors.black, // Couleur du texte / icône
                          elevation: 0,
                          fixedSize: const Size(60, 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16), // Bordure fine
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        onPressed: () {
                          setState(() {
                            _lowBandExtended = !_lowBandExtended;
                            print(_lowBandExtended);
                          });
                        },
                        child :
                          Icon(_lowBandExtended ? Icons.arrow_drop_down_rounded : Icons.arrow_drop_up_rounded, size: 30, )
                      ),
                      SizedBox(width: double.infinity, height: 15,),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary, // Fond blanc épuré
                          foregroundColor: AppColors.background, // Couleur du texte / icône
                          elevation: 0,
                          fixedSize: const Size(double.infinity, 50), // Hauteur fixe de 52px, largeur responsive
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16), // Bordure fine
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        onPressed: () => _showAddDialog(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              " Add",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: double.infinity, height: 15,),   
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _lowBandExtended ? _lowBandButtons.length : 5,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          return _lowBandButtons[index];
                        }
                      ),
                      SizedBox(height: 10,width: double.infinity,),
                      if (_lowBandExtended)
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 2,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 2.5,
                          ),
                          itemBuilder: (context, index) {
                            return _bigFilterButtons[index];
                          }
                        ),
                    ],
                  ),
                ]
              )
            )
          ),
        ]
      )
    );
  }
}




