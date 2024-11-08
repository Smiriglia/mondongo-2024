import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:get_it/get_it.dart';
import 'package:mondongo/models/detalle_pedido.dart';
import 'package:mondongo/models/pedido.dart';
import 'package:mondongo/models/producto.dart';
import 'package:mondongo/services/data_service.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

@RoutePage()
class PaymentPage extends StatefulWidget {
  final Pedido pedido;
  final double discount;

  const PaymentPage({super.key, required this.pedido, required this.discount});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final DataService _dataService = GetIt.instance.get<DataService>();
  double totalPedido = 0.0;
  double finalPrice = 0.0;
  double tipPercentage = 0.0;
  MobileScannerController scannerController = MobileScannerController();

  @override
  void initState() {
    super.initState();
    _calculateTotalPedido();
  }

  Future<void> _calculateTotalPedido() async {
    totalPedido = await _dataService.calcularTotalPedido(widget.pedido.id);
    setState(() {
      finalPrice = totalPedido - (totalPedido * (widget.discount / 100));
    });
  }

  void _updateFinalTotalWithTip(double tip) {
    setState(() {
      tipPercentage = tip;
      finalPrice = totalPedido - (totalPedido * (widget.discount / 100));
      finalPrice += finalPrice * (tipPercentage / 100);
    });
  }

  void _showTipSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Seleccionar Propina'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [0, 10, 15, 20].map((tip) {
              return ListTile(
                title: Text('$tip%'),
                onTap: () {
                  _updateFinalTotalWithTip(tip.toDouble());
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _startQRCodeScanner() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
          height: 400,
          child: MobileScanner(
            controller: scannerController,
            onDetect: _onDetectQRCode,
          ),
        );
      },
    );
  }

  void _onDetectQRCode(BarcodeCapture capture) {
    final String? scannedData = capture.barcodes.first.rawValue;

    if (scannedData != null && scannedData.startsWith('Mesa-')) {
      int? numeroDeMesa = int.tryParse(scannedData.split('-')[1]);
      if (numeroDeMesa != null) {
        scannerController.stop();
        Navigator.pop(context); // Cerrar el escáner
        _showTipSelectionDialog(); // Mostrar opciones de propina
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Código QR inválido para mesa')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Código QR inválido')),
      );
    }
  }

  double _calculateTotalWithTip() {
    return finalPrice;
  }

  Widget _buildOrderDetails() {
    return FutureBuilder<List<DetallePedido>>(
      future: _dataService.fetchOrderDetails(widget.pedido.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No hay detalles del pedido.'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final detalle = snapshot.data![index];
              return FutureBuilder<Producto>(
                future: _dataService.fetchProductById(detalle.productoId),
                builder: (context, productSnapshot) {
                  if (productSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return ListTile(
                      title: Text('Cargando producto...'),
                      subtitle: Text('Cantidad: ${detalle.cantidad}'),
                    );
                  } else if (productSnapshot.hasError) {
                    return ListTile(
                      title: Text('Error al cargar producto'),
                      subtitle: Text('Cantidad: ${detalle.cantidad}'),
                    );
                  } else {
                    final producto = productSnapshot.data!;
                    return ListTile(
                      title: Text(producto.nombre),
                      subtitle: Text('Cantidad: ${detalle.cantidad}'),
                      trailing: Text(
                        '\$${(producto.precio * detalle.cantidad).toStringAsFixed(2)}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  }
                },
              );
            },
          );
        }
      },
    );
  }

  @override
  void dispose() {
    scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4B2C20),
        title: Text(
          'Resumen de Pago',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Detalle del Pedido',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: _buildOrderDetails(),
            ),
            Divider(color: Colors.grey),
            ListTile(
              title: Text(
                'Descuento por Juego',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              trailing: Text(
                '-${widget.discount}%',
                style: TextStyle(color: Colors.greenAccent, fontSize: 18),
              ),
            ),
            Divider(color: Colors.grey),
            ElevatedButton(
              onPressed: _startQRCodeScanner,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4B2C20),
              ),
              child: Text(
                'Escanear QR de Mesa',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            if (tipPercentage > 0) ...[
              ListTile(
                title: Text(
                  'Propina (Satisfacción)',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                trailing: Text(
                  '${tipPercentage.toStringAsFixed(1)}%',
                  style: TextStyle(color: Colors.orangeAccent, fontSize: 18),
                ),
              ),
              Divider(color: Colors.grey),
            ],
            ListTile(
              title: Text(
                'TOTAL a pagar',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              trailing: Text(
                '\$${_calculateTotalWithTip().toStringAsFixed(2)}',
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Pago completado. ¡Gracias!')),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4B2C20),
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: Text(
                'Finalizar Pago',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
