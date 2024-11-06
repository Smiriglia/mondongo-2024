// qr_scan_page.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mondongo/models/mesa.dart';
import 'package:mondongo/models/pedido.dart';
import 'package:mondongo/routes/app_router.gr.dart';
import 'package:mondongo/services/data_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@RoutePage()
class QrScannerPage extends StatefulWidget {
  @override
  _QrScannerPageState createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  final DataService dataService = DataService();
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Escanear Código QR'),
      ),
      body: MobileScanner(
        onDetect: (barcodeCapture) async {
          if (isProcessing) return;
          setState(() => isProcessing = true);

          final String? qrData = barcodeCapture.barcodes.first.rawValue;
          print(qrData);
          if (qrData != null) {
            try {
              final router = AutoRouter.of(context);
              if (qrData == 'lista_espera') {
                await dataService.addToWaitList(qrData);
                router.push(WaitingToBeAssignedRoute());
              } else if (qrData.contains('Mesa-')) {
                int scannedMesaNumero = int.parse(qrData.split('-').last);

                final userId = Supabase.instance.client.auth.currentUser?.id;
                if (userId == null) {
                  throw Exception('Usuario no autenticado');
                }

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

                if (pedido.mesaNumero != scannedMesaNumero) {
                  // Client scanned a different table
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Esta no es tu mesa asignada. Tu mesa es la número ${pedido.mesaNumero}')),
                  );
                  // Navigate to the page for the assigned table
                  Mesa? assignedMesa =
                      await dataService.fetchMesaByNumero(pedido.mesaNumero!);
                  if (assignedMesa != null) {
                    router.push(MesaRoute(mesa: assignedMesa));
                  } else {
                    router.pushAndPopUntil(
                      HomeRoute(),
                      predicate: (_) => false,
                    );
                  }
                  return;
                }

                // Proceed to mesa page
                Mesa? mesa =
                    await dataService.fetchMesaByNumero(scannedMesaNumero);
                if (mesa != null) {
                  router.push(MesaRoute(mesa: mesa));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Mesa no encontrada')),
                  );
                  router.pushAndPopUntil(
                    HomeRoute(),
                    predicate: (_) => false,
                  );
                }
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
