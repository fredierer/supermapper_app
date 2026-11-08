import 'package:flutter/material.dart';

enum ContributionCategory {
  transport('transport','Transport', '🚍', Color.fromARGB(255, 168, 112, 91)),
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
  
  const ContributionCategory(this.dbValue, this.label, this.emoji, this.color);

  factory ContributionCategory.fromString(String? value) {
    if (value == null) return ContributionCategory.other;
    return ContributionCategory.values.firstWhere(
      (cat) => cat.dbValue.toLowerCase() == value.toLowerCase(),
      orElse: () => ContributionCategory.other,
    );
  }
}
