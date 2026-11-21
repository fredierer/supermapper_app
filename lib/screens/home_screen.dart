import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:supermapper/services/profile_service.dart';
import 'package:supermapper/services/spots_service.dart';
import 'package:supermapper/theme.dart';
import 'package:supermapper/widgets/spot.dart';

const double _borderWidth = 3.0;
final _profileService = ProfileService();

class HomeScreen extends StatefulWidget {
  final VoidCallback onProfileButtonPressed;
  final VoidCallback onMapCardPressed;
  final void Function(Spot spot) onSpotCardPressed;

  const HomeScreen({
    super.key,
    required this.onProfileButtonPressed,
    required this.onMapCardPressed,
    required this.onSpotCardPressed,
  });

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final _spotService = SpotService();
  final _profileService = ProfileService();
  late Future<List<Spot>> _recentSpots;
  late Future<String> _username;

  static final _dateFormat = DateFormat('dd/MM/yyyy HH:mm');

  @override
  void initState() {
    super.initState();
    _recentSpots = _spotService.getSpots(max: 20);
    _username = _profileService.getCurrentUsername();
    reload();
  }

  void reload() {
    setState(() {
      _username = _profileService.getCurrentUsername();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      extendBody: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(_username),

              _buildRecentSpots(),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Future<String> username) {
    return FutureBuilder<String>(
      future: username,
      builder: (context, snapshot) {
        
        return Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal : 15),  
          child : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                'Supermapper',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.spaceMono(
                  fontSize: 35,
                  letterSpacing: 4.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              
              SizedBox(height: 15,),

              Row(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: AppColors.amber,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: _borderWidth),
                    ),
                    child: const Icon(Icons.person, size: 32, color: Colors.black),
                  ),
                  
                  SizedBox(width: 20,),

                  FutureBuilder<String>(
                    future: username,
                    builder: (context, snapshot) {
                      String title = 'Hi !';
                      if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                        title = 'Hi ${snapshot.data!} !';
                      }
                      
                      return Flexible(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.spaceMono(
                            fontSize: 25,
                            letterSpacing:1.5,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        )
                      );
                    }
                  )
                ],
              ),
          
                
              SizedBox(height: 15,),

            ]
          ),
        );
      },
    );
  }

  Widget _buildRecentSpots() {
    return Expanded(
      child: FutureBuilder<List<Spot>>(
        future: _recentSpots,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              height: 150,
              child: Center(
                child: SizedBox(
                  height: 32,
                  width: 32,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.black,
                  ),
                ),
              ),
            );
          }

          if (snapshot.hasError) {
            return SizedBox(
              height: 150,
              child: Center(child: Text('Error : ${snapshot.error}')),
            );
          }

          final spots = snapshot.data ?? [];

          if (spots.isEmpty) {
            return const SizedBox(
              height: 150,
              child: Center(child: Text('No contribution for now 😢')),
            );
          }

          return ListView.separated(
              scrollDirection: Axis.vertical,
              clipBehavior: Clip.hardEdge,
              itemCount: spots.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _SpotCard(
                spot: spots[index],
                dateFormat: _dateFormat,
                onButtonPressed: () => widget.onSpotCardPressed(spots[index]),
              ),
          );
        },
      )
    ,); 
  }
}

class _SpotCard extends StatelessWidget {
  const _SpotCard({
    required this.spot, 
    required this.dateFormat,
    required this.onButtonPressed,
  });

  final Spot spot;
  final DateFormat dateFormat;
  final VoidCallback onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black, width: _borderWidth),
      ),
      child : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                spot.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Spacer(),
              Text(
                dateFormat.format(spot.creationDate),
                style: const TextStyle(fontSize: 11, color: Colors.black54),
              ),
            ],
          ),
          SizedBox(height: 5,),
          Expanded(
            child: Text(
              spot.description,
              textAlign: TextAlign.start,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ),        
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 5,),
                  FutureBuilder<String>(
                    future: _profileService.getUsernameFromId(spot.creatorId),
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.data ?? '...',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      );
                    },
                  ),

                ],
              ),
              Spacer(),
              Padding(
                padding: EdgeInsetsGeometry.fromLTRB(0,0,0,0),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 15,
                    color: Color.fromARGB(255, 194, 194, 194),
                  ),
                  onPressed: onButtonPressed,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    fixedSize: const Size(32, 32),
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    side: const BorderSide(
                      color: Color.fromARGB(255, 194, 194, 194),
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

            ],
          )
        ],
      )
    );
  }
}
