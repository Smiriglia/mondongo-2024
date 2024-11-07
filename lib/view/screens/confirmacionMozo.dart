// lib/view/screens/confirmacion_mozo.dart

import 'package:flutter/material.dart';
import 'package:mondongo/models/pedido.dart';
import 'package:mondongo/services/data_service.dart';
import 'package:mondongo/main.dart';
import 'package:auto_route/auto_route.dart';
// Asegúrate de que EmailService esté correctamente implementado si lo usas
import 'package:mondongo/services/email_service.dart';

@RoutePage()
class ConfirmacionMozoPage extends StatefulWidget {
  const ConfirmacionMozoPage({super.key});

  @override
  _ConfirmacionMozoPageState createState() => _ConfirmacionMozoPageState();
}

class _ConfirmacionMozoPageState extends State<ConfirmacionMozoPage> {
  final DataService _dataService = getIt<DataService>();
  final EmailService _emailService = getIt<EmailService>();
  List<Pedido> _pedidosEnOrden = [];
  bool _isLoading = false;

  // Colores personalizados
  final Color primaryColor = const Color(0xFF4B2C20); // Marrón
  final Color accentColor = const Color(0xFFD2B48C); // Canela
  final Color backgroundColor = const Color(0xFFF5F5F5); // Gris claro
  final Color textColor = Colors.black87;

  @override
  void initState() {
    super.initState();
    _fetchPedidosEnOrden();
  }

  Future<void> _fetchPedidosEnOrden() async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<Pedido> pedidos = await _dataService.fetchPedidosEnOrden();
      setState(() {
        _pedidosEnOrden = pedidos;
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

  Future<void> _confirmarPedido(Pedido pedido) async {
    try {
      // Actualizar el estado del pedido a 'enPreparacion'
      await _dataService.actualizarEstadoPedido(pedido.id, 'enPreparacion');
      await _dataService.actualizarEstadoDetallePedidosPedidoId(pedido.id, 'ordenado');


      setState(() {
        _pedidosEnOrden.remove(pedido);
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Pedido ${pedido.id} pasado a "En Preparación"',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: primaryColor,
        ),
      );
    } catch (e) {
      if (!mounted) return;
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

  Widget _buildPedidoItem(Pedido pedido) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        leading: Icon(Icons.receipt_long, color: primaryColor),
        title: Text(
          'Pedido ID: ${pedido.id}',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Cliente ID: ${pedido.clienteId} | Mesa: ${pedido.mesaNumero ?? 'N/A'}',
          style: TextStyle(color: textColor),
        ),
        children: [
          // ListView.builder(
          //   shrinkWrap: true,
          //   physics: const NeverScrollableScrollPhysics(),
          //   itemCount: pedido.productos.length,
          //   itemBuilder: (context, index) {
          //     var producto = pedido.productos[index];
          //     return ListTile(
          //       leading: producto.fotosUrls.isNotEmpty
          //           ? Image.network(
          //               producto.fotosUrls[0],
          //               width: 50,
          //               height: 50,
          //               fit: BoxFit.cover,
          //             )
          //           : Icon(Icons.fastfood, color: accentColor),
          //       title: Text(
          //         producto.nombre,
          //         style: TextStyle(color: textColor),
          //       ),
          //       subtitle: Text(
          //         'Precio: \$${producto.precio.toStringAsFixed(2)}',
          //         style: TextStyle(color: textColor),
          //       ),
          //     );
          //   },
          // ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () => _confirmarPedido(pedido),
              icon: const Icon(Icons.check),
              label: const Text('Confirmar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Botón verde para confirmar
              ),
            ),
          ),
        ],
      ),
    );
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
          : _pedidosEnOrden.isEmpty
              ? Center(
                  child: Text(
                    'No hay pedidos en estado "Orden" para confirmar',
                    style: TextStyle(color: textColor, fontSize: 16),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _fetchPedidosEnOrden,
                  child: ListView.builder(
                    itemCount: _pedidosEnOrden.length,
                    itemBuilder: (context, index) {
                      Pedido pedido = _pedidosEnOrden[index];
                      return _buildPedidoItem(pedido);
                    },
                  ),
                ),
    );
  }
}
