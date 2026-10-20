
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class UserPositionButton extends StatelessWidget{
  final void Function(double lat, double lng, double zoom) onPositionFetched;
  
  UserPositionButton({
    super.key,
    required this.onPositionFetched,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2, 
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
          if (!serviceEnabled) return;

          LocationPermission permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
            if (permission == LocationPermission.denied) return;
          }

          Position position = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
          );

          onPositionFetched(position.latitude, position.longitude, 15.0);
        },
        child: Container(
          padding: const EdgeInsets.all(10), // Espace autour de l'icône
          child: const Icon(
            Icons.my_location, // Icône représentant la position GPS
            color: Colors.blue,
            size: 24.0,
          ),
        ),
      ),
    );   
  }

}
