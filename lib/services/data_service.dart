import 'package:mondongo/models/empleado.dart';
import 'package:mondongo/models/dueno_supervisor.dart';
import 'package:mondongo/models/cliente.dart';
import 'package:mondongo/models/mesa.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mondongo/models/profile.dart'; // Asegúrate de tener un modelo Profile

enum TABLES {
  profiles,
  mesas;

  String get name {
    switch (this) {
      case TABLES.profiles:
        return 'profiles';
      case TABLES.mesas:
        return 'mesas';
    }
  }
}

class DataService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  // --- Métodos para "profiles" ---
  // Fetch all profiles
  Future<List<Profile>> fetchProfiles() async {
    final data = await _supabaseClient.from(TABLES.profiles.name).select();
    return data.map<Profile>((p) => Profile.fromJson(p)).toList();
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

  // --- Métodos para "clientes" ---

  // Obtener clientes pendientes
  Future<List<Cliente>> fetchPendingClientes() async {
    final data = await _supabaseClient
        .from(TABLES.profiles.name)
        .select()
        .eq('rol', 'cliente')
        .eq('estado', 'pendiente');

    return (data as List)
        .map<Cliente>((cliente) => Cliente.fromJson(cliente))
        .toList();
  }

  // Actualizar estado del cliente
  Future<void> updateClienteEstado(String clienteId, String nuevoEstado) async {
    await _supabaseClient
        .from(TABLES.profiles.name)
        .update({'estado': nuevoEstado})
        .eq('id', clienteId)
        .eq('rol', 'cliente');
  }

  // --- Métodos para "empleados" ---
  Future<void> addEmpleado(Empleado empleado) async {
    await _supabaseClient.from(TABLES.profiles.name).insert(empleado.toJson());
  }

  // --- Métodos para "dueños/supervisores" ---
  Future<void> addDuenoSupervisor(DuenoSupervisor duenoSupervisor) async {
    await _supabaseClient
        .from(TABLES.profiles.name)
        .insert(duenoSupervisor.toJson());
  }

  
  Future<void> addCliente(Cliente cliente) async {
    await _supabaseClient.from(TABLES.profiles.name).insert(cliente.toJson());
  }

  // --- Métodos para "mesas" ---
  Future<void> addMesa(Mesa mesa) async {
    await _supabaseClient.from(TABLES.mesas.name).insert(mesa.toJson());
  }
}
