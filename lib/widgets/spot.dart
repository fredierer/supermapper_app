import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:supermapper_app/configuration/spot_category.dart';
import 'package:supermapper_app/theme.dart';

class Spot {
  final int id;
  final String title;
  final SpotCategory category;
  final String description;
  final double lat;
  final double lng;

  Spot({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.lat,
    required this.lng,
  });

  factory Spot.fromJson(Map<String, dynamic> json) {
    return Spot(
      id: json['id'],
      title: json['title'] ?? '',
      category: SpotCategory.fromString(json['category'] ?? ''),
      description: json['description'] ?? '', 
      lat : (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
    );
  }

  LatLng get location => LatLng(lat, lng);

  Marker toMarker({VoidCallback? onTap}) {
    return Marker(
      point: location,
      width: 40,
      height: 40,
      child: GestureDetector(
        onTap: onTap,
        child: Icon(
          category.icon,  // Récupéré automatiquement depuis l'enum
          color: category.color, // Récupéré automatiquement depuis l'enum
          size: 38,
        ),
      ),
    );
  }
}