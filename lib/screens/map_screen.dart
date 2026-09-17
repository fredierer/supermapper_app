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

  final List<LowBandButton> _lowBandButtons = [
    LowBandButton(
      icon: Icons.search, 
      label: "Search", 
      onPressed: () => print("Chercher chercher"),
    ),
    LowBandButton(
      icon: Icons.layers, 
      label: "Calques", 
      onPressed: () => print("Je change de calque"),
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
                        onPressed: () {},
                        child :
                          Icon(Icons.arrow_drop_up_rounded, size: 30, )
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
                        itemCount: _lowBandButtons.length,
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




