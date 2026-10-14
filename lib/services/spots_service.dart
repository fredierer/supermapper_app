import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supermapper_app/configuration/spot_category.dart';
import 'package:supermapper_app/widgets/spot.dart';
import 'package:flutter/foundation.dart';

class SpotService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Spot>> getSpots() async {
    try {
      final response = await _client.from('spots').select();

      final List<Spot> spots = (response as List)
          .map((json) => Spot.fromJson(json))
          .toList();

      print("POINT FETCHES : ");
      print(spots);

      return spots;
    } catch (e) {
      debugPrint('Error while fetching the spots : $e');
      rethrow;
    }
  }

  Future<void> addSpot ({
    required String title,
    required String description,
    required FeedbackCategory category,
    required double latitude,
    required double longitude,
  }) async {
    try {
      await _client.from('spots').insert({
        'title': title,
        'description': description,
        'category': category.dbValue,
        'lat': latitude,
        'lng': longitude,
      });

    } catch(e) {
      print('Error while adding a spot : $e');
      rethrow;
    }

  }
}