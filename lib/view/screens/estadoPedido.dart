import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mondongo/models/detalle_pedido.dart';
import 'package:mondongo/models/pedido.dart';
import 'package:mondongo/models/producto.dart';
import 'package:mondongo/routes/app_router.gr.dart';
import 'package:mondongo/services/data_service.dart';
import 'package:get_it/get_it.dart';

@RoutePage()
class EstatoPedidoPage extends StatefulWidget {
  final Pedido pedido;
  const EstatoPedidoPage({super.key, required this.pedido});

  @override
  State<EstatoPedidoPage> createState() => _EstatoPedidoPageState();
}

class _EstatoPedidoPageState extends State<EstatoPedidoPage> {
  final DataService _dataService = GetIt.instance.get<DataService>();
  late Stream<List<DetallePedido>> _detallePedidoStream;
  late Stream<Pedido> _pedidoStream;
  late Future<List<Producto>> _productosFuture;
  Map<String, Producto> _productosMap = {};
  Pedido? _pedidoActual;

  @override
  void initState() {
    super.initState();
    _detallePedidoStream =
        _dataService.listenToDetallePedidos(widget.pedido.id);
    _pedidoStream = _dataService.listenToPedidoById(widget.pedido.id);
    _productosFuture = _dataService.fetchProductos();
    _loadProductos();
    _listenToPedidoChanges();
  }

  Future<void> _loadProductos() async {
    final productos = await _productosFuture;
    setState(() {
      _productosMap = {for (var producto in productos) producto.id: producto};
    });
  }

  void _listenToPedidoChanges() {
    _pedidoStream.listen((pedido) {
      setState(() {
        _pedidoActual = pedido;
      });

      if (pedido.estado == 'servido') {
        _showServidoDialog();
      }
    }, onError: (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al obtener el pedido: $error',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  void _showServidoDialog() {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Evita que se cierre al tocar fuera del diálogo
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pedido Servido'),
          content: const Text(
              'Tu pedido ha sido servido. Escanea el QR para confirmar la recepción.'),
          actions: [
            TextButton(
              onPressed: () {
                final router = AutoRouter.of(context);
                router.removeLast();
                router.push(QrScannerRoute());
              },
              child: const Text('Ir al Scanner'),
            ),
          ],
        );
      },
    );
  }

  int _calculateTotalEstimatedTime(List<DetallePedido> detalles) {
    return detalles.fold(0, (sum, detalle) {
      final producto = _productosMap[detalle.productoId];
      if (producto != null) {
        return sum + (producto.tiempoElaboracion * detalle.cantidad);
      }
      return sum;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estado del Pedido'),
        backgroundColor: const Color(0xFF4B2C20),
      ),
      body: StreamBuilder<List<DetallePedido>>(
        stream: _detallePedidoStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay detalles del pedido.'));
          } else {
            final detalles = snapshot.data!;
            final totalTiempo = _calculateTotalEstimatedTime(detalles);

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Información general del pedido
                  _buildPedidoInfo(),

                  const SizedBox(height: 16),

                  // Lista de detalles del pedido
                  Expanded(
                    child: ListView.builder(
                      itemCount: detalles.length,
                      itemBuilder: (context, index) {
                        final detalle = detalles[index];
                        final producto = _productosMap[detalle.productoId];

                        if (producto == null) return const SizedBox.shrink();

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  producto.nombre,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF4B2C20),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Cantidad: ${detalle.cantidad}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      'Estado: ${detalle.estado}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: detalle.estado == 'pendiente'
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tiempo estimado: ${producto.tiempoElaboracion * detalle.cantidad} min',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Total tiempo estimado
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4B2C20),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tiempo total estimado:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '$totalTiempo min',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildPedidoInfo() {
    final pedido = _pedidoActual ?? widget.pedido;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mesa: ${pedido.mesaNumero ?? 'No asignada'}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4B2C20),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Estado: ${pedido.estado}',
              style: TextStyle(
                fontSize: 16,
                color: pedido.estado == 'pendiente' ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Fecha: ${_formatFecha(pedido.fecha)}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  String _formatFecha(DateTime fecha) {
    return '${fecha.day.toString().padLeft(2, '0')}/'
        '${fecha.month.toString().padLeft(2, '0')}/'
        '${fecha.year.toString().substring(2)} '
        '${fecha.hour.toString().padLeft(2, '0')}:'
        '${fecha.minute.toString().padLeft(2, '0')}';
  }
}
