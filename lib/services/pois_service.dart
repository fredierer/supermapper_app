import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

final _client = http.Client();

typedef Poi = ({int id, double lat, double lng, String category, String? name});

// Déclaré une seule fois : catégorie -> (clé du tag, valeur du tag)
const filters = {
  'toilets': (key: 'amenity', value: 'toilets', color: Colors.brown, icon: Icons.wc),
  'camp_site': (key: 'tourism', value: 'camp_site', color: Colors.green, icon: Icons.festival),
  'drinking_water': (key: 'amenity', value: 'drinking_water', color: Colors.blue, icon: Icons.water_drop),
  'railway_station': (key: 'railway', value: 'station', color: Colors.red, icon: Icons.train),
  'atm': (key: 'amenity', value: 'atm', color: Colors.teal, icon: Icons.atm),
  'fuel': (key: 'amenity', value: 'fuel', color: Colors.orange, icon: Icons.local_gas_station),
};

const _limitPerCategory = 10;

Future<List<Poi>> fetchPois({
  required double south,
  required double west,
  required double north,
  required double east,
}) async {
  final bbox = '($south,$west,$north,$east)';

  // Pour chaque catégorie : un set nommé, puis un "out" avec sa limite
  final sets = filters.entries
      .map((f) => 'nwr["${f.value.key}"="${f.value.value}"]$bbox->.${f.key};')
      .join('\n');
  final outs = filters.keys
      .map((c) => '.$c out tags center qt $_limitPerCategory;')
      .join('\n');

  final query = '''
[out:json][timeout:50];
$sets
$outs
''';

  final response = await _client
      .post(
        Uri.parse('https://overpass-api.de/api/interpreter'),
        headers: {
          'User-Agent': 'supermapper_app/1.0 (contact@supermapper.app)',
          'Accept': 'application/json',
        },
        body: {'data': query},
      )
      .timeout(const Duration(seconds: 60));

  if (response.statusCode != 200) {
    throw Exception('Overpass error ${response.statusCode}: ${response.body}');
  }

  final elements =
      jsonDecode(utf8.decode(response.bodyBytes))['elements'] as List;

  final pois = <Poi>[];
  for (final e in elements) {
    final lat = (e['lat'] ?? e['center']?['lat']) as num?;
    final lng = (e['lon'] ?? e['center']?['lon']) as num?;
    if (lat == null || lng == null) continue;

    final tags = (e['tags'] ?? {}) as Map;

    // Catégorie = la première entrée de `filters` dont le tag correspond
    String category = 'unknown';
    for (final f in filters.entries) {
      if (tags[f.value.key] == f.value.value) {
        category = f.key;
        break;
      }
    }

    pois.add((
      id: e['id'] as int,
      lat: lat.toDouble(),
      lng: lng.toDouble(),
      category: category,
      name: tags['name'] as String?,
    ));
  }

  return pois;
}