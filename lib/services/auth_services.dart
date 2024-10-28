import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<User?> signInWithGoogle() async {
    try {
      final response = await _supabaseClient.auth.signInWithOAuth(
        OAuthProvider.google
      );
      return _supabaseClient.auth.currentUser;
    } catch (e) {
      print('Error signing in with Google: $e');
    }
    return null;
  }

  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      final response = await _supabaseClient.auth.signUp(email: email, password: password);
      if (response.user != null) {
        return response.user;
      }
    } catch (e) {
      print('Error signing up with email: $e');
    }
    return null;
  }

  // Sign In with email and password
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(email: email, password: password);
      if (response.user != null) {
        return response.user;
      }
    } catch (e) {
      print('Error signing in with email: $e');
    }
    return null;
  }

  Future<void> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  User? getUser() {
    return _supabaseClient.auth.currentUser;
  }
}
