import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mondongo/models/profile.dart'; // Asegúrate de tener un modelo Profile

enum TABLES {
  profiles;

  String get name {
    switch (this) {
      case TABLES.profiles:
        return 'profiles';
    }
  }
}

class DataService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  // Fetch all profiles
  Future<List<Profile>> fetchProfiles() async {
    final data = await _supabaseClient.from(TABLES.profiles.name).select();
    return data.map((p) => Profile.fromJson(p)).toList();
  }

  // Add a new profile
  Future<void> addProfile(Profile profile) async {
    await _supabaseClient.from(TABLES.profiles.name).insert(profile.toJson());
  }

  // Update an existing profile
  Future<void> updateProfile(Profile profile) async {
    await _supabaseClient
        .from(TABLES.profiles.name)
        .update(profile.toJson())
        .eq('id', profile.id);
  }

  // Delete a profile by ID
  Future<void> deleteProfile(String id) async {
    await _supabaseClient.from(TABLES.profiles.name).delete().eq('id', id);
  }

  // Fetch a single profile by ID
  Future<Profile?> fetchProfileById(String id) async {
    final data = await _supabaseClient
        .from(TABLES.profiles.name)
        .select()
        .eq('id', id)
        .single();
    if (data != null) {
      return Profile.fromJson(data);
    }
    return null;
  }
}
