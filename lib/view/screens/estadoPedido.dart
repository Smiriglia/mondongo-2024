import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mondongo/models/detalle_pedido.dart';
import 'package:mondongo/models/pedido.dart';
import 'package:mondongo/models/producto.dart';
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
  late Future<List<Producto>> _productosFuture;
  Map<String, Producto> _productosMap = {};

  @override
  void initState() {
    super.initState();
    _detallePedidoStream =
        _dataService.listenToDetallePedidos(widget.pedido.id);
    _productosFuture = _dataService.fetchProductos();
    _loadProductos();
  }

  Future<void> _loadProductos() async {
    final productos = await _productosFuture;
    setState(() {
      _productosMap = {for (var producto in productos) producto.id: producto};
    });
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
        title: Text('Estado del Pedido'),
        backgroundColor: Color(0xFF4B2C20),
      ),
      body: StreamBuilder<List<DetallePedido>>(
        stream: _detallePedidoStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay detalles del pedido.'));
          } else {
            final detalles = snapshot.data!;
            final totalTiempo = _calculateTotalEstimatedTime(detalles);

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Información general del pedido
                  _buildPedidoInfo(),

                  SizedBox(height: 16),

                  // Lista de detalles del pedido
                  Expanded(
                    child: ListView.builder(
                      itemCount: detalles.length,
                      itemBuilder: (context, index) {
                        final detalle = detalles[index];
                        final producto = _productosMap[detalle.productoId];

                        if (producto == null) return SizedBox.shrink();

                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
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
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF4B2C20),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Cantidad: ${detalle.cantidad}',
                                      style: TextStyle(fontSize: 16),
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
                                SizedBox(height: 8),
                                Text(
                                  'Tiempo estimado: ${producto.tiempoElaboracion * detalle.cantidad} min',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 16),

                  // Total tiempo estimado
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF4B2C20),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tiempo total estimado:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '$totalTiempo min',
                          style: TextStyle(
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
              'Mesa: ${widget.pedido.mesaNumero ?? 'No asignada'}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4B2C20),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Estado: ${widget.pedido.estado}',
              style: TextStyle(
                fontSize: 16,
                color: widget.pedido.estado == 'pendiente'
                    ? Colors.red
                    : Colors.green,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Fecha: ${_formatFecha(widget.pedido.fecha)}',
              style: TextStyle(fontSize: 16),
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
