import 'dart:math';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'dart:async';

@RoutePage()
class TappingGameRoute extends StatefulWidget {
  final double difficulty;

  const TappingGameRoute({Key? key, required this.difficulty})
      : super(key: key);

  @override
  _TappingGameState createState() => _TappingGameState();
}

class _TappingGameState extends State<TappingGameRoute> {
  int score = 0;
  Timer? timer;
  int timeLeft = 10;
  List<Offset> targets = [];
  final double targetSize = 50.0;

  @override
  void initState() {
    super.initState();
    timeLeft = (10 - (widget.difficulty - 1) * 3).toInt();
    _startGame();
  }

  void _startGame() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (timeLeft <= 0) {
        t.cancel();
        _endGame();
      } else {
        setState(() {
          timeLeft -= 1;
          final random = Random();
          final x = random.nextDouble() *
              (MediaQuery.of(context).size.width - targetSize);
          final y = random.nextDouble() *
                  (MediaQuery.of(context).size.height - targetSize - 100) +
              100;
          targets.add(Offset(x, y));
        });
      }
    });
  }

  void _endGame() {
    bool won = score >= 5;
    Navigator.pop(context, won);
  }

  void _tapTarget(int index) {
    setState(() {
      score += 1;
      targets.removeAt(index);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF5D4037),
      appBar: AppBar(
        backgroundColor: Color(0xFF4B2C20),
        title: Text('Juego de Taps Rápidos'),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 20,
            left: 20,
            child: Column(
              children: [
                Text('Puntuación: $score',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                SizedBox(height: 10),
                Text('Tiempo: $timeLeft s',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              ],
            ),
          ),
          ...targets.asMap().entries.map((entry) {
            int idx = entry.key;
            Offset pos = entry.value;
            return Positioned(
              left: pos.dx,
              top: pos.dy,
              child: GestureDetector(
                onTap: () => _tapTarget(idx),
                child: Container(
                  width: targetSize,
                  height: targetSize,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
