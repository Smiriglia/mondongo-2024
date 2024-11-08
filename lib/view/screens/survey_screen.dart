import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get_it/get_it.dart';
import 'package:mondongo/models/encuesta.dart';
import 'package:mondongo/models/pedido.dart';
import 'package:mondongo/routes/app_router.gr.dart';
import 'package:mondongo/services/auth_services.dart';
import 'package:mondongo/services/data_service.dart';

@RoutePage()
class SurveyScreenRoute extends StatefulWidget {
  final Pedido pedido;
  final double discount; // Descuento ganado en la pantalla de juegos
  const SurveyScreenRoute(
      {super.key,
      required this.pedido,
      required this.discount}); // Constructor actualizado con super.key

  @override
  SurveyScreenState createState() =>
      SurveyScreenState(); // Clase de estado pública
}

class SurveyScreenState extends State<SurveyScreenRoute>
    with SingleTickerProviderStateMixin {
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

  // Controlador de animación para el formulario
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
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
        backgroundColor: Color(0xFF4B2C20),
        title: Text(
          'Pedir la Cuenta',
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        content: Text(
          'Tu cuenta ha sido solicitada.',
          style: TextStyle(color: Colors.white70, fontSize: 16.0),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: TextStyle(color: Colors.white70, fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF5D4037), // Fondo principal actualizado
      appBar: AppBar(
        backgroundColor: Color(0xFF4B2C20),
        title: Text(
          'Encuesta del Restaurante',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24.0, // Tamaño de fuente aumentado
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0), // Padding aumentado
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Imagen en la parte superior con animación
                AnimatedContainer(
                  duration: Duration(milliseconds: 800),
                  curve: Curves.easeInOut,
                  height: 280.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/Imagen.jpg'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius:
                        BorderRadius.circular(20.0), // Bordes redondeados
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black45,
                        blurRadius: 10.0,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.0), // Espaciado aumentado
                // Formulario de la encuesta
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Por favor, completa la siguiente encuesta:',
                        style: TextStyle(
                          fontSize: 22.0, // Tamaño de fuente aumentado
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 25.0),
                      Text(
                        '¿Cómo calificarías tu experiencia?',
                        style: TextStyle(
                          fontSize: 18.0, // Tamaño de fuente aumentado
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 15.0),
                      // Widget de calificación con estrellas
                      Center(
                        child: RatingBar.builder(
                          initialRating: satisfaction,
                          minRating: 0,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 6.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            setState(() {
                              satisfaction = rating;
                            });
                          },
                          glow: false,
                          itemSize: 40.0, // Tamaño de estrellas aumentado
                        ),
                      ),
                      SizedBox(height: 30.0),
                      Text(
                        'Déjanos tus Comentarios:',
                        style: TextStyle(
                          fontSize: 18.0, // Tamaño de fuente aumentado
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 15.0),
                      TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          labelText: 'Tus Comentarios',
                          labelStyle: TextStyle(color: Colors.white70),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                12.0), // Bordes redondeados
                            borderSide: BorderSide.none,
                          ),
                        ),
                        maxLines: 4,
                        style: TextStyle(color: Colors.white),
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
                      SizedBox(height: 30.0),
                      // Botón para enviar la encuesta con animación
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isSubmitting ? null : _submitSurvey,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF4B2C20),
                            padding: EdgeInsets.symmetric(
                                vertical: 18.0), // Padding aumentado
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  12.0), // Bordes redondeados
                            ),
                            elevation: 5.0,
                          ),
                          child: isSubmitting
                              ? SizedBox(
                                  height: 24.0,
                                  width: 24.0,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                    strokeWidth: 3.0,
                                  ),
                                )
                              : Text(
                                  'Enviar Encuesta',
                                  style: TextStyle(
                                      fontSize:
                                          18.0, // Tamaño de fuente aumentado
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.0),
                // Botón para pedir la cuenta con animación
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isSurveyCompleted
                        ? () {
                            _requestBill();
                            context.router.push(PaymentRoute(
                                pedido: widget.pedido,
                                discount: widget.discount));
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4B2C20),
                      padding: EdgeInsets.symmetric(
                          vertical: 18.0), // Padding aumentado
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12.0), // Bordes redondeados
                      ),
                      elevation: 5.0,
                    ),
                    child: Text(
                      'Pedir la Cuenta',
                      style: TextStyle(
                        fontSize: 18.0, // Tamaño de fuente aumentado
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
