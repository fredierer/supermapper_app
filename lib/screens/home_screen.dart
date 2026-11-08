

import 'package:flutter/material.dart';
import 'package:supermapper_app/services/spots_service.dart';
import 'package:supermapper_app/theme.dart';
import 'package:supermapper_app/widgets/spot.dart';
import 'package:intl/intl.dart';

class Contribution {
  final String title;
  final String description;
  final String date;
  final String place;
  final String author;

  const Contribution({
    required this.title,
    required this.description,
    required this.date,
    required this.place,
    required this.author,
  });
}

class SavedSpot {
  final String title;
  final String description;
  final String date;
  final String place;
  final String author;

  const SavedSpot({
    required this.title,
    required this.description,
    required this.date,
    required this.place,
    required this.author,
  });
}


class HomeScreen extends StatefulWidget {
  final VoidCallback onProfileButtonPressed;
  final VoidCallback onMapCardPressed;

  const HomeScreen({
    super.key,
    required this.onProfileButtonPressed,
    required this.onMapCardPressed,
  });


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  final _spotService = SpotService();
  late Future<List<Spot>> _recentSpots;

  static final _dateFormat = DateFormat('dd/MM/yyyy HH:mm');


  final List<Contribution> recentContributions = [
    Contribution(
      title: 'Café Bonaparte',
      description: 'Super spot pour travailler, wifi rapide et prises à chaque table.',
      date: '28/10/2026 09:12',
      place: "Paris, France",
      author: 'Rémy',
    ),
    Contribution(
      title: 'Parc des Buttes',
      description: 'Très calme en semaine, idéal pour un pique-nique.',
      date: '27/10/2026 17:40',
      place: "Paris, France",
      author: 'Camille',
    ),
    Contribution(
      title: 'Chez Marcel',
      description: 'Bon rapport qualité-prix, service rapide le midi.',
      date: '25/10/2026 12:05',
      place: "Marseille, France",
      author: 'Léa',
    ),
    Contribution(
      title: 'Point de vue Sacré-Cœur',
      description: 'Vue superbe au coucher du soleil, mais beaucoup de monde.',
      date: '24/10/2026 19:30',
      place: "Paris, France",
      author: 'Tom',
    ),
    Contribution(
      title: 'Librairie du Canal',
      description: 'Petite librairie indépendante avec un coin lecture.',
      date: '22/10/2026 14:18',
      place: "Lyon, France",
      author: 'Rémy',
    ),
  ];

  final List<SavedSpot> savedSpots = [
    SavedSpot(
      title: 'Café Bonaparte',
      description: 'Super spot pour travailler, wifi rapide et prises à chaque table.',
      date: '28/10/2026 09:12',
      place: "Paris, France",
      author: 'Rémy',
    ),
    SavedSpot(
      title: 'Parc des Buttes',
      description: 'Très calme en semaine, idéal pour un pique-nique.',
      date: '27/10/2026 17:40',
      place: "Paris, France",
      author: 'Camille',
    ),
    SavedSpot(
      title: 'Chez Marcel',
      description: 'Bon rapport qualité-prix, service rapide le midi.',
      date: '25/10/2026 12:05',
      place: "Marseille, France",
      author: 'Léa',
    ),
    SavedSpot(
      title: 'Point de vue Sacré-Cœur',
      description: 'Vue superbe au coucher du soleil, mais beaucoup de monde.',
      date: '24/10/2026 19:30',
      place: "Paris, France",
      author: 'Tom',
    ),
    SavedSpot(
      title: 'Librairie du Canal',
      description: 'Petite librairie indépendante avec un coin lecture.',
      date: '22/10/2026 14:18',
      place: "Lyon, France",
      author: 'Rémy',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _recentSpots = _spotService.getSpots(max: 5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      extendBody: true,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 30, vertical: 20),
          child: Container(
            color: AppColors.surfaceLight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Hi, ",
                      style: TextStyle(
                        fontSize: 52.0,
                        fontWeight: FontWeight.bold,
                      ),  
                    ),
                    IconButton(
                      onPressed: widget.onProfileButtonPressed,
                      iconSize: 12,
                      icon: Icon(Icons.person, color: Colors.black, size: 25.0,),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 2,
                        shadowColor: Colors.black,
                        fixedSize: Size(50, 50),
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  width: double.infinity,
                  height: 30.0,
                ),

                Container(
                  width: double.infinity,
                  color: AppColors.surfaceLight,   
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: const Text(
                    "RECENT CONTRIBUTION",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 26,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),

                FutureBuilder<List<Spot>>(
                  future: _recentSpots,
                  builder: (recent, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        height: 150.0,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (snapshot.hasError) {
                      return SizedBox(
                        height: 150.0,
                        child: Center(child: Text('Erreur : ${snapshot.error}')),
                      );
                    }

                    final spots = snapshot.data ?? [];

                    if (spots.isEmpty) {
                      return const SizedBox(
                        height: 150.0,
                        child: Center(child: Text('No contribution for now 😢')),
                      );
                    }

                    return SizedBox(
                      height: 150.0,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        clipBehavior: Clip.none,
                        itemCount: spots.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final spot = spots[index];
                          return SizedBox(
                            width: 200.0,
                            child: Material(
                              color: Colors.white,
                              elevation: 2,
                              borderRadius: BorderRadius.circular(16),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      spot.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      spot.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                                    ),
                                    const Spacer(),
                                    const SizedBox(height: 2),
                                    Text(
                                      _dateFormat.format(spot.creationDate),
                                      style: const TextStyle(fontSize: 12, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      )
                    );
                  }
                ),

                SizedBox(
                  width: double.infinity,
                  height: 30.0,
                ),

                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 12.0,
                  children: [
                    FilledButton.icon(
                      onPressed: widget.onMapCardPressed,
                      icon: const Icon(Icons.map_outlined, size: 20),
                      label: const Text('Map'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        fixedSize: const Size.fromHeight(50),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    FilledButton.icon(
                      onPressed: widget.onProfileButtonPressed,
                      icon: const Icon(Icons.person, size: 20),
                      label: const Text('Profile'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        fixedSize: const Size.fromHeight(50),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),


                  ],
                ),

                SizedBox(
                  width: double.infinity,
                  height: 30.0,
                ),

              //  Container(
              //    width: double.infinity,
              //    color: AppColors.surfaceLight,   
              //    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              //    child: const Text(
              //      "SAVED SPOTS",
              //      style: TextStyle(
              //        color: Colors.grey,
              //        fontSize: 26,
              //        letterSpacing: 1.5,
              //      ),
              //    ),
              //  ),

              //  LayoutBuilder(builder: (context, constraints) {
              //    return SizedBox(
              //      height: 200.0,
              //      child: ListView.separated(
              //        scrollDirection: Axis.horizontal,
              //        clipBehavior: Clip.none, 
              //        itemCount: 3,
              //        separatorBuilder: (_, _) => const SizedBox(width: 12),
              //        itemBuilder: (context, index) {
              //          final savedSpot = savedSpots[index];
              //          return SizedBox(
              //            width: 250.0,
              //            child: Material(
              //              color: Colors.white,
              //              elevation: 2,
              //              borderRadius: BorderRadius.circular(16),
              //              child: Padding(
              //                padding: const EdgeInsets.all(14),
              //                child: Column(
              //                  crossAxisAlignment: CrossAxisAlignment.start,
              //                  children: [
              //                    Text(
              //                      savedSpot.title,
              //                      maxLines: 1,
              //                      overflow: TextOverflow.ellipsis,
              //                      style: const TextStyle(
              //                        fontSize: 18,
              //                        fontWeight: FontWeight.bold,
              //                      ),
              //                    ),
              //                    const SizedBox(height: 6),
              //                    Text(
              //                      savedSpot.description,
              //                      maxLines: 3,
              //                      overflow: TextOverflow.ellipsis,
              //                      style: const TextStyle(fontSize: 14, color: Colors.black54),
              //                    ),
              //                    const Spacer(),
              //                    Row(
              //                      children: [
              //                        const Icon(Icons.person_outline, size: 16, color: Colors.black),
              //                        const SizedBox(width: 4),
              //                        Expanded(
              //                          child: Text(
              //                            savedSpot.author,
              //                            maxLines: 1,
              //                            overflow: TextOverflow.ellipsis,
              //                            style: const TextStyle(fontSize: 12, color: Colors.black),
              //                          ),
              //                        ),
              //                      ],
              //                    ),
              //                    const SizedBox(height: 2),
              //                    Text(
              //                      savedSpot.date,
              //                      style: const TextStyle(fontSize: 12, color: Colors.black),
              //                    ),
              //                  ],
              //                ),
              //              ),
              //            ),
              //          );
              //        }
              //      )
              //    );
              //  }),

              ]
            ),
          ),
        ),
      ),
    );
  }
}

                      