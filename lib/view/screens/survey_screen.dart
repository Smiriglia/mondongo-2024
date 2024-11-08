// lib/view/screens/survey_screen.dart

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get_it/get_it.dart';
import 'package:mondongo/models/encuesta.dart';
import 'package:mondongo/models/pedido.dart';
import 'package:mondongo/services/auth_services.dart';
import 'package:mondongo/services/data_service.dart';

@RoutePage()
class SurveyScreenRoute extends StatefulWidget {
  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreenRoute> {
  final _formKey = GlobalKey<FormState>();
  bool isSurveyCompleted = false;
  bool isSubmitting = false;

  // Variables de la encuesta
  double satisfaction =
      3.0; // Cambiado a double para soportar calificaciones con decimales
  String comments = '';

  // Instancias de los servicios
  final DataService _dataService = GetIt.instance.get<DataService>();
  final AuthService _authService = GetIt.instance.get<AuthService>();

  void _submitSurvey() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        isSubmitting = true;
      });

      try {
        final user = _authService.getUser();
        if (user == null) {
          throw Exception('Usuario no autenticado.');
        }

        // Obtener el pedido actual del cliente para obtener el número de mesa
        Pedido? pedido = await _dataService.fetchPedidoByClienteId(user.id);

        if (pedido == null || pedido.mesaNumero == null) {
          throw Exception('No tienes una mesa asignada.');
        }

        // Crear la encuesta
        Encuesta encuesta = Encuesta(
          id: '', // Será generado automáticamente por Supabase
          mesaNumero: pedido.mesaNumero!,
          satisfaction: satisfaction,
          comentarios: comments,
          creadoEn: DateTime.now(),
        );

        // Subir la encuesta a la base de datos
        await _dataService.addEncuesta(encuesta);

        setState(() {
          isSurveyCompleted = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Encuesta completada exitosamente.')),
        );

        // Opcional: Navegar a otra pantalla después de completar la encuesta
        // context.router.pop(); // Volver a la pantalla anterior
        // context.router.push(SomeOtherRoute());
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al enviar la encuesta: $e')),
        );
      } finally {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  void _requestBill() {
    // Lógica para pedir la cuenta
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pedir la Cuenta'),
        content: Text('Tu cuenta ha sido solicitada.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Encuesta del Restaurante'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Imagen en la parte superior
            Container(
              height: 280,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/Imagen.jpg'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 20),
            // Formulario de la encuesta
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Text(
                      'Por favor, completa la siguiente encuesta:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '¿Cómo calificarías tu experiencia?',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    // Widget de calificación con estrellas
                    RatingBar.builder(
                      initialRating: satisfaction,
                      minRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          satisfaction = rating;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Dejanos tus Comentarios',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 4,
                      onSaved: (value) {
                        comments = value ?? '';
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, deja tus comentarios.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: isSubmitting ? null : _submitSurvey,
                      child: isSubmitting
                          ? CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : Text('Enviar Encuesta'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isSurveyCompleted ? _requestBill : null,
              child: Text('Pedir la Cuenta'),
            ),
          ],
        ),
      ),
    );
  }
}
