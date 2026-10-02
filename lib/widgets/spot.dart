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
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: category.color,
              width: 2.0, // Adjust border thickness as needed
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Transform.translate(
            offset: const Offset(0, 0), // Negative Y moves it up (adjust -1 to -3 as needed)
            child: Text(
              category.emoji,
              style: const TextStyle(
                fontSize: 20,
                height: 1.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}