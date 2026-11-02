import 'package:flutter/material.dart';
import 'package:supermapper_app/theme.dart';
import 'package:supermapper_app/widgets/statCard.dart';

class PersonalContribution {
  final String title;
  final String description;
  final String date;
  final String place;

  const PersonalContribution({
    required this.title,
    required this.description,
    required this.date,
    required this.place,
  });
}

class ProfileScreen extends StatelessWidget {

final List<PersonalContribution> recentContributions = [
    PersonalContribution(
      title: 'Café Bonaparte',
      description: 'Super spot pour travailler, wifi rapide et prises à chaque table.',
      date: '28/10/2026 09:12',
      place: "Paris, France",
    ),
    PersonalContribution(
      title: 'Parc des Buttes',
      description: 'Très calme en semaine, idéal pour un pique-nique.',
      date: '27/10/2026 17:40',
      place: "Paris, France",
    ),
    PersonalContribution(
      title: 'Chez Marcel',
      description: 'Bon rapport qualité-prix, service rapide le midi.',
      date: '25/10/2026 12:05',
      place: "Marseille, France",
    ),
    PersonalContribution(
      title: 'Point de vue Sacré-Cœur',
      description: 'Vue superbe au coucher du soleil, mais beaucoup de monde.',
      date: '24/10/2026 19:30',
      place: "Paris, France",
    ),
    PersonalContribution(
      title: 'Librairie du Canal',
      description: 'Petite librairie indépendante avec un coin lecture.',
      date: '22/10/2026 14:18',
      place: "Lyon, France",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      extendBody: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 0),
          child: Container(
            color: AppColors.surfaceLight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 200.0,
                  width: double.infinity,
                  child: Align(
                    alignment: AlignmentGeometry.bottomCenter,
                    child: CircleAvatar(
                      backgroundColor: Colors.black12,
                      radius: 60.0,
                      child: Icon(Icons.person, size: 50.0, color: Colors.black54,),
                    ),
                  ),
                ),
                
                Padding(
                  padding: EdgeInsetsGeometry.fromLTRB(0, 10, 0, 0), 
                  child: Align(
                    alignment: AlignmentGeometry.center, 
                    child : Text("Rémy", 
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ) 
                    )
                  ),
                ),

                Container(
                  width: double.infinity,
                  color: AppColors.surfaceLight,   
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: const Text(
                    "STATISTICS",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 26,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),

                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  spacing: 12.0,
                  children: [
                    Expanded(
                      child: StatCard(
                        icon: Icons.edit_location_alt_outlined,
                        value: '42',
                        label: 'Contributions',
                      ),
                    ),
                    Expanded(
                      child: StatCard(
                        icon: Icons.public,
                        value: '7',
                        label: 'Pays',
                      ),
                    ),
                    Expanded(
                      child: StatCard(
                        icon: Icons.trending_up,
                        value: '3 / sem.',
                        label: 'Fréquence',
                      ),
                    ),
                  ],
                ),
              
                SizedBox(height: 10.0,),
                
                Container(
                  width: double.infinity,
                  color: AppColors.surfaceLight,   
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: const Text(
                    "YOUR CONTRIBUTIONS",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 26,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),

                GridView.builder(
                  shrinkWrap: true, // la grille prend juste la hauteur de son contenu
                  physics: const NeverScrollableScrollPhysics(), // c'est la page qui scrolle, pas la grille
                  padding: EdgeInsets.zero,
                  itemCount: 4, // 2 x 2
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    mainAxisExtent: 160, // hauteur fixe de chaque carte
                  ),
                  itemBuilder: (context, index) {
                    final contribution = recentContributions[index];
                    return Material(
                      color: Colors.white,
                      elevation: 2,
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              contribution.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              contribution.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14, color: Colors.black54),
                            ),
                            const Spacer(),
                            Text(
                              contribution.date,
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: () {
                      // Navigator.push(...) vers l'écran avec toutes les contributions
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('See All'),
                  ),
                ),

                
              ]
            ),
          )
        )
      ), 
    );
  }

}