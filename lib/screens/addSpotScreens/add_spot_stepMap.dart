import 'package:flutter/material.dart';
import 'package:supermapper_app/widgets/map.dart';

class AddSpotStepMap extends StatelessWidget {
  const AddSpotStepMap({
    super.key,
    required this.initialLatitude,
    required this.initialLongitude,
    required this.onLocationChanged,
  });

  final double? initialLatitude;
  final double? initialLongitude;
  final void Function(double lat, double lng) onLocationChanged;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MapWidget(
          initialLat: initialLatitude,
          initialLng: initialLongitude,
          onCenterChanged: onLocationChanged,
        ),
        Center(
          child: Transform.translate(
            offset: const Offset(0, -14), // la pointe du pin tombe sur le centre
            child: const Text('📍', style: TextStyle(fontSize: 28)),
          ),
        ),
      ],
    );
  }
}