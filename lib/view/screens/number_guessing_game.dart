import 'package:flutter/material.dart';
import 'dart:math';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class NumberGuessingGameRoute extends StatefulWidget {
  final double difficulty;

  const NumberGuessingGameRoute({Key? key, required this.difficulty})
      : super(key: key);

  @override
  _NumberGuessingGameState createState() => _NumberGuessingGameState();
}

class _NumberGuessingGameState extends State<NumberGuessingGameRoute> {
  late int targetNumber;
  late int maxNumber;
  late int maxAttempts;
  int attempts = 0;
  final TextEditingController _controller = TextEditingController();
  String feedback = '';

  @override
  void initState() {
    super.initState();
    // Definir rango y intentos según la dificultad
    if (widget.difficulty <= 1.0) {
      // Fácil
      maxNumber = 50;
      maxAttempts = 5;
    } else if (widget.difficulty <= 1.25) {
      // Mediano
      maxNumber = 75;
      maxAttempts = 3;
    } else {
      // Difícil
      maxNumber = 100;
      maxAttempts = 1;
    }
    targetNumber = Random().nextInt(maxNumber + 1); // Incluye 0 y maxNumber
  }

  void _submitGuess() {
    final guess = int.tryParse(_controller.text);
    if (guess == null) {
      setState(() {
        feedback = 'Por favor, ingresa un número válido.';
      });
      return;
    }

    setState(() {
      attempts += 1;
      if (guess < targetNumber) {
        feedback = 'Demasiado bajo.';
      } else if (guess > targetNumber) {
        feedback = 'Demasiado alto.';
      } else {
        feedback = '¡Correcto! Lo lograste en $attempts intento(s).';
      }

      if (attempts >= maxAttempts && guess != targetNumber) {
        feedback +=
            '\nHas alcanzado el número máximo de intentos. El número era $targetNumber.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool gameOver =
        attempts >= maxAttempts || feedback.startsWith('¡Correcto!');

    return Scaffold(
      appBar: AppBar(
        title: Text('Adivina el Número'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Adivina un número entre 0 y $maxNumber.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Tu Adivinanza',
                border: OutlineInputBorder(),
              ),
              enabled: !gameOver,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: (!gameOver) ? _submitGuess : null,
              child: Text('Adivinar'),
            ),
            SizedBox(height: 20),
            Text(
              feedback,
              style: TextStyle(fontSize: 16, color: Colors.red),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            if (gameOver)
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Volver'),
              ),
          ],
        ),
      ),
    );
  }
}
