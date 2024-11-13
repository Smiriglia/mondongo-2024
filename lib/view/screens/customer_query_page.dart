// lib/view/screens/customer_query_page.dart

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mondongo/models/consulta.dart';
import 'package:mondongo/services/auth_services.dart';
import 'package:mondongo/services/data_service.dart';
import 'package:auto_route/auto_route.dart';
import 'package:mondongo/services/push_notification_service.dart';

@RoutePage()
class CustomerQueryPage extends StatefulWidget {
  const CustomerQueryPage({Key? key}) : super(key: key);

  @override
  CustomerQueryPageState createState() => CustomerQueryPageState();
}

class CustomerQueryPageState extends State<CustomerQueryPage> {
  final _formKey = GlobalKey<FormState>();
  final DataService _dataService = GetIt.instance.get<DataService>();
  final AuthService _authService = GetIt.instance.get<AuthService>();
  final PushNotificationService _pushNotificationService =
      GetIt.instance.get<PushNotificationService>();

  String _consultaText = '';
  late Future<List<Consulta>> _consultasFuture;

  @override
  void initState() {
    super.initState();
    _loadConsultas();
  }

  void _loadConsultas() {
    final user = _authService.getUser();
    if (user != null) {
      _consultasFuture = _dataService.fetchConsultasByClienteId(user.id);
    } else {
      _consultasFuture = Future.value([]);
    }
  }

  Future<void> _sendConsulta() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final clienteId = _authService.getUser()!.id;
      final mesaNumero = await _getAssignedMesaNumero(clienteId);

      if (mesaNumero == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No tienes una mesa asignada.')),
        );
        return;
      }

      Consulta consulta = Consulta(
        id: '', // ID será generado automáticamente por la base de datos
        mesaNumero: mesaNumero,
        clienteId: clienteId,
        fechaHora: DateTime.now(),
        consulta: _consultaText,
        estado: 'pendiente',
        mozoId: null,
        respuesta: null,
        fechaRespuesta: null,
      );

      try {
        await _dataService.addConsulta(consulta);
        _consultaText = '';
        _formKey.currentState!.reset();
        _loadConsultas();
        setState(() {}); // Actualizar la UI

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Consulta enviada al mozo.')),
        );

        _pushNotificationService.sendNotification(
            topic: 'mozo',
            title: 'Mondongo Consulta',
            body: 'Mesa $mesaNumero: $_consultaText');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error al enviar la consulta: ${e.toString()}')),
        );
      }
    }
  }

  Future<int?> _getAssignedMesaNumero(String clienteId) async {
    final pedido = await _dataService.fetchPedidoByClienteId(clienteId);
    return pedido?.mesaNumero;
  }

  Widget _buildConsultaItem(Consulta consulta) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Consulta:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 4),
            Text(consulta.consulta),
            SizedBox(height: 8),
            Text('Estado: ${consulta.estado}',
                style: TextStyle(
                  color: consulta.estado == 'respondido'
                      ? Colors.green
                      : Colors.orange,
                  fontWeight: FontWeight.bold,
                )),
            if (consulta.estado == 'respondido' && consulta.respuesta != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Text('Respuesta:',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 4),
                  Text(consulta.respuesta!),
                  SizedBox(height: 4),
                  Text(
                    'Fecha de respuesta: ${consulta.fechaRespuesta != null ? consulta.fechaRespuesta!.toLocal().toString().split('.')[0] : 'N/A'}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshConsultas() async {
    _loadConsultas();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mis Consultas',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF4B2C20),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshConsultas,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Formulario para enviar una nueva consulta
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        'Escribe tu consulta al mozo:',
                        style: TextStyle(fontSize: 22),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Escribe aquí...',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Ingrese su consulta' : null,
                        onSaved: (value) => _consultaText = value!,
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _sendConsulta,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF5D4037),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                        child: Text(
                          'Enviar Consulta',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Divider(),
                SizedBox(height: 10),
                // Lista de consultas y respuestas
                FutureBuilder<List<Consulta>>(
                  future: _consultasFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else if (snapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(child: Text('Error: ${snapshot.error}')),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(child: Text('No tienes consultas aún.')),
                      );
                    } else {
                      final consultas = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: consultas.length,
                        itemBuilder: (context, index) {
                          final consulta = consultas[index];
                          return _buildConsultaItem(consulta);
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
