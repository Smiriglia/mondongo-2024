import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mondongo/models/detalle_pedido_producto.dart';
import 'package:mondongo/models/empleado.dart';
import 'package:mondongo/services/auth_services.dart';
import 'package:mondongo/services/data_service.dart';
import 'package:get_it/get_it.dart';

@RoutePage()
class RealizarPedidosPage extends StatefulWidget {
  const RealizarPedidosPage({super.key});

  @override
  State<RealizarPedidosPage> createState() => _RealizarPedidosPageState();
}

class _RealizarPedidosPageState extends State<RealizarPedidosPage> {
  final _authService = GetIt.instance.get<AuthService>();
  final _dataService = GetIt.instance.get<DataService>();

  late String _userSector;
  late Future<List<DetallePedidoProducto>> _detallePedidoFuture;
  StreamSubscription? _realtimeSubscription;

  @override
  void initState() {
    super.initState();
    Empleado empleado = _authService.profile as Empleado;
    _userSector = empleado.tipoEmpleado == 'cocinero'
        ? 'cocina'
        : 'bar';
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
    _realtimeSubscription = _dataService
        .listenToDetallePedidoChanges(['ordenado', 'en preparacion'])
        .listen((_) {
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
      appBar: AppBar(
        title: Text('Realizar Pedidos'),
        backgroundColor: Color(0xFF4B2C20),
      ),
      body: FutureBuilder<List<DetallePedidoProducto>>(
        future: _detallePedidoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay pedidos disponibles.'));
          } else {
            final detalles = snapshot.data!;

            return ListView.builder(
              itemCount: detalles.length,
              itemBuilder: (context, index) {
                final detalle = detalles[index];

                return Card(
                  margin: EdgeInsets.all(8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 3,
                  child: ListTile(
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
                        Text('Cantidad: ${detalle.detallePedido.cantidad}'),
                        Text('Estado: ${detalle.detallePedido.estado}'),
                        Text(
                            'Tiempo estimado: ${detalle.producto.tiempoElaboracion * detalle.detallePedido.cantidad} min'),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        final nextState = detalle.detallePedido.estado == 'ordenado'
                            ? 'en preparacion'
                            : 'listo';
                        _updateEstado(detalle.detallePedido.id, nextState);
                      },
                      child: Text(
                        detalle.detallePedido.estado == 'ordenado'
                            ? 'Preparar'
                            : 'Finalizar',
                      ),
                    ),
                  ),
                );
              },
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
