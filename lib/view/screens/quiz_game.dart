// lib/view/screens/quiz_game_route.dart

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class QuizGameRoute extends StatefulWidget {
  final double difficulty;

  const QuizGameRoute({super.key, required this.difficulty});

  @override
  QuizGameState createState() => QuizGameState();
}

class QuizGameState extends State<QuizGameRoute>
    with SingleTickerProviderStateMixin {
  int currentQuestion = 0;
  int score = 0;
  int? selectedOption;
  bool answered = false;

  final List<Map<String, Object>> questions = [
    {
      'questionText': '¿Cuál es la capital de Francia?',
      'answers': ['Berlín', 'Madrid', 'París', 'Lisboa'],
      'correct': 2
    },
    {
      'questionText': '¿Cuál es el planeta más grande del sistema solar?',
      'answers': ['Tierra', 'Júpiter', 'Saturno', 'Marte'],
      'correct': 1
    },
    {
      'questionText': '¿Quién escribió "Romeo y Julieta"?',
      'answers': [
        'Miguel de Cervantes',
        'William Shakespeare',
        'Gabriel García Márquez',
        'Jane Austen'
      ],
      'correct': 1
    }
  ];

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _confirmAnswer() {
    if (selectedOption == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Por favor, selecciona una respuesta antes de confirmar.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (selectedOption == questions[currentQuestion]['correct']) {
      score += 1;
    }

    setState(() {
      answered = true;
    });
  }

  void _nextQuestion() {
    setState(() {
      currentQuestion += 1;
      selectedOption = null;
      answered = false;
      _controller.reset();
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentQuestion >= questions.length) {
      bool won = score >= (questions.length / 2).round();
      Navigator.pop(context, won);
      return Container();
    }

    final currentQ = questions[currentQuestion];

    return Scaffold(
      backgroundColor: Color(0xFF5D4037),
      appBar: AppBar(
        backgroundColor: Color(0xFF4B2C20),
        title: const Text(
          'Quiz de Preguntas',
          style: TextStyle(
              color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pregunta ${currentQuestion + 1}/${questions.length}',
                style: const TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 20.0),
              Text(
                currentQ['questionText'] as String,
                style: const TextStyle(fontSize: 20.0, color: Colors.white),
              ),
              SizedBox(height: 30.0),
              ...List.generate((currentQ['answers'] as List<String>).length,
                  (index) {
                return Card(
                  color: Color(0xFF5A3B28),
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 4.0,
                  child: ListTile(
                    title: Text(
                      (currentQ['answers'] as List<String>)[index],
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                    leading: Radio<int>(
                      value: index,
                      groupValue: selectedOption,
                      onChanged: answered
                          ? null
                          : (int? value) {
                              setState(() {
                                selectedOption = value;
                              });
                            },
                      activeColor: Colors.amber,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                );
              }),
              SizedBox(height: 30.0),
              if (!answered)
                Center(
                  child: ElevatedButton(
                    onPressed: _confirmAnswer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4B2C20),
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 5.0,
                    ),
                    child: const Text(
                      'Confirmar Respuesta',
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              if (answered)
                Column(
                  children: [
                    Text(
                      selectedOption == questions[currentQuestion]['correct']
                          ? '¡Correcto!'
                          : 'Incorrecto. La respuesta correcta es "${(currentQ['answers'] as List<String>)[questions[currentQuestion]['correct'] as int]}".',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: selectedOption ==
                                questions[currentQuestion]['correct']
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: _nextQuestion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4B2C20),
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 5.0,
                      ),
                      child: const Text(
                        'Siguiente Pregunta',
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
