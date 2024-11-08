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
    if (widget.difficulty <= 1.0) {
      maxNumber = 50;
      maxAttempts = 5;
    } else if (widget.difficulty <= 1.25) {
      maxNumber = 75;
      maxAttempts = 3;
    } else {
      maxNumber = 100;
      maxAttempts = 1;
    }
    targetNumber = Random().nextInt(maxNumber + 1);
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
        Navigator.pop(context, true); // Gano
        return;
      }

      if (attempts >= maxAttempts && guess != targetNumber) {
        feedback +=
            '\\nHas alcanzado el número máximo de intentos. El número era $targetNumber.';
        Navigator.pop(context, false); // Perdio
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool gameOver =
        attempts >= maxAttempts || feedback.startsWith('¡Correcto!');

    return Scaffold(
      backgroundColor: Color(0xFF5D4037),
      appBar: AppBar(
        backgroundColor: Color(0xFF4B2C20),
        title: Text('Adivina el Número'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Adivina un número entre 0 y $maxNumber.',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Tu Adivinanza',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              enabled: !gameOver,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: (!gameOver) ? _submitGuess : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4B2C20),
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 5.0,
              ),
              child: Text(
                'Adivinar',
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              ),
            ),
            SizedBox(height: 20),
            Text(
              feedback,
              style: TextStyle(fontSize: 18, color: Colors.red),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            if (gameOver)
              ElevatedButton(
                onPressed: () =>
                    Navigator.pop(context, false), // Salir sin ganar
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4B2C20),
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 5.0,
                ),
                child: Text(
                  'Volver',
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
