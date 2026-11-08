import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:supermapper_app/configuration/contribution_category.dart'; 
import 'package:country_coder/country_coder.dart';

String getCountryCodeFromLatLng(double lat, double lng) {
  final countries = CountryCoder.instance;
  countries.load();
  return countries.iso1A2Code(lon: lng, lat: lat) ?? '';
}

class Spot {
  final int id;
  final String title;
  final ContributionCategory category;
  final String description;
  final double lat;
  final double lng;
  final String countryCode;
  final DateTime creationDate;

  Spot({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.lat,
    required this.lng,
    required this.countryCode,
    required this.creationDate,
  });

  factory Spot.fromJson(Map<String, dynamic> json) {
    final lat = (json['lat'] as num?)?.toDouble() ?? 0.0;
    final lng = (json['lng'] as num?)?.toDouble() ?? 0.0;

    return Spot(
      id: json['id'],
      title: json['title'] ?? '',
      category: ContributionCategory.fromString(json['category'] ?? ''),
      description: json['description'] ?? '', 
      lat : lat,
      lng: lng,
      countryCode: getCountryCodeFromLatLng(lat, lng),
      creationDate: DateTime.parse(json['created_at'] as String),
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
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color:category.color, width: 3.0),
          ),
          child: Text(
            category.emoji,
            style: const TextStyle(fontSize: 18, height: 1.0),
          ),
        ),
      ),
    );
  }
}