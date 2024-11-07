// waiting_to_be_assigned_page.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mondongo/services/data_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:mondongo/services/auth_services.dart';
import 'package:mondongo/models/pedido.dart';
import 'package:auto_route/auto_route.dart';
import 'package:mondongo/routes/app_router.gr.dart';

@RoutePage()
class WaitingToBeAssignedPage extends StatefulWidget {
  const WaitingToBeAssignedPage({Key? key}) : super(key: key);

  @override
  WaitingToBeAssignedPageState createState() => WaitingToBeAssignedPageState();
}

class WaitingToBeAssignedPageState extends State<WaitingToBeAssignedPage> {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  StreamSubscription<List<Map<String, dynamic>>>? _subscription;
  Pedido? _pedido;
  bool _isLoading = false;

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

  Future<void> _checkPedidoStatus() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authService = GetIt.instance.get<AuthService>();
      final dataService = GetIt.instance.get<DataService>();
      final userId = authService.getUser()?.id;

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Usuario no identificado')),
        );
        return;
      }

      final pedido = await dataService.fetchCurrentPedido(userId);

      if (!mounted) return;

      if (pedido != null) {
        setState(() {
          _pedido = pedido;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se encontró un pedido activo')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _subscribeToPedido() {
    final authService = GetIt.instance.get<AuthService>();
    final dataService = GetIt.instance.get<DataService>();
    final userId = authService.getUser()?.id;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Usuario no identificado')),
      );
      return;
    }

    // Fetch initial state
    _checkPedidoStatus();

    // Subscribe to changes
    _subscription = _supabaseClient
        .from('pedidos')
        .stream(primaryKey: ['id'])
        .eq('clienteId', userId)
        .listen(
          (List<Map<String, dynamic>> data) {
            if (!mounted) return;

            if (data.isNotEmpty) {
              final newPedido = Pedido.fromJson(data.first);
              setState(() {
                _pedido = newPedido;
              });

              // No automatic navigation here
              // We'll handle the UI update in the build method
            }
          },
          onError: (error) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error en la suscripción: $error')),
            );
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    final isConfirmed = _pedido?.estado == 'confirmacion';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Esperando asignación'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Esperando a ser asignado a una mesa...',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            if (_pedido != null) ...[
              Text(
                'Estado actual: ${_pedido!.estado}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (_pedido!.mesaNumero != null)
                Text(
                  'Mesa asignada: ${_pedido!.mesaNumero}',
                  style: const TextStyle(fontSize: 16),
                ),
            ],
            const SizedBox(height: 30),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (isConfirmed)
              ElevatedButton.icon(
                onPressed: () {
                  final router = AutoRouter.of(context);
                  router.push(const QrScannerRoute());
                },
                icon: const Icon(Icons.qr_code),
                label: const Text('Escanear QR de la Mesa'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              )
            else
              ElevatedButton.icon(
                onPressed: _checkPedidoStatus,
                icon: const Icon(Icons.refresh),
                label: const Text('Actualizar estado'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
