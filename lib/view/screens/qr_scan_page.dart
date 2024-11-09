import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mondongo/models/mesa.dart';
import 'package:mondongo/models/pedido.dart';
import 'package:mondongo/routes/app_router.gr.dart';
import 'package:mondongo/services/auth_services.dart';
import 'package:mondongo/services/data_service.dart';
import 'package:mondongo/services/push_notification_service.dart';
import 'package:mondongo/view/screens/confirmacionMozo.dart';
import 'package:mondongo/view/screens/games_screen.dart';
import 'package:mondongo/view/screens/survey_results_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@RoutePage()
class QrScannerPage extends StatefulWidget {
  const QrScannerPage({Key? key}) : super(key: key);

  @override
  QrScannerPageState createState() => QrScannerPageState();
}

class QrScannerPageState extends State<QrScannerPage> {
  final DataService dataService = GetIt.instance.get<DataService>();
  final AuthService _authService = GetIt.instance.get<AuthService>();
  final PushNotificationService _pushNotificationService = GetIt.instance.get<PushNotificationService>();
  bool isProcessing = false;
  MobileScannerController controller = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    controller.stop();
    return Scaffold(
      appBar: AppBar(
        title: Text('Escanear Código QR'),
      ),
      body: MobileScanner(
        controller: controller,
        onDetect: (barcodeCapture) async {
          controller.stop();
          if (isProcessing) return;
          setState(() => isProcessing = true);

          final String? qrData = barcodeCapture.barcodes.first.rawValue;
          print('QR Data: $qrData');

          if (qrData != null) {
            try {
              final router = AutoRouter.of(context);
              final userId = _authService.getUser()?.id;

              if (userId == null) {
                throw Exception('Usuario no autenticado');
              }

              // Handle QR codes
              if (qrData == 'lista_espera') {
                // User wants to join the waitlist
                await dataService.addToWaitList(userId);
                router.removeLast();
                Pedido? pedido =
                    await dataService.fetchPedidoByClienteId(userId);
                _pushNotificationService.sendNotification(topic: 'maitre', title: 'Mondongo', body: 'Cliente en lista de espera');
                if (pedido == null) throw Exception('pedido no encontrado');
                router.push(WaitingToBeAssignedRoute(pedido: pedido));
              } else if (qrData.contains('Mesa-')) {
                // User scanned a table QR code
                int scannedMesaNumero = int.parse(qrData.split('-').last);

                // Fetch the client's current pedido
                Pedido? pedido =
                    await dataService.fetchPedidoByClienteId(userId);

                if (pedido == null) {
                  // Client doesn't have any pedido
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('No tienes un pedido activo')),
                  );
                  router.removeLast();
                  return;
                }

                // Check if the pedido is in 'Pagado' state
                if (pedido.estado == 'pagado') {
                  // Navigate to survey screen
                  router.removeLast();
                  router
                      .push(SurveyResultsRoute(mesaNumero: scannedMesaNumero));
                  return;
                }

// Dentro de QrScannerPageState
                if (pedido.estado == 'recibido') {
                  if (!mounted) return;
                  router.removeLast();
                  router.push(GamesRoute(pedido: pedido)); // Pasar el pedido
                  return;
                }

                if (pedido.estado == 'pagando') {
                  // Navigate to survey screen
                  router.removeLast();
                  router.push(SurveyRouteRoute(pedido: pedido, discount: 0.0));
                  return;
                }

                if (pedido.estado == 'cerrada') {
                  // Navigate to survey screen
                  router.removeLast();
                  router
                      .push(SurveyResultsRoute(mesaNumero: scannedMesaNumero));
                  return;
                }

                // Handle other states
                if (pedido.mesaNumero == null) {
                  // Client doesn't have an assigned table
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('No tienes una mesa asignada')),
                  );
                  router.removeLast();
                  return;
                }

                switch (pedido.estado) {
                  case 'confirmacion':
                    if (pedido.mesaNumero != scannedMesaNumero) {
                      // Client scanned a different table
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Esta no es tu mesa asignada. Tu mesa es la número ${pedido.mesaNumero}',
                          ),
                        ),
                      );
                      return;
                    }

                    // Proceed to products list page
                    router.removeLast();
                    router.push(ProductsListRoute(pedido: pedido));
                    break;
                  case 'orden':
                    router.removeLast();
                    router.push(EstatoPedidoRoute(pedido: pedido));
                    break;
                  case 'enPreparacion':
                    router.removeLast();
                    router.push(EstatoPedidoRoute(pedido: pedido));
                    break;
                  default:
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Tu mesa aún no ha sido confirmada. Estado actual: ${pedido.estado}'),
                      ),
                    );
                    router.removeLast();
                    router.push(WaitingToBeAssignedRoute(pedido: pedido));
                    return;
                }
              } else {
                // Handle invalid QR code
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Código QR inválido o no reconocido')),
                );
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error al procesar el código QR: $e')),
              );
              // Navigate back to home
              final router = AutoRouter.of(context);
              router.removeLast();
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('No se pudo leer el código QR')),
            );
            // Navigate back to home
            final router = AutoRouter.of(context);
            router.removeLast();
          }

          setState(() => isProcessing = false);
        },
      ),
    );
  }
}
