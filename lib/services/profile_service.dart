import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:supermapper/widgets/spot.dart';

class ProfileService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<String> getCurrentUsername() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) return '';

      final data = await _client
          .from('profiles')
          .select('username')
          .eq('id', user.id)
          .single();

      return data['username'] as String;
    } catch (e) {
      debugPrint('Error while fetching the username : $e');
      rethrow;
    }
  }

  Future<String> getCurrentUserId() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) return '';

      return user.id;

    } catch (e) {
      debugPrint('Error while fetching the user id : $e');
      rethrow;
    }
  }

  Future<String> getUsernameFromId(String userId) async {    
    try {
      final data = await _client
        .from('profiles')
        .select('username')
        .eq('id', userId)
        .single();

      return data['username'] as String;

    } catch (e) {
      debugPrint('Error while searching for username from Id : $e');
      rethrow;
    }
  }
  
  Future<List<Spot>> getCurrentUserSavedSpot() async {

    final userId = _client.auth.currentUser?.id;

    try {
      final data = await _client
        .from('profiles')
        .select('saved_spots')
        .eq('id', userId!)
        .single();

      final savedSpotsId = List<int>.from(data['saved_spots'] ?? []);
      
      if (savedSpotsId.isEmpty) return [];

      final spotsData = await _client
        .from('spots')
        .select()
        .inFilter('id', savedSpotsId);

      final savedSpots = spotsData
        .map<Spot>((json) => Spot.fromJson(json))
        .toList();

      return savedSpots;

    } catch (e) {
      debugPrint('Error while fetching the current user saved spot : $e');
      rethrow;
    }

  }

  Future<void> updateUsername(String username) async {
    try {
      final userId = _client.auth.currentUser?.id;
      
      if (userId == null) {
        throw Exception('No user connected.');
      }

      await _client
          .from('profiles')
          .update({'username': username})
          .eq('id', userId);

    } catch (e) {
      debugPrint('Error while updating username : $e');
      rethrow;
    }
  }

  Future<bool> isSpotSavedByCurrentUser(int spotId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('No user logged in. Impossible to save the spot.');
    }

    try {
      final data = await _client
        .from('profiles')
        .select('saved_spots')
        .eq('id', userId)
        .single();

      final savedSpots = List<int>.from(data['saved_spots'] ?? []);

      if (savedSpots.contains(spotId)) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("Error while searching if spot is saved by the current user : $e");
      rethrow;
    }
  }

  Future<void> saveSpotForCurrentUser(int spotId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('No user logged in. Impossible to save the spot.');
    }

    try {
      final data = await _client
        .from('profiles')
        .select('saved_spots')
        .eq('id', userId)
        .single();

      final savedSpots = List<int>.from(data['saved_spots'] ?? []);

      if (savedSpots.contains(spotId)) return;

      savedSpots.add(spotId);
      await _client
          .from('profiles')
          .update({'saved_spots': savedSpots})
          .eq('id', userId);

    } catch (e) {
      debugPrint("Error while trying to save spot for the current user : $e");
      rethrow;
    }

  }

  Future<void> unsaveSpotForCurrentUser(int spotId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('No user logged in. Impossible to unsave the spot.');
    }

    try {
      final data = await _client
        .from('profiles')
        .select('saved_spots')
        .eq('id', userId)
        .single();

      final savedSpots = List<int>.from(data['saved_spots'] ?? []);

      if (!savedSpots.contains(spotId)) return;

      final isRemoved = savedSpots.remove(spotId);
      
      if (isRemoved) {
        await _client
            .from('profiles')
            .update({'saved_spots': savedSpots})
            .eq('id', userId);
      }

    } catch (e) {
      debugPrint("Error while trying to save spot for the current user : $e");
      rethrow;
    }

  }


}