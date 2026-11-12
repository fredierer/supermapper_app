import 'package:flutter/material.dart';

class Poi {
  final String id;
  final String name;
  final String category;
  final double lat;
  final double lng;

  Poi({
    required this.id,
    required this.name,
    required this.category,
    required this.lat,
    required this.lng,
  });

  // Rémy 11/11/2026
  // About categories :
  // On Supabase, each category is stored as a number (int) to save space.
  // id : (name, icon, color)
static const Map<int, (String, IconData, Color, int, double)> _categoryNames = {    
    1:  ('guest_house',    Icons.house,             Colors.indigo,      100,  8.0,),
    2:  ('campground',     Icons.cabin,             Colors.green,       100,  8.0,),
    3:  ('hotel',          Icons.hotel,             Colors.indigo,      100,  8.0,),
    4:  ('restaurant',     Icons.restaurant,        Colors.deepOrange,  100,  8.0,),
    5:  ('toilets',        Icons.wc,                Colors.blueGrey,    100,  8.0,),
    6:  ('supermarket',    Icons.shopping_cart,     Colors.teal,        100,  8.0,),
    7:  ('convenience',    Icons.storefront,        Colors.teal,        100,  8.0,),
    8:  ('drinking_water', Icons.water_drop,        Colors.lightBlue,   100,  8.0,),
    9:  ('hospital',       Icons.local_hospital,    Colors.red,         100,  8.0,),
    10: ('viewpoint',      Icons.visibility,        Colors.purple,      100,  8.0,),
    11: ('peak',           Icons.terrain,           Colors.brown,       100,  8.0,),
    12: ('cafe',           Icons.local_cafe,        Colors.brown,       100,  8.0,),
    13: ('pharmacy',       Icons.local_pharmacy,    Colors.green,       100,  8.0,),
    14: ('fuel',           Icons.local_gas_station, Colors.orange,      100,  8.0,),
    15: ('embassy',        Icons.flag,              Colors.blue,        100,  8.0,),
    16: ('police',         Icons.local_police,      Colors.blue,        100,  8.0,),
    17: ('townhall',       Icons.account_balance,   Colors.blueGrey,    100,  8.0,),
    18: ('post_office',    Icons.local_post_office, Colors.amber,       100,  8.0,),
  };

  // Valeurs utilisées si la catégorie est inconnue
  static const IconData _defaultIcon = Icons.place;
  static const Color _defaultColor = Colors.grey;

  // Retrouve l'entrée à partir du nom de catégorie stocké dans le Poi
  (String, IconData, Color, int, double)? get _caracteristics {
    for (final e in _categoryNames.values) {
      if (e.$1 == category) return e;
    }
    return null;
  }

  IconData get icon => _caracteristics?.$2 ?? _defaultIcon;
  Color get color => _caracteristics?.$3 ?? _defaultColor;
  int get priority => _caracteristics?.$4 ?? 50;
  double get minZoom => _caracteristics?.$5 ?? 11.0;


  static const double _coordFactor = 10000000; // 10^7 → In Supabase, lat & lng are stored as int instead of float

  factory Poi.fromJson(Map<String, dynamic> json) {
    final int categoryId = (json['category'] as num).toInt();

    return Poi(
      id: (json['id'] as num).toInt().toString(),
      name: (json['name'] as String?) ?? 'no name',
      category: _categoryNames[categoryId]?.$1 ?? 'unknown',
      lat: (json['lat'] as num) / _coordFactor,
      lng: (json['lng'] as num) / _coordFactor,
    );
  }
}