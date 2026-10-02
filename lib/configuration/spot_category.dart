import 'package:flutter/material.dart';

enum SpotCategory {
  transport('transport','Transport', '🚗', Color.fromARGB(255, 168, 112, 91)),
  camping('camping','Camping',  '⛱', Colors.lightGreen),
  borderCrossing('border_crossing','Border Crossing', '🌐', Colors.deepPurpleAccent),
  restaurant('restaurant','Restaurant',  '🌮', Colors.redAccent),
  accomodation('accomodation','Accomodation', '🏡', Color.fromARGB(255, 185, 73, 180)),
  administration('administration','Administration', '👮', Colors.blueAccent),
  other('other','Others', '✨', Color.fromARGB(255, 224, 236, 108));

  final String dbValue;
  final String label;
  final String emoji;
  final Color color;
  
  const SpotCategory(this.dbValue, this.label, this.emoji, this.color);

  factory SpotCategory.fromString(String? value) {
    if (value == null) return SpotCategory.other;
    return SpotCategory.values.firstWhere(
      (cat) => cat.dbValue.toLowerCase() == value.toLowerCase(),
      orElse: () => SpotCategory.other,
    );
  }
}
