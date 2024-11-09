import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mondongo/models/pedido.dart';
import 'package:mondongo/models/pedido_detalle_pedido_producto.dart';
import 'package:mondongo/services/data_service.dart';
import 'package:mondongo/main.dart';
import 'package:auto_route/auto_route.dart';
import 'package:mondongo/services/push_notification_service.dart';
import 'package:get_it/get_it.dart';

@RoutePage()
class ConfirmacionMozoPage extends StatefulWidget {
  const ConfirmacionMozoPage({super.key});

  @override
  _ConfirmacionMozoPageState createState() => _ConfirmacionMozoPageState();
}

class _ConfirmacionMozoPageState extends State<ConfirmacionMozoPage> {
  final DataService _dataService = getIt<DataService>();
  List<PedidoDetallePedidoProducto> _pedidos = [];
  final PushNotificationService _pushNotificationService =
      GetIt.instance.get<PushNotificationService>();
  bool _isLoading = false;
  bool _isProcessing = false;
  StreamSubscription? _pedidoSubscription;
  StreamSubscription? _detallePedidoSubscription;

  final Color primaryColor = const Color(0xFF4B2C20); // Marrón
  final Color backgroundColor = Color(0xFF5D4037); // Gris claro
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
        [
          'orden',
          'enPreparacion',
          'servido',
          'pagado'
        ], // Incluye el estado "pagado"
      );
      setState(() {
        _pedidos = pedidos;
      });
      // Imprime el estado de los pedidos para verificar
      for (var pedido in _pedidos) {
        print("Pedido ${pedido.pedido.id} estado: ${pedido.pedido.estado}");
      }
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
    _detallePedidoSubscription = _dataService
        .listenToDetallePedidoChanges()
        .listen((_) => _fetchPedidos());
  }

  Future<void> _cerrarPedido(Pedido pedido) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      await _dataService.cerrarPedido(pedido.id);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pedido cerrado y mesa liberada.')),
      );

      // Recargar pedidos después de cerrar uno
      _fetchPedidos();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cerrar el pedido: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
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
      _pushNotificationService.sendNotification(
          topic: 'cocinero',
          title: 'Mondongo Pedidos',
          body: 'Hay nuevos platos que preparar');
      _pushNotificationService.sendNotification(
          topic: 'bartender',
          title: 'Mondongo Pedidos',
          body: 'Hay nuevos tragos que preparar');
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
      await _dataService.actualizarEstadoDetallePedidosPedidoId(
          pedido.id, 'servido');
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
                    'No hay pedidos para\n   confirmar o servir',
                    style: TextStyle(color: Colors.white, fontSize: 22),
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
                          ...pedidoDetalle.detallesPedidoProducto
                              .map((detalle) {
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
                            child: Column(
                              children: [
                                ElevatedButton.icon(
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
                                if (pedido.estado ==
                                    'pagado') // Botón para cerrar pedido
                                  ElevatedButton(
                                    onPressed: _isProcessing
                                        ? null
                                        : () => _cerrarPedido(pedido),
                                    child: Text('Cerrar Pedido'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                  ),
                              ],
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
