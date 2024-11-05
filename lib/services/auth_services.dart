import 'dart:ffi';

import 'package:mondongo/models/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logging/logging.dart';

class AuthService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  Profile? profile;
  final _logger = Logger('AuthService');

  Future<User?> signInWithGoogle() async {
    try {
      await _supabaseClient.auth.signInWithOAuth(OAuthProvider.google);
      return _supabaseClient.auth.currentUser;
    } catch (e) {
      _logger.severe('Error signing in with Google: $e');
      return null;
    }
  }

  Future<User?> signInAnonymously() async {
    try {
      await _supabaseClient.auth.signInAnonymously();
      return _supabaseClient.auth.currentUser;
    } catch (e) {
      _logger.severe('Error signing in Anonymously: $e');
      return null;
    }
  }

  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      final response =
          await _supabaseClient.auth.signUp(email: email, password: password);
      return response.user;
    } catch (e) {
      _logger.severe('Error signing up with email: $e');
      return null;
    }
  }

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final response = await _supabaseClient.auth
          .signInWithPassword(email: email, password: password);
      return response.user;
    } catch (e) {
      _logger.severe('Error signing in with email: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
      profile = null;
    } catch (e) {
      _logger.severe('Error signing out: $e');
    }
  }

  User? getUser() {
    return _supabaseClient.auth.currentUser;
  }

  Profile? getProfile() {

  }

  Future<void> deleteUser(String userId) async {
    try {
      await _supabaseClient.auth.admin.deleteUser(userId);
    } catch (e) {
      _logger.severe('Error deleting user: $e');
    }
  }
}
