import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

const _placeTypes = {'country', 'state', 'county', 'city', 'district', 'locality'};

class PlaceResult {
  final String name;
  final String subtitle;
  final String type;
  final double lat;
  final double lng;
  final double zoom;
  final String osmType;
  final int? osmId;

  PlaceResult({
    required this.name,
    required this.subtitle,
    required this.type,
    required this.lat,
    required this.lng,
    this.zoom = 14.0,
    required this.osmType,
    required this.osmId,
  });

  double get boundaryTolerance => switch (type) {
      'country' => 0.02,
      'state' => 0.01,
      'county' => 0.005,
      _ => 0.001,
    };

  factory PlaceResult.fromFeature(Map<String, dynamic> feature) {

    final props = feature['properties'] as Map<String, dynamic>;
    final coords = feature['geometry']['coordinates'] as List; // [lng, lat]
    final name = (props['name'] ?? '') as String;
    final type = (props['type'] ?? '') as String;
    final zoom = switch (type) {
      'country' => 5.0,
      'state' => 5.0,
      'county' => 8.0,
      'city' => 10.0,
      'district' => 8.0,
      'locality' => 8.0,
      _ => 8.0,
    };
    final subtitle = [props['state'], props['country']]
      .whereType<String>()
      .where((part) => part != name)
      .join(', ');
    final osmType = (props['osm_type'] ?? '') as String;
    final osmId = (props['osm_id'] as num?)?.toInt();

    return PlaceResult(
      name: name,
      subtitle: subtitle,
      type: type,
      lat: (coords[1] as num).toDouble(),
      lng: (coords[0] as num).toDouble(),
      zoom : zoom,
      osmType: osmType,
      osmId: osmId, 
    );
  }
}

class BoundaryResult{
  final List<LatLng> outer;
  final List<List<LatLng>> holes;

  BoundaryResult(
    this.outer,
    this.holes
  );
}
class PlaceService {

  Future<List<PlaceResult>> searchPlaces(String query, {int maxResults = 10}) async {

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
  
  final _boundaryCache = <String, List<BoundaryResult>>{};

  Future<List<BoundaryResult>> fetchBoundary(PlaceResult place) async {

    final id = place.osmId;
    if (id == null || place.osmType.isEmpty) return [];
    
    final key = '${place.osmType}$id'; //Give key to this osmId

    final cached = _boundaryCache[key]; // verify if this osmId is already in cache
    if (cached != null) {
      return cached; //if already in cache, we return the cached boundaries
    } 

    final response = await http.get(
      Uri.https('nominatim.openstreetmap.org', '/lookup', {
        'osm_ids': key,                                   // ex. R7444
        'format': 'jsonv2',
        'polygon_geojson': '1',
        'polygon_threshold': '${place.boundaryTolerance}',
      }),
      headers: {'User-Agent': 'supermapper_app/1.0'},
    );

    if (response.statusCode != 200) {
      throw Exception('Boundary lookup failed (${response.statusCode})');
    }

    final data = jsonDecode(response.body) as List;
    print(data);
    if (data.isEmpty) return [];

    final geometry = (data.first as Map<String, dynamic>)['geojson'] as Map<String, dynamic>?; //get geormetry
    final shapes = geometry == null ? <BoundaryResult>[] : _parseGeometry(geometry);

    _boundaryCache[key] = shapes; //store shapes in cache

    return shapes;

  }

  List<BoundaryResult> _parseGeometry(Map<String, dynamic> geometry) {
    final coords = geometry['coordinates'] as List;

    List<LatLng> ring(List points) => points
        .map((p) => LatLng((p[1] as num).toDouble(), (p[0] as num).toDouble()))
        .toList();

    BoundaryResult polygon(List rings) => BoundaryResult(
          ring(rings.first as List),
          rings.skip(1).map((r) => ring(r as List)).toList(),
        );

    return switch (geometry['type']) {
      'Polygon' => [polygon(coords)],
      'MultiPolygon' => coords.map((p) => polygon(p as List)).toList(),
      _ => [],  
    };
  }
}