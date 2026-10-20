import 'dart:convert';
import 'package:http/http.dart' as http;

const _placeTypes = {'country', 'state', 'county', 'city', 'district', 'locality'};

class PlaceResult {
  final String name;
  final String subtitle;
  final String type;
  final double lat;
  final double lng;
  final double zoom;

  PlaceResult({
    required this.name,
    required this.subtitle,
    required this.type,
    required this.lat,
    required this.lng,
    this.zoom = 14.0,
  });

  factory PlaceResult.fromFeature(Map<String, dynamic> feature) {

    final props = feature['properties'] as Map<String, dynamic>;
    final coords = feature['geometry']['coordinates'] as List; // [lng, lat]
    final name = (props['name'] ?? '') as String;
    final type = props['type'] ?? ''; 
    final zoom = switch (type) {
      'country' => 5.0,
      'state' => 8.0,
      'county' => 8.0,
      'city' => 8.0,
      'district' => 8.0,
      'locality' => 8.0,
      _ => 8.0,
    };
    final subtitle = [props['state'], props['country']]
      .whereType<String>()
      .where((part) => part != name)
      .join(', ');

    return PlaceResult(
      name: name,
      subtitle: subtitle,
      type: type,
      lat: (coords[1] as num).toDouble(),
      lng: (coords[0] as num).toDouble(),
      zoom : zoom,
    );
  }
}

class PlaceService {

  Future<List<PlaceResult>> search(String query, {int maxResults = 10}) async {

    final text = query.trim();
    
    if(text.length < 2) return [];

    final response = await http.get(
      Uri.https('photon.komoot.io', '/api/', {
        'q' : text,
        'limit' : '10',
        'lang' : 'en',
      }),
      headers: {'User-Agent': 'supermapper_app'},
    );


    if (response.statusCode != 200) {
      throw Exception('Place search failed (${response.statusCode})');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    return (data['features'] as List)
      .map((f) => PlaceResult.fromFeature(f as Map<String, dynamic>))
      .where((p) => _placeTypes.contains(p.type) && p.name.isNotEmpty)
      .take(maxResults)
      .toList();
  }
}