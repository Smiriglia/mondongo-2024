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
      appBar: AppBar(
        title: Text('Asignar Mesas a Pedidos'),
      ),
      body: FutureBuilder<List<Pedido>>(
        future: _futurePedidos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar los pedidos'));
          }

          final pedidos = snapshot.data ?? [];

          if (pedidos.isEmpty) {
            return Center(child: Text('No hay pedidos pendientes'));
          }

          return ListView.builder(
            itemCount: pedidos.length,
            itemBuilder: (context, index) {
              final pedido = pedidos[index];
              return ListTile(
                title: Text('Pedido de Cliente ID: ${pedido.clienteId}'),
                subtitle: Text('Estado: ${pedido.estado}'),
                trailing: IconButton(
                  icon: Icon(Icons.assignment_ind),
                  onPressed: () => _assignMesaDialog(pedido),
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
          title: Text('Asignar Mesa'),
          content: DropdownButtonFormField<int>(
            items: mesas.map((Mesa mesa) {
              return DropdownMenuItem<int>(
                value: mesa.numero,
                child: Text('Mesa ${mesa.numero} - ${mesa.tipo}'),
              );
            }).toList(),
            onChanged: (value) {
              selectedMesaNumero = value;
            },
            decoration: InputDecoration(
              labelText: 'Selecciona una mesa',
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text('Asignar'),
              onPressed: () async {
                if (selectedMesaNumero == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Debes seleccionar una mesa')),
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
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())),
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
