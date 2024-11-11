// lib/view/screens/waiter_queries_page.dart

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mondongo/models/consulta.dart';
import 'package:mondongo/services/auth_services.dart';
import 'package:mondongo/services/data_service.dart';
import 'package:auto_route/auto_route.dart';
import 'dart:async';

@RoutePage()
class WaiterQueriesPage extends StatefulWidget {
  const WaiterQueriesPage({super.key}); // Constructor actualizado con super.key

  @override
  WaiterQueriesPageState createState() =>
      WaiterQueriesPageState(); // Clase de estado pública
}

class WaiterQueriesPageState extends State<WaiterQueriesPage>
    with SingleTickerProviderStateMixin {
  final DataService _dataService = GetIt.instance.get<DataService>();
  final AuthService _authService = GetIt.instance.get<AuthService>();
  List<Consulta> _consultas = [];

  // Controlador de animación para las consultas
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fetchConsultas();

    _controller = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
        backgroundColor: Color(0xFF4B2C20),
        title: Text(
          'Responder Consulta',
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        content: TextField(
          controller: _responseController,
          decoration: InputDecoration(
            hintText: 'Escriba su respuesta',
            hintStyle: TextStyle(color: Colors.white70),
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            ),
          ),
          style: TextStyle(color: Colors.white),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (_responseController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('La respuesta no puede estar vacía.'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              consulta.respuesta = _responseController.text.trim();
              consulta.estado = 'respondido';
              consulta.fechaRespuesta = DateTime.now();
              consulta.mozoId = _authService.getUser()?.id;

              await _dataService.updateConsulta(consulta);

              Navigator.pop(context);
              _fetchConsultas();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Consulta respondida exitosamente.'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text(
              'Enviar',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF5D4037),
      appBar: AppBar(
        backgroundColor: Color(0xFF4B2C20),
        title: Text(
          'Consultas de Clientes',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24.0, // Tamaño de fuente aumentado
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: _consultas.isEmpty
          ? Center(
              child: Text(
                'No hay consultas pendientes.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 22,
                ),
              ),
            )
          : FadeTransition(
              opacity: _fadeAnimation,
              child: RefreshIndicator(
                onRefresh: _fetchConsultas,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _consultas.length,
                  itemBuilder: (context, index) {
                    final consulta = _consultas[index];
                    return Card(
                      color: Color(0xFF5A3B28),
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 6.0,
                      child: ListTile(
                        leading: Icon(
                          Icons.question_answer,
                          color: Colors.white,
                          size: 32.0,
                        ),
                        title: Text(
                          'Mesa ${consulta.mesaNumero}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0, // Tamaño de fuente aumentado
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          consulta.consulta,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16.0, // Tamaño de fuente aumentado
                          ),
                        ),
                        trailing: ElevatedButton(
                          onPressed: consulta.estado == 'pendiente'
                              ? () => _respondToConsulta(consulta)
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF4B2C20),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 12.0), // Padding aumentado
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            elevation: 5.0,
                          ),
                          child: Text(
                            'Responder',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0, // Tamaño de fuente aumentado
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}
