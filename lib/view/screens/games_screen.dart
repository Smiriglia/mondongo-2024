// lib/view/screens/games_screen.dart
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../routes/app_router.gr.dart'; // Asegúrate de importar el archivo generado

@RoutePage()
class GamesScreen extends StatefulWidget {
  const GamesScreen({Key? key}) : super(key: key);

  @override
  _GamesScreenState createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  double discount = 0.0;
  String selectedGame = '';
  double difficulty = 1.0;

  // Lista de juegos disponibles
  final List<String> games = [
    'Adivina el Número',
    'Quiz de Preguntas',
    'Juego de Taps Rápidos',
  ];

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
            title: Text('Error'),
            content: Text('Juego no encontrado.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Juegos Disponibles'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Selecciona un Descuento:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => _selectDiscount(10),
                    child: Text('10%'),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectDiscount(15),
                    child: Text('15%'),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectDiscount(20),
                    child: Text('20%'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                discount > 0
                    ? 'Descuento Seleccionado: $discount%\nDificultad del Juego: ${difficulty.toStringAsFixed(1)}x'
                    : 'Selecciona un descuento para ver la dificultad',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: games.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(games[index]),
                      trailing: ElevatedButton(
                        onPressed: discount > 0
                            ? () => _startGame(games[index])
                            : null,
                        child: Text('Jugar'),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
