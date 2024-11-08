import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:get_it/get_it.dart';
import 'package:mondongo/routes/app_router.gr.dart';
import 'package:mondongo/models/detalle_pedido.dart';
import 'package:mondongo/models/pedido.dart';
import 'package:mondongo/models/producto.dart';
import 'package:mondongo/services/data_service.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mondongo/view/screens/home.dart';

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
          backgroundColor: const Color(0xFF5D4037),
          title: const Text(
            'Seleccionar Propina',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [0, 10, 15, 20].map((tip) {
              return ListTile(
                title: Text(
                  '$tip%',
                  style: const TextStyle(color: Colors.white),
                ),
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
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: 400,
          decoration: const BoxDecoration(
            color: const Color.fromARGB(255, 61, 39, 31),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
          ),
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
          const SnackBar(
            content: Text('Código QR inválido para mesa'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Código QR inválido'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
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
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF4B2C20),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No hay detalles del pedido.',
              style: TextStyle(color: Color(0xFF4B2C20)),
            ),
          );
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
                    return const ListTile(
                      title: Text('Cargando producto...'),
                      subtitle: Text('Cantidad: '),
                    );
                  } else if (productSnapshot.hasError) {
                    return const ListTile(
                      title: Text('Error al cargar producto'),
                      subtitle: Text('Cantidad: '),
                    );
                  } else {
                    final producto = productSnapshot.data!;
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      color: const Color(0xFF5D4037),
                      elevation: 4,
                      child: ListTile(
                        title: Text(
                          producto.nombre,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'Cantidad: ${detalle.cantidad}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        trailing: Text(
                          '\$${(producto.precio * detalle.cantidad).toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
      backgroundColor: Color(0xFF5D4037),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B2C20),
        title: const Text(
          'Resumen de Pago',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Título de la sección
            Text(
              'Detalle del Pedido',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 61, 39, 31),
              ),
            ),
            const SizedBox(height: 16),
            // Detalles del pedido
            Expanded(
              child: _buildOrderDetails(),
            ),
            const Divider(color: Colors.grey),
            // Descuento aplicado
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              color: const Color(0xFF5D4037),
              elevation: 4,
              child: ListTile(
                title: const Text(
                  'Descuento por Juego',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                trailing: Text(
                  '-${widget.discount}%',
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const Divider(color: Colors.grey),
            // Botón para escanear QR
            ElevatedButton(
              onPressed: _startQRCodeScanner,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 61, 39, 31),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text(
                'Escanear QR de Mesa',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            if (tipPercentage > 0) ...[
              const SizedBox(height: 16),
              // Propina seleccionada
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                color: const Color(0xFF5D4037),
                elevation: 4,
                child: ListTile(
                  title: const Text(
                    'Propina (Satisfacción)',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  trailing: Text(
                    '${tipPercentage.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      color: Colors.orangeAccent,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const Divider(color: Colors.grey),
            ],
            // Total a pagar
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              color: const Color.fromARGB(255, 61, 39, 31),
              elevation: 4,
              child: ListTile(
                title: const Text(
                  'TOTAL a pagar',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                trailing: Text(
                  '\$${_calculateTotalWithTip().toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Botón para finalizar pago
            ElevatedButton(
              onPressed: () async {
                await _dataService.markPedidoAsPaid(widget.pedido.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pago completado. ¡Gracias!'),
                    backgroundColor: const Color.fromARGB(255, 61, 39, 31),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                AutoRouter.of(context)
                    .popUntil((route) => route.settings.name == 'HomeRoute');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 61, 39, 31),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text(
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
