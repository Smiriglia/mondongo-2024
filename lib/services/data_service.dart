import 'package:mondongo/models/consulta.dart';
import 'package:mondongo/models/empleado.dart';
import 'package:mondongo/models/dueno_supervisor.dart';
import 'package:mondongo/models/cliente.dart';
import 'package:mondongo/models/mesa.dart';
import 'package:mondongo/models/pedido.dart';
import 'package:mondongo/models/producto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mondongo/models/profile.dart';

enum TABLES {
  profiles,
  mesas,
  pedidos,
  productos,
  consultas;

  String get name {
    switch (this) {
      case TABLES.profiles:
        return 'profiles';
      case TABLES.mesas:
        return 'mesas';
      case TABLES.pedidos:
        return 'pedidos';
      case TABLES.productos:
        return 'productos';
      case TABLES.consultas:
        return 'consultas';
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

  Future<Mesa?> fetchMesaByNumero(int numeroMesa) async {
    try {
      final data = await _supabaseClient
          .from(TABLES.mesas.name)
          .select()
          .eq('numero', numeroMesa);
      if (data.isNotEmpty) {
        return Mesa.fromJson(data[0]);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
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

  Future<bool> dniExist(String dni) async {
    final response = await _supabaseClient
        .from(TABLES.profiles.name)
        .select()
        .eq('dni', dni);

    return response.isNotEmpty;
  }

  Future<bool> cuilExist(String cuil) async {
    final response = await _supabaseClient
        .from(TABLES.profiles.name)
        .select()
        .eq('cuil', cuil);

    return response.isNotEmpty;
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

  Future<void> addToWaitList(String qrData) async {
    final userId = _supabaseClient.auth.currentUser?.id;

    if (userId == null) {
      throw Exception('Usuario no autenticado');
    }

    final response = await _supabaseClient.from(TABLES.pedidos.name).insert({
      'clienteId': userId,
      'estado': 'espera',
      'fecha': DateTime.now().toIso8601String()
    });
  }

  // Fetch pedidos with 'espera' estado
  Future<List<Pedido>> fetchPendingPedidos() async {
    final data = await _supabaseClient
        .from(TABLES.pedidos.name)
        .select()
        .eq('estado', 'espera');

    return data.map<Pedido>((p) => Pedido.fromJson(p)).toList();
  }

  Future<void> assignMesaToPedido(String pedidoId, int mesaNumero) async {
    final existingPedido = await _supabaseClient
        .from(TABLES.pedidos.name)
        .select()
        .eq('mesaNumero', mesaNumero)
        .neq('estado', 'pagado')
        .neq('estado', 'cancelado')
        .maybeSingle();

    if (existingPedido != null) {
      throw Exception('La mesa ya está asignada a otro pedido.');
    }

    await _supabaseClient.from(TABLES.pedidos.name).update({
      'mesaNumero': mesaNumero,
      'estado': 'confirmacion',
    }).eq('id', pedidoId);
  }

  Future<List<Mesa>> fetchAvailableMesas() async {
    final allMesasData = await _supabaseClient.from(TABLES.mesas.name).select();
    final allMesas = allMesasData.map<Mesa>((m) => Mesa.fromJson(m)).toList();
    final assignedMesasData = await _supabaseClient
        .from(TABLES.pedidos.name)
        .select('mesaNumero')
        .neq('estado', 'pagado')
        .neq('estado', 'cancelado')
        .not('mesaNumero', 'is', null);
    final assignedMesaNumeros = assignedMesasData
        .where((p) => p['mesaNumero'] != null)
        .map<int>((p) => p['mesaNumero'] as int)
        .toSet();

    final availableMesas = allMesas
        .where((mesa) => !assignedMesaNumeros.contains(mesa.numero))
        .toList();

    return availableMesas;
  }

  Future<Pedido?> fetchPedidoByClienteId(String clienteId) async {
    final data = await _supabaseClient
        .from(TABLES.pedidos.name)
        .select()
        .eq('clienteId', clienteId)
        .order('fecha', ascending: false)
        .limit(1)
        .maybeSingle();

    if (data != null) {
      return Pedido.fromJson(data);
    }
    return null;
  }

  Future<List<Producto>> fetchProductos() async {
    try {
      final response = await _supabaseClient
          .from(TABLES.productos.name)
          .select()
          .order('createdAt', ascending: false);

      return response.map<Producto>((json) => Producto.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  Future<void> addProducto(Producto producto) async {
    final json = producto.toJson();
    json.remove('id');
    await _supabaseClient.from(TABLES.productos.name).insert(json);
  }

  Future<void> addConsulta(Consulta consulta) async {
    final json = consulta.toJson();
    json.remove('id');
    await _supabaseClient.from(TABLES.consultas.name).insert(json);
  }

  Future<List<Consulta>> fetchPendingConsultas() async {
    final data = await _supabaseClient
        .from(TABLES.consultas.name)
        .select()
        .eq('estado', 'pendiente');
    return data.map<Consulta>((c) => Consulta.fromJson(c)).toList();
  }

  Future<void> updateConsulta(Consulta consulta) async {
    await _supabaseClient
        .from(TABLES.consultas.name)
        .update(consulta.toJson())
        .eq('id', consulta.id);
  }

  Future<Pedido?> fetchCurrentPedido(String userId) async {
    final data = await _supabaseClient
        .from(TABLES.pedidos.name)
        .select()
        .eq('clienteId', userId)
        .order('fecha', ascending: false)
        .limit(1)
        .maybeSingle();

    if (data != null) {
      return Pedido.fromJson(data);
    }
    return null;
  }
}
