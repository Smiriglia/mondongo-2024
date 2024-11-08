import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mondongo/models/pedido.dart';
import 'package:mondongo/models/pedido_detalle_pedido_producto.dart';
import 'package:mondongo/services/data_service.dart';
import 'package:mondongo/main.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class ConfirmacionMozoPage extends StatefulWidget {
  const ConfirmacionMozoPage({super.key});

  @override
  _ConfirmacionMozoPageState createState() => _ConfirmacionMozoPageState();
}

class _ConfirmacionMozoPageState extends State<ConfirmacionMozoPage> {
  final DataService _dataService = getIt<DataService>();
  List<PedidoDetallePedidoProducto> _pedidos = [];
  bool _isLoading = false;
  StreamSubscription? _pedidoSubscription;
  StreamSubscription? _detallePedidoSubscription;

  final Color primaryColor = const Color(0xFF4B2C20); // Marrón
  final Color backgroundColor = const Color(0xFFF5F5F5); // Gris claro
  final Color textColor = Colors.black87;

  @override
  void initState() {
    super.initState();
    _fetchPedidos();
    _setupRealtimeListeners();
  }

  Future<void> _fetchPedidos() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final pedidos = await _dataService.getPedidosWithDetallesByEstado(
        ['orden', 'enPreparacion'],
      );
      setState(() {
        _pedidos = pedidos;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al obtener los pedidos: ${e.toString()}',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _setupRealtimeListeners() {
    _pedidoSubscription =
        _dataService.listenToPedidoChanges().listen((_) => _fetchPedidos());
    _detallePedidoSubscription =
        _dataService.listenToDetallePedidoChanges().listen((_) => _fetchPedidos());
  }

  Future<void> _confirmarPedido(Pedido pedido) async {
    try {
      await _dataService.actualizarEstadoPedido(pedido.id, 'enPreparacion');
      await _dataService.actualizarEstadoDetallePedidosPedidoId(
          pedido.id, 'ordenado');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Pedido confirmado y en preparación',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al confirmar el pedido: ${e.toString()}',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _servirPedido(Pedido pedido) async {
    try {
      await _dataService.actualizarEstadoPedido(pedido.id, 'servido');
      await _dataService.actualizarEstadoDetallePedidosPedidoId(pedido.id, 'servido');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Pedido servido',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al servir el pedido: ${e.toString()}',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  bool _todosLosDetallesListos(PedidoDetallePedidoProducto pedido) {
    return pedido.detallesPedidoProducto
        .every((detalle) => detalle.detallePedido.estado == 'listo');
  }

  @override
  void dispose() {
    _pedidoSubscription?.cancel();
    _detallePedidoSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Confirmación de Pedidos',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pedidos.isEmpty
              ? Center(
                  child: Text(
                    'No hay pedidos para confirmar o servir',
                    style: TextStyle(color: textColor, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: _pedidos.length,
                  itemBuilder: (context, index) {
                    final pedidoDetalle = _pedidos[index];
                    final pedido = pedidoDetalle.pedido;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: ExpansionTile(
                        leading: Icon(
                          Icons.receipt_long,
                          color: primaryColor,
                        ),
                        title: Text(
                          'Mesa: ${pedido.mesaNumero}',
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'Estado: ${pedido.estado.toUpperCase()}',
                          style: TextStyle(
                            color: pedido.estado == 'enPreparacion'
                                ? Colors.orange
                                : Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        children: [
                          ...pedidoDetalle.detallesPedidoProducto.map((detalle) {
                            return ListTile(
                              leading: detalle.producto.fotosUrls.isNotEmpty
                                  ? Image.network(
                                      detalle.producto.fotosUrls[0],
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(Icons.fastfood),
                              title: Text(
                                detalle.producto.nombre,
                                style: TextStyle(color: textColor),
                              ),
                              subtitle: Text(
                                'Estado: ${detalle.detallePedido.estado}',
                                style: TextStyle(
                                  color: detalle.detallePedido.estado == 'listo'
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            );
                          }).toList(),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ElevatedButton.icon(
                              onPressed: pedido.estado == 'orden'
                                  ? () => _confirmarPedido(pedido)
                                  : _todosLosDetallesListos(pedidoDetalle)
                                      ? () => _servirPedido(pedido)
                                      : null,
                              icon: Icon(
                                pedido.estado == 'orden'
                                    ? Icons.check
                                    : Icons.done_all,
                              ),
                              label: Text(pedido.estado == 'orden'
                                  ? 'Confirmar'
                                  : 'Servir'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: pedido.estado == 'orden'
                                    ? Colors.orange
                                    : Colors.green,
                                disabledBackgroundColor: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
