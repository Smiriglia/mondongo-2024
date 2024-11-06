import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mondongo/models/mesa.dart';
import 'package:mondongo/routes/app_router.gr.dart';
import 'package:mondongo/services/data_service.dart';

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
                router.removeLast();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Te has añadido a la lista de espera')),
                );
                router.removeLast();
              } else if (qrData.contains('Mesa-')) {
                int number = int.parse(qrData.split('-').last);

                Mesa? mesa = await dataService.fetchMesaByNumero(number);
                router.removeLast();
                if (mesa != null) {
                  router.push(MesaRoute(mesa: mesa));
                }
                else {
                  ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Mesa no encontrada')),
                  );
                }
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Error al añadir a la lista de espera: $e')),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('No se pudo leer el código QR')),
            );
          }

          setState(() => isProcessing = false);
        },
      ),
    );
  }
}
