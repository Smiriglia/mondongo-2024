// mesa_qr_scanner_page.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mondongo/models/pedido.dart';
import 'package:mondongo/routes/app_router.gr.dart';
import 'package:mondongo/services/data_service.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@RoutePage()
class MesaQrScannerPage extends StatefulWidget {
  const MesaQrScannerPage({Key? key}) : super(key: key);

  @override
  MesaQrScannerPageState createState() => MesaQrScannerPageState();
}

class MesaQrScannerPageState extends State<MesaQrScannerPage> {
  final DataService dataService = GetIt.instance.get<DataService>();
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Escanear Código QR de la Mesa'),
      ),
      body: MobileScanner(
        onDetect: (barcodeCapture) async {
          if (isProcessing) return;
          setState(() => isProcessing = true);

          final String? qrData = barcodeCapture.barcodes.first.rawValue;
          if (qrData != null) {
            try {
              final router = AutoRouter.of(context);
              if (qrData.contains('Mesa-')) {
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
