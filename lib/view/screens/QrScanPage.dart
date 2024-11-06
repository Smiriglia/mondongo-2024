import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mondongo/services/data_service.dart';

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
          if (qrData != null) {
            try {
              await dataService.addToWaitList(
                  qrData); // Función para agregar a lista de espera
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Te has añadido a la lista de espera')),
              );
              Navigator.pop(context); // Volver después de escanear
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
