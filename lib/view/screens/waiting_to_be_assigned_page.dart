// waiting_to_be_assigned_page.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:mondongo/services/auth_services.dart';
import 'package:mondongo/models/pedido.dart';
import 'package:auto_route/auto_route.dart';
import 'package:mondongo/routes/app_router.gr.dart';

@RoutePage()
class WaitingToBeAssignedPage extends StatefulWidget {
  @override
  _WaitingToBeAssignedPageState createState() =>
      _WaitingToBeAssignedPageState();
}

class _WaitingToBeAssignedPageState extends State<WaitingToBeAssignedPage> {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  StreamSubscription<List<Map<String, dynamic>>>? _subscription;
  Pedido? _pedido;

  @override
  void initState() {
    super.initState();
    _subscribeToPedido();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _subscribeToPedido() {
    final authService = GetIt.instance.get<AuthService>();
    final userId = authService.getUser()?.id;

    if (userId == null) {
      // Handle error: user not logged in
      return;
    }

    // Fetch the current pedido
    _fetchCurrentPedido(userId);

    // Subscribe to changes in 'pedidos' table for the current user
    _subscription = _supabaseClient
        .from('pedidos')
        .stream(primaryKey: ['id'])
        .eq('clienteId', userId)
        .listen((List<Map<String, dynamic>> data) {
          if (data.isNotEmpty) {
            // Assuming the latest pedido is the first one
            setState(() {
              _pedido = Pedido.fromJson(data.first);
            });
            // Check if estado is 'confirmacion'
            if (_pedido!.estado == 'confirmacion') {
              // Navigate to the home page
              final router = AutoRouter.of(context);
              router.pushAndPopUntil(
                HomeRoute(),
                predicate: (_) => false,
              );
            }
          }
        });
  }

  Future<void> _fetchCurrentPedido(String userId) async {
    final data = await _supabaseClient
        .from('pedidos')
        .select()
        .eq('clienteId', userId)
        .order('fecha', ascending: false)
        .limit(1)
        .maybeSingle();

    if (data != null) {
      setState(() {
        _pedido = Pedido.fromJson(data);
      });
      if (_pedido!.estado == 'confirmacion') {
        // Navigate to the home page
        final router = AutoRouter.of(context);
        router.pushAndPopUntil(
          HomeRoute(),
          predicate: (_) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build a simple waiting screen
    return Scaffold(
      appBar: AppBar(
        title: Text('Esperando asignación'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Esperando a ser asignado a una mesa...'),
            if (_pedido != null) Text('Estado actual: ${_pedido!.estado}'),
            if (_pedido != null && _pedido!.mesaNumero != null)
              Text('Mesa asignada: ${_pedido!.mesaNumero}'),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
