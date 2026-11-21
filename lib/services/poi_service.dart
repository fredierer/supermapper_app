import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supermapper/widgets/poi.dart';

class PoiService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Poi>> getPoi(double south, double west, double north, double east) async {

    try {
      final List<dynamic> response;

      response = await _client
          .from('pois')
          .select();

      final List<Poi> pois = response.map((poi) => Poi.fromJson(poi))
        .toList();

      return pois;
    
    } catch (e) {
    
      return [];

    }

  }
}