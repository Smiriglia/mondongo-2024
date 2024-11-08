import 'package:mondongo/models/consulta.dart';
import 'package:mondongo/models/detalle_pedido.dart';
import 'package:mondongo/models/detalle_pedido_producto.dart';
import 'package:mondongo/models/empleado.dart';
import 'package:mondongo/models/dueno_supervisor.dart';
import 'package:mondongo/models/cliente.dart';
import 'package:mondongo/models/mesa.dart';
import 'package:mondongo/models/pedido.dart';
import 'package:mondongo/models/pedido_detalle_pedido_producto.dart';
import 'package:mondongo/models/producto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mondongo/models/profile.dart';
import 'package:mondongo/models/encuesta.dart';

enum TABLES {
  profiles,
  mesas,
  pedidos,
  productos,
  consultas,
  detallePedido,
  encuestas;

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
      case TABLES.detallePedido:
        return 'detallePedido';
      case TABLES.encuestas:
        return 'encuestas';
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

  Future<void> updatePedido(Pedido pedido) async {
    await _supabaseClient
        .from(TABLES.pedidos.name)
        .update(pedido.toJson())
        .eq('id', pedido.id);
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

  Future<void> addDetallePedido(DetallePedido detallePedido) async {
    final json = detallePedido.toJson();
    json.remove('id');
    await _supabaseClient.from(TABLES.detallePedido.name).insert(json);
  }

  /// Fetch all pedidos with estado 'orden'
  Future<List<Pedido>> fetchPedidosEnOrden() async {
    final data = await _supabaseClient
        .from(TABLES.pedidos.name)
        .select()
        .eq('estado', 'orden');

    return data.map<Pedido>((p) => Pedido.fromJson(p)).toList();
  }

  /// Update the estado of a pedido by its ID
  Future<void> actualizarEstadoPedido(
      String pedidoId, String nuevoEstado) async {
    await _supabaseClient
        .from(TABLES.pedidos.name)
        .update({'estado': nuevoEstado}).eq('id', pedidoId);
  }

  Future<void> actualizarEstadoDetallePedidosPedidoId(
      String pedidoId, String estado) async {
    await _supabaseClient
        .from(TABLES.detallePedido.name)
        .update({'estado': estado}).eq('pedidoId', pedidoId);
  }

  Stream<List<DetallePedido>> listenToDetallePedidos(String pedidoId) {
    return _supabaseClient
        .from(TABLES.detallePedido.name)
        .stream(primaryKey: ['id'])
        .eq('pedidoId', pedidoId)
        .order('fechaInicio')
        .map((data) => data
            .map<DetallePedido>((json) => DetallePedido.fromJson(json))
            .toList());
  }

  Stream<Pedido> listenToPedidoById(String pedidoId) {
    return _supabaseClient
        .from(TABLES.pedidos.name)
        .stream(primaryKey: ['id'])
        .eq('id', pedidoId)
        .map((data) {
          if (data.isEmpty) {
            throw Exception('Pedido no encontrado');
          }
          return Pedido.fromJson(data.first);
        });
  }

  /// Agrega una nueva encuesta a la base de datos.
  Future<void> addEncuesta(Encuesta encuesta) async {
    final json = encuesta.toJson();
    json.remove('id'); // Supabase generará el ID automáticamente
    await _supabaseClient.from('encuestas').insert(json);
  }

  /// Obtiene todas las encuestas asociadas a una mesa específica.
  Future<List<Encuesta>> fetchEncuestasByMesa(int mesaNumero) async {
    final data = await _supabaseClient
        .from('encuestas')
        .select()
        .eq('mesa_numero', mesaNumero)
        .order('creado_en', ascending: true);

    return (data as List)
        .map<Encuesta>((encuesta) => Encuesta.fromJson(encuesta))
        .toList();
  }

  /// Obtiene todas las encuestas.
  Future<List<Encuesta>> fetchAllEncuestas() async {
    final data = await _supabaseClient
        .from('encuestas')
        .select()
        .order('creado_en', ascending: true);

    return (data as List)
        .map<Encuesta>((encuesta) => Encuesta.fromJson(encuesta))
        .toList();
  }

  Future<List<DetallePedidoProducto>> getDetallePedidosPorEstadoYSector(
      List<String> estados, String sector) async {
    final response = await _supabaseClient.rpc(
      'get_detalle_pedidos_by_estado_sector',
      params: {
        'estados': estados,
        'sector_param': sector,
      },
    );

    if (response == null) {
      return [];
    }

    return (response as List<dynamic>)
        .map((json) =>
            DetallePedidoProducto.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Stream<void> listenToDetallePedidoChanges() {
    return _supabaseClient
        .from(TABLES.detallePedido.name)
        .stream(primaryKey: ['id']);
  }

  Future<void> actualizarEstadoDetallePedido(
      String detalleId, String estado) async {
    await _supabaseClient
        .from(TABLES.detallePedido.name)
        .update({'estado': estado}).eq('id', detalleId);
  }

  Future<List<PedidoDetallePedidoProducto>> getPedidosWithDetallesByEstado(
      List<String> estados) async {
    final response = await _supabaseClient.rpc(
      'get_pedidos_with_detalles_by_estado',
      params: {'estados': estados},
    );

    if (response == null) {
      return [];
    }

    return (response as List<dynamic>)
        .map((json) =>
            PedidoDetallePedidoProducto.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Stream<void> listenToPedidoChanges() {
    return _supabaseClient.from(TABLES.pedidos.name).stream(primaryKey: ['id']);
  }

  // Obtener todas las consultas de un cliente
  Future<List<Consulta>> fetchConsultasByClienteId(String clienteId) async {
    final data = await _supabaseClient
        .from(TABLES.consultas.name)
        .select()
        .eq('cliente_id', clienteId)
        .order('fecha_hora', ascending: false);

    return data.map<Consulta>((c) => Consulta.fromJson(c)).toList();
  }

  // Obtener una consulta específica por ID
  Future<Consulta?> fetchConsultaById(String consultaId) async {
    final data = await _supabaseClient
        .from(TABLES.consultas.name)
        .select()
        .eq('id', consultaId)
        .maybeSingle();

    if (data != null) {
      return Consulta.fromJson(data);
    }
    return null;
  }

  // Actualizar la respuesta de una consulta
  Future<void> updateConsultaRespuesta(
      String consultaId, String respuesta) async {
    await _supabaseClient.from(TABLES.consultas.name).update({
      'respuesta': respuesta,
      'estado': 'respondido',
      'fecha_respuesta': DateTime.now().toIso8601String(),
    }).eq('id', consultaId);
  }

  Future<double> calcularTotalPedido(String pedidoId) async {
    // 1. Obtener los detalles del pedido con el precio de los productos
    final response = await _supabaseClient
        .from('detallePedido')
        .select('cantidad, productos(precio)')
        .eq('pedidoId', pedidoId);

    if (response == null || response.isEmpty) {
      throw Exception('Error fetching order details: No data found');
    }

    double total = 0.0;

    // 2. Calcular el total del pedido usando los datos obtenidos en la consulta
    for (var detalle in response) {
      int cantidad = detalle['cantidad'] ?? 0;
      double precioProducto =
          (detalle['productos']['precio'] as num).toDouble();

      // Calcular el subtotal para este producto y agregarlo al total
      total += cantidad * precioProducto;
    }

    return total;
  }
}
