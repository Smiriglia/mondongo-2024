import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mondongo/models/consulta.dart';
import 'package:mondongo/services/auth_services.dart';
import 'package:mondongo/services/data_service.dart';
import 'package:auto_route/auto_route.dart';
import 'dart:async';

@RoutePage()
class WaiterQueriesPage extends StatefulWidget {
  const WaiterQueriesPage({Key? key}) : super(key: key);

  @override
  _WaiterQueriesPageState createState() => _WaiterQueriesPageState();
}

class _WaiterQueriesPageState extends State<WaiterQueriesPage> {
  final DataService _dataService = GetIt.instance.get<DataService>();
  final AuthService _authService = GetIt.instance.get<AuthService>();
  List<Consulta> _consultas = [];

  @override
  void initState() {
    super.initState();
    _fetchConsultas();
  }

  Future<void> _fetchConsultas() async {
    final consultas = await _dataService.fetchPendingConsultas();
    setState(() {
      _consultas = consultas;
    });
  }

  Future<void> _respondToConsulta(Consulta consulta) async {
    TextEditingController _responseController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Responder Consulta'),
        content: TextField(
          controller: _responseController,
          decoration: InputDecoration(hintText: 'Escriba su respuesta'),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              consulta.respuesta = _responseController.text;
              consulta.estado = 'respondido';
              consulta.fechaRespuesta = DateTime.now();
              consulta.mozoId = _authService.getUser()?.id;

              await _dataService.updateConsulta(consulta);

              Navigator.pop(context);
              _fetchConsultas();
            },
            child: Text('Enviar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultas de Clientes'),
      ),
      body: ListView.builder(
        itemCount: _consultas.length,
        itemBuilder: (context, index) {
          final consulta = _consultas[index];
          return ListTile(
            title: Text('Mesa ${consulta.mesaNumero} - ${consulta.consulta}'),
            subtitle: Text(
                'Fecha: ${consulta.fechaHora.toLocal().toString().split('.').first}'),
            trailing: ElevatedButton(
              onPressed: () => _respondToConsulta(consulta),
              child: Text('Responder'),
            ),
          );
        },
      ),
    );
  }
}
