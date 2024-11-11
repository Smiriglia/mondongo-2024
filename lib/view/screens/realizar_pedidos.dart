// lib/view/screens/realizarPedidos.dart
import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mondongo/models/detalle_pedido_producto.dart';
import 'package:mondongo/models/empleado.dart';
import 'package:mondongo/services/auth_services.dart';
import 'package:mondongo/services/data_service.dart';
import 'package:get_it/get_it.dart';
import 'package:mondongo/services/push_notification_service.dart';

@RoutePage()
class RealizarPedidosPage extends StatefulWidget {
  const RealizarPedidosPage({super.key});

  @override
  State<RealizarPedidosPage> createState() => _RealizarPedidosPageState();
}

class _RealizarPedidosPageState extends State<RealizarPedidosPage> {
  final _authService = GetIt.instance.get<AuthService>();
  final _dataService = GetIt.instance.get<DataService>();
  final _pushNotificationService =
      GetIt.instance.get<PushNotificationService>();

  late String _userSector;
  late Future<List<DetallePedidoProducto>> _detallePedidoFuture;
  StreamSubscription? _realtimeSubscription;

  @override
  void initState() {
    super.initState();
    Empleado empleado = _authService.profile as Empleado;
    _userSector = empleado.tipoEmpleado == 'cocinero' ? 'cocina' : 'bar';
    _fetchData();

    _listenToRealtimeChanges();
  }

  void _fetchData() {
    setState(() {
      _detallePedidoFuture = _dataService.getDetallePedidosPorEstadoYSector(
        ['ordenado', 'en preparacion'],
        _userSector,
      );
    });
  }

  void _listenToRealtimeChanges() {
    _realtimeSubscription =
        _dataService.listenToDetallePedidoChanges().listen((_) {
      // Cuando detectamos un cambio, volvemos a cargar los datos
      _fetchData();
    });
  }

  @override
  void dispose() {
    _realtimeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF5D4037),
      appBar: AppBar(
        title: const Text(
          'Realizar Pedidos',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF4B2C20),
        elevation: 4,
      ),
      body: FutureBuilder<List<DetallePedidoProducto>>(
        future: _detallePedidoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4B2C20)),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(
                  color: Color(0xFF4B2C20),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No hay pedidos disponibles.',
                style: TextStyle(
                  color: Color(0xFF4B2C20),
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          } else {
            final detalles = snapshot.data!;

            return RefreshIndicator(
              onRefresh: () async {
                _fetchData();
                await _detallePedidoFuture;
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: detalles.length,
                itemBuilder: (context, index) {
                  final detalle = detalles[index];

                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 4,
                    shadowColor: Color(0xFF5D4037).withOpacity(0.5),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      leading: detalle.producto.fotosUrls.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                detalle.producto.fotosUrls[0],
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Color(0xFF5D4037),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.fastfood,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                      title: Text(
                        detalle.producto.nombre,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4B2C20),
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4),
                          Text(
                            'Cantidad: ${detalle.detallePedido.cantidad}',
                            style: TextStyle(
                              color: Color(0xFF4B2C20),
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Estado: ${detalle.detallePedido.estado}',
                            style: TextStyle(
                              color: detalle.detallePedido.estado == 'ordenado'
                                  ? Colors.orange
                                  : detalle.detallePedido.estado ==
                                          'en preparacion'
                                      ? Colors.blue
                                      : Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Tiempo estimado: ${detalle.producto.tiempoElaboracion * detalle.detallePedido.cantidad} min',
                            style: TextStyle(
                              color: Color(0xFF4B2C20),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          final nextState =
                              detalle.detallePedido.estado == 'ordenado'
                                  ? 'en preparacion'
                                  : 'listo';
                          _updateEstado(detalle.detallePedido.id, nextState);
                          _pushNotificationService.sendNotification(
                              topic: 'mozo',
                              title: 'Mondongo Pedidos',
                              body:
                                  '${detalle.producto.nombre} Ahora esta: $nextState');
                        },
                        child: Text(
                          detalle.detallePedido.estado == 'ordenado'
                              ? 'Preparar'
                              : 'Finalizar',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              detalle.detallePedido.estado == 'ordenado'
                                  ? Colors.orange
                                  : Colors.green,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _updateEstado(String detalleId, String nuevoEstado) async {
    try {
      await _dataService.actualizarEstadoDetallePedido(detalleId, nuevoEstado);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Estado actualizado a $nuevoEstado.'),
          backgroundColor: Colors.green,
        ),
      );
      _fetchData(); // Refrescar la lista después de actualizar
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar el estado: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
