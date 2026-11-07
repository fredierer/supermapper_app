import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supermapper_app/configuration/feedback_category.dart';
import 'package:supermapper_app/widgets/spot.dart';
import 'package:flutter/foundation.dart';

class SpotService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Spot>> getSpots({int? max}) async {
  try {
    final List<dynamic> response;

    if (max != null) {
      response = await _client
          .from('spots')
          .select()
          .order('created_at', ascending: false)
          .limit(max);
    } else {
      response = await _client
          .from('spots')
          .select()
          .order('created_at', ascending: false);
    }

    final List<Spot> spots = response
        .map((json) => Spot.fromJson(json))
        .toList();

    return spots;
  } catch (e) {
    debugPrint('Error while fetching the spots : $e');
    rethrow;
  }
}

  Future<List<Spot>> getUserSpots() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _client
        .from('spots')
        .select()
        .eq('creator_id', userId)
        .order('created_at', ascending: false);

    return response.map((json) => Spot.fromJson(json)).toList();
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
      debugPrint('Error while adding a spot : $e');
      rethrow;
    }

  }
}