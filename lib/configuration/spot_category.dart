import 'package:flutter/material.dart';

enum SpotCategory {
  transport('transport','Transport',  Icons.airport_shuttle_outlined, Colors.orange),
  camping('camping','Camping',  Icons.rv_hookup, Colors.blue),
  borderCrossing('border_crossing','Border Crossing',  Icons.assignment_ind_outlined, Colors.orange),
  restaurant('restaurant','Restaurant',  Icons.restaurant, Colors.orange),
  accomodation('accomodation','Accomodation',  Icons.house_outlined, Colors.orange),
  administration('administration','Administration',  Icons.local_police_outlined, Colors.orange),
  other('other','Others',  Icons.alt_route_outlined, Colors.orange);

  final String dbValue;
  final String label;
  final IconData icon;
  final Color color;
  
  const SpotCategory(this.dbValue, this.label, this.icon, this.color);

  factory SpotCategory.fromString(String? value) {
    if (value == null) return SpotCategory.other;
    return SpotCategory.values.firstWhere(
      (cat) => cat.dbValue.toLowerCase() == value.toLowerCase(),
      orElse: () => SpotCategory.other,
    );
  }
}
