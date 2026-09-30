import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supermapper_app/widgets/spot.dart';
import 'package:flutter/foundation.dart';

class SpotService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Spot>> getSpots() async {
    try {
      final response = await _client.from('spots').select();

      print("Resposne : ");
      print(response);

      final List<Spot> spots = (response as List)
          .map((json) => Spot.fromJson(json))
          .toList();

      return spots;
    } catch (e) {
      debugPrint('Erreur lors du fetch des spots : $e');
      rethrow;
    }
  }
}