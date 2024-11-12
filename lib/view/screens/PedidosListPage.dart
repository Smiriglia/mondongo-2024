import 'package:flutter/material.dart';
import 'package:mondongo/services/data_service.dart';
import 'package:mondongo/models/pedido.dart';
import 'package:mondongo/models/mesa.dart';
import 'package:auto_route/auto_route.dart';
import 'dart:async';

@RoutePage()
class PedidosListPage extends StatefulWidget {
  @override
  _PedidosListPageState createState() => _PedidosListPageState();
}

class _PedidosListPageState extends State<PedidosListPage> {
  final DataService dataService = DataService();
  late Future<List<Pedido>> _futurePedidos;

  @override
  void initState() {
    super.initState();
    _futurePedidos = dataService.fetchPendingPedidos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF5D4037),
      appBar: AppBar(
        backgroundColor: Color(0xFF4B2C20),
        title: Text(
          'Asignar Mesas a Pedidos',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Pedido>>(
        future: _futurePedidos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(color: Colors.white));
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error al cargar los pedidos',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final pedidos = snapshot.data ?? [];

          if (pedidos.isEmpty) {
            return Center(
              child: Text(
                'No hay pedidos pendientes',
                style: TextStyle(color: Colors.white, fontSize: 34),
              ),
            );
          }

          return ListView.builder(
            itemCount: pedidos.length,
            itemBuilder: (context, index) {
              final pedido = pedidos[index];
              return Card(
                color: Color(0xFF5A3B28),
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(Icons.restaurant_menu, color: Colors.white),
                  title: Text(
                    'Pedido Numero: ${index + 1}',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Estado: ${pedido.estado}',
                    style: TextStyle(color: Colors.white70),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.assignment_ind, color: Colors.white),
                    onPressed: () => _assignMesaDialog(pedido),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _assignMesaDialog(Pedido pedido) async {
    final mesas = await dataService.fetchAvailableMesas();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 146, 87, 63),
          title: Text(
            'Asignar Mesa',
            style: TextStyle(color: Colors.white),
          ),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: mesas.length,
              itemBuilder: (context, index) {
                final mesa = mesas[index];

                return GestureDetector(
                  onTap: () async {
                    try {
                      await dataService.assignMesaToPedido(
                          pedido.id, mesa.numero);
                      Navigator.of(context).pop(); // Cerrar el diálogo
                      setState(() {
                        _futurePedidos = dataService.fetchPendingPedidos();
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Mesa asignada exitosamente'),
                          backgroundColor: Color(0xFF4B2C20),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: ${e.toString()}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Card(
                    color: Color(0xFF5A3B28),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      leading: mesa.fotoUrl != null
                          ? Image.network(
                              mesa.fotoUrl!,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            )
                          : Icon(
                              Icons.table_restaurant,
                              color: Colors.white,
                              size: 40,
                            ),
                      title: Text(
                        'Mesa ${mesa.numero}',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tipo: ${mesa.tipo}',
                            style: TextStyle(color: Colors.white70),
                          ),
                          Row(
                            children: [
                              Icon(Icons.person,
                                  size: 16, color: Colors.white70),
                              SizedBox(width: 4),
                              Text(
                                '${mesa.cantidadComensales} comensales',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                          Text(
                            'Disponible',
                            style: TextStyle(color: Colors.greenAccent),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancelar',
                style: TextStyle(color: Colors.white70),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
