import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:supermapper_app/configuration/feedback_category.dart'; 
import 'package:country_coder/country_coder.dart';

String getCountryCodeFromLatLng(double lat, double lng) {
  final countries = CountryCoder.instance;
  countries.load();
  return countries.iso1A2Code(lon: lng, lat: lat) ?? '';
}

class Spot {
  final int id;
  final String title;
  final FeedbackCategory category;
  final String description;
  final double lat;
  final double lng;
  final String countryCode;

  Spot({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.lat,
    required this.lng,
    required this.countryCode,
  });

  factory Spot.fromJson(Map<String, dynamic> json) {
    final lat = (json['lat'] as num?)?.toDouble() ?? 0.0;
    final lng = (json['lng'] as num?)?.toDouble() ?? 0.0;

    return Spot(
      id: json['id'],
      title: json['title'] ?? '',
      category: FeedbackCategory.fromString(json['category'] ?? ''),
      description: json['description'] ?? '', 
      lat : lat,
      lng: lng,
      countryCode: getCountryCodeFromLatLng(lat, lng),
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