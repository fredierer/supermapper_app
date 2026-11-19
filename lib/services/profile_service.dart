import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

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
}