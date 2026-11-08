import 'package:flutter/material.dart';

enum ContributionCategory {
  transport('transport','Transport', '🚍', Color.fromARGB(255, 173, 236, 72)),
  camping('camping','Camping',  '⛱', Color.fromARGB(255, 240, 231, 58)),
  borderCrossing('border_crossing','Border Crossing', '🌐',Color.fromARGB(255, 187, 127, 247)),
  restaurant('restaurant','Restaurant',  '🌮', Color.fromARGB(255, 240, 174, 107)),
  accomodation('accomodation','Accomodation', '🏡', Color.fromARGB(255, 248, 119, 173)),
  administration('administration','Administration', '👮', Color.fromARGB(255, 122, 191, 240)),
  other('other','Others', '✨', Color.fromARGB(255, 255, 252, 49));

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
