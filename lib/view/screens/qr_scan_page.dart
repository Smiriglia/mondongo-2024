// qr_scan_page.dart

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
import 'package:mondongo/view/screens/confirmacionMozo.dart';
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
                router.push(WaitingToBeAssignedRoute());
              } else if (qrData.contains('Mesa-')) {
                // User scanned a table QR code
                int scannedMesaNumero = int.parse(qrData.split('-').last);

                // Fetch the client's current pedido
                Pedido? pedido =
                    await dataService.fetchPedidoByClienteId(userId);

                if (pedido == null || pedido.mesaNumero == null) {
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
                      // Optionally navigate back or handle accordingly
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
                  default:
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Tu mesa aún no ha sido confirmada. Estado actual: ${pedido.estado}'),
                      ),
                    );
                    router.removeLast();
                    router.push(WaitingToBeAssignedRoute());
                    return;
                }
              } else {
                // Handle other QR data if needed
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
