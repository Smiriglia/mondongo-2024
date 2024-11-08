import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mondongo/services/data_service.dart';
import 'package:get_it/get_it.dart';
import 'package:mondongo/services/auth_services.dart';
import 'package:mondongo/models/pedido.dart';
import 'package:auto_route/auto_route.dart';
import 'package:mondongo/routes/app_router.gr.dart';

@RoutePage()
class WaitingToBeAssignedPage extends StatefulWidget {
  final Pedido pedido;
  const WaitingToBeAssignedPage({Key? key, required this.pedido}) : super(key: key);

  @override
  WaitingToBeAssignedPageState createState() => WaitingToBeAssignedPageState();
}

class WaitingToBeAssignedPageState extends State<WaitingToBeAssignedPage> {
  final DataService _dataService = GetIt.instance.get<DataService>();
  final AuthService _authService = GetIt.instance.get<AuthService>();
  Pedido? _pedido;

  StreamSubscription<Pedido>? _pedidoSubscription;

  @override
  void initState() {
    super.initState();
    _subscribeToPedidoChanges();
  }

  @override
  void dispose() {
    _pedidoSubscription?.cancel();
    super.dispose();
  }

  void _subscribeToPedidoChanges() {
    final userId = _authService.getUser()?.id;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Usuario no identificado')),
      );
      return;
    }

    _pedidoSubscription = _dataService
        .listenToPedidoById(widget.pedido.id)
        .listen((pedido) {
      setState(() {
        _pedido = pedido;
      });

      if (pedido.estado == 'confirmacion') {
        _showQrScannerDialog();
      }
    }, onError: (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error en la suscripción: $error')),
      );
    });
  }

  void _showQrScannerDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Mesa Confirmada'),
          content: const Text(
              'Se te ha asignado una mesa. Escanea el QR para confirmarla.'),
          actions: [
            TextButton(
              onPressed: () {
                final router = AutoRouter.of(context);
                router.removeLast();
                router.push(const QrScannerRoute());
              },
              child: const Text('Ir al escáner'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Esperando asignación'),
        backgroundColor: const Color(0xFF4B2C20),
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
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (_pedido!.mesaNumero != null)
                Text(
                  'Mesa asignada: ${_pedido!.mesaNumero}',
                  style: const TextStyle(fontSize: 16),
                ),
            ],
            const SizedBox(height: 30),
            const CircularProgressIndicator(), // Indica que está en espera de actualizaciones
          ],
        ),
      ),
    );
  }
}
