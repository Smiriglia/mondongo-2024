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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Escanear Código QR'),
      ),
      body: MobileScanner(
        controller: MobileScannerController(),
        onDetect: (barcodeCapture) async {
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
                router.pushAndPopUntil(
                  WaitingToBeAssignedRoute(),
                  predicate: (_) => false,
                );
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
                  router.pushAndPopUntil(
                    HomeRoute(),
                    predicate: (_) => false,
                  );
                  return;
                }

                if (pedido.estado != 'confirmacion') {
                  // The table hasn't been confirmed yet
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Tu mesa aún no ha sido confirmada. Estado actual: ${pedido.estado}'),
                    ),
                  );
                  router.pushAndPopUntil(
                    WaitingToBeAssignedRoute(),
                    predicate: (_) => false,
                  );
                  return;
                }

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
                router.pushAndPopUntil(
                  ProductsListRoute(),
                  predicate: (_) => false,
                );
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
              router.pushAndPopUntil(
                HomeRoute(),
                predicate: (_) => false,
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('No se pudo leer el código QR')),
            );
            // Navigate back to home
            final router = AutoRouter.of(context);
            router.pushAndPopUntil(
              HomeRoute(),
              predicate: (_) => false,
            );
          }

          setState(() => isProcessing = false);
        },
      ),
    );
  }
}
