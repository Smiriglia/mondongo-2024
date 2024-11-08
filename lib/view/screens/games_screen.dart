import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../routes/app_router.gr.dart';

@RoutePage()
class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key}); // Constructor actualizado con super.key

  @override
  GamesScreenState createState() =>
      GamesScreenState(); // Clase de estado pública
}

class GamesScreenState extends State<GamesScreen>
    with SingleTickerProviderStateMixin {
  double discount = 0.0;
  String selectedGame = '';
  double difficulty = 1.0;

  // Lista de juegos disponibles
  final List<String> games = [
    'Adivina el Número',
    'Quiz de Preguntas',
    'Juego de Taps Rápidos',
  ];

  // Controlador de animación para la lista de juegos
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _selectDiscount(double value) {
    setState(() {
      discount = value;
      difficulty =
          1.0 + ((value - 10) / 10) * 0.5; // Ajusta según tus necesidades
    });
  }

  void _startGame(String game) {
    // Navegar al juego seleccionado pasando la dificultad
    switch (game) {
      case 'Adivina el Número':
        context.router.push(NumberGuessingGameRoute(difficulty: difficulty));
        break;
      case 'Quiz de Preguntas':
        context.router.push(QuizGameRoute(difficulty: difficulty));
        break;
      case 'Juego de Taps Rápidos':
        context.router.push(TappingGameRoute(difficulty: difficulty));
        break;
      default:
        // Manejar casos inesperados
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Color(0xFF4B2C20),
            title: Text(
              'Error',
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
            content: Text(
              'Juego no encontrado.',
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF5D4037),
      appBar: AppBar(
        backgroundColor: Color(0xFF4B2C20),
        title: Text(
          'Juegos Disponibles',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24.0, // Tamaño de fuente actualizado
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FadeTransition(
        opacity: _animation,
        child: Padding(
          padding: const EdgeInsets.all(24.0), // Padding actualizado
          child: Column(
            children: [
              // Título para la selección de descuento
              Text(
                'Selecciona un Descuento:',
                style: TextStyle(
                  fontSize: 24.0, // Tamaño de fuente actualizado
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16.0), // Espaciado actualizado
              // Botones para seleccionar descuento con animación de escala
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDiscountButton(10),
                  _buildDiscountButton(15),
                  _buildDiscountButton(20),
                ],
              ),
              SizedBox(height: 24.0), // Espaciado actualizado
              // Información sobre el descuento seleccionado y la dificultad
              AnimatedOpacity(
                opacity: discount > 0 ? 1.0 : 0.0,
                duration: Duration(milliseconds: 500),
                child: Text(
                  discount > 0
                      ? 'Descuento Seleccionado: $discount%\nDificultad del Juego: ${difficulty.toStringAsFixed(1)}x'
                      : 'Selecciona un descuento para ver la dificultad',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18.0, // Tamaño de fuente actualizado
                  ),
                ),
              ),
              SizedBox(height: 24.0), // Espaciado actualizado
              // Lista de juegos disponibles con animación de desvanecimiento
              Expanded(
                child: ListView.builder(
                  itemCount: games.length,
                  itemBuilder: (context, index) {
                    return FadeTransition(
                      opacity: _animation,
                      child: Card(
                        color: Color(0xFF5A3B28),
                        margin: EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 0.0), // Margin actualizado
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(16.0), // Bordes redondeados
                        ),
                        elevation: 8.0, // Elevación actualizada
                        child: ListTile(
                          leading: Icon(
                            Icons.videogame_asset,
                            color: Colors.white,
                            size: 32.0, // Tamaño de icono actualizado
                          ),
                          title: Text(
                            games[index],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0, // Tamaño de fuente actualizado
                            ),
                          ),
                          trailing: ElevatedButton(
                            onPressed: discount > 0
                                ? () => _startGame(games[index])
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF4B2C20),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                  vertical: 16.0), // Padding actualizado
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    12.0), // Bordes redondeados
                              ),
                              elevation: 5.0, // Elevación actualizada
                            ),
                            child: Text(
                              'Jugar',
                              style: TextStyle(
                                fontSize: 16.0, // Tamaño de fuente actualizado
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para construir botones de descuento con animación de escala
  Widget _buildDiscountButton(double value) {
    bool isSelected = discount == value;
    return GestureDetector(
      onTap: () => _selectDiscount(value),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
            horizontal: 20.0, vertical: 16.0), // Padding actualizado
        decoration: BoxDecoration(
          color: isSelected ? Colors.orangeAccent : Color(0xFF4B2C20),
          borderRadius: BorderRadius.circular(12.0), // Bordes redondeados
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.orangeAccent.withOpacity(0.6),
                    spreadRadius: 2.0,
                    blurRadius: 8.0,
                    offset: Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            '$value%',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0, // Tamaño de fuente actualizado
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
