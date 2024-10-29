import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRReaderPage extends StatefulWidget {
  final Function(String) onQRRead;

  const QRReaderPage({
    super.key, // Fixed: Using super parameter
    required this.onQRRead,
  });

  @override
  State<QRReaderPage> createState() =>
      _QRReaderPageState(); // Fixed: Changed return type
}

class _QRReaderPageState extends State<QRReaderPage> {
  bool _isDetecting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leer Código QR'),
      ),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) {
              // Fixed: Simplified callback signature
              if (!_isDetecting) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  final String? code = barcode.rawValue;
                  if (code != null && code.isNotEmpty) {
                    setState(() {
                      _isDetecting = true;
                    });
                    widget.onQRRead(code);
                    Navigator.pop(context);
                    break;
                  }
                }
              }
            },
          ),
          CustomScannerOverlay(
            borderColor: Colors.red,
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutSize: 300,
          ),
        ],
      ),
    );
  }
}

class CustomScannerOverlay extends StatelessWidget {
  final Color borderColor;
  final double borderRadius;
  final double borderLength;
  final double borderWidth;
  final double cutOutSize;

  const CustomScannerOverlay({
    super.key, // Fixed: Using super parameter
    required this.borderColor,
    required this.borderRadius,
    required this.borderLength,
    required this.borderWidth,
    required this.cutOutSize,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double height = constraints.maxHeight;
        return Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: Colors.black26,
              ),
            ),
            Positioned(
              left: (width - cutOutSize) / 2,
              top: (height - cutOutSize) / 2,
              child: CustomPaint(
                size: Size(cutOutSize, cutOutSize),
                painter: ScannerOverlayPainter(
                  borderColor: borderColor,
                  borderRadius: borderRadius,
                  borderLength: borderLength,
                  borderWidth: borderWidth,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  final Color borderColor;
  final double borderRadius;
  final double borderLength;
  final double borderWidth;

  ScannerOverlayPainter({
    required this.borderColor,
    required this.borderRadius,
    required this.borderLength,
    required this.borderWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;

    // Draw corner borders
    // Top left corner
    canvas.drawLine(
      Offset(0, 0),
      Offset(borderLength, 0),
      paint,
    );
    canvas.drawLine(
      Offset(0, 0),
      Offset(0, borderLength),
      paint,
    );

    // Top right corner
    canvas.drawLine(
      Offset(size.width - borderLength, 0),
      Offset(size.width, 0),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width, borderLength),
      paint,
    );

    // Bottom left corner
    canvas.drawLine(
      Offset(0, size.height),
      Offset(0, size.height - borderLength),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height),
      Offset(borderLength, size.height),
      paint,
    );

    // Bottom right corner
    canvas.drawLine(
      Offset(size.width - borderLength, size.height),
      Offset(size.width, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width, size.height - borderLength),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant ScannerOverlayPainter oldDelegate) {
    return oldDelegate.borderColor != borderColor ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.borderLength != borderLength ||
        oldDelegate.borderWidth != borderWidth;
  }
}
