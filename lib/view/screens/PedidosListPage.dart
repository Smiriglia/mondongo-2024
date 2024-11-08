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
                style: TextStyle(color: Colors.white),
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
                    'Pedido de Cliente ID: ${pedido.clienteId}',
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
    int? selectedMesaNumero;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 146, 87, 63),
          title: Text(
            'Asignar Mesa',
            style: TextStyle(color: Colors.white),
          ),
          content: DropdownButtonFormField<int>(
            dropdownColor: Color(0xFF4B2C20),
            items: mesas.map((Mesa mesa) {
              return DropdownMenuItem<int>(
                value: mesa.numero,
                child: Text(
                  'Mesa ${mesa.numero} - ${mesa.tipo}',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
            onChanged: (value) {
              selectedMesaNumero = value;
            },
            decoration: InputDecoration(
              labelText: 'Selecciona una mesa',
              labelStyle: TextStyle(color: Colors.white70),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white70),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            style: TextStyle(color: Colors.white),
            iconEnabledColor: Colors.white,
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancelar',
                style: TextStyle(color: Colors.white70),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4B2C20),
              ),
              child: Text('Asignar'),
              onPressed: () async {
                if (selectedMesaNumero == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Debes seleccionar una mesa'),
                      backgroundColor: Color(0xFF4B2C20),
                    ),
                  );
                  return;
                }
                try {
                  await dataService.assignMesaToPedido(
                      pedido.id, selectedMesaNumero!);
                  Navigator.of(context).pop();
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
            ),
          ],
        );
      },
    );
  }
}
