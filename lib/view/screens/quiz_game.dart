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
  int? selectedOption; // Variable para rastrear la opción seleccionada
  bool answered = false; // Indica si la pregunta ha sido respondida

  // Define una lista de preguntas. La dificultad puede agregar más preguntas o más difíciles.
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
    },
    {
      'questionText': '¿Cuál es el elemento químico con el símbolo O?',
      'answers': ['Oro', 'Oxígeno', 'Osmio', 'Oganesón'],
      'correct': 1
    },
    {
      'questionText': '¿En qué año llegó el hombre a la luna?',
      'answers': ['1965', '1969', '1972', '1980'],
      'correct': 1
    },
    {
      'questionText': '¿Cuál es el río más largo del mundo?',
      'answers': ['Nilo', 'Amazonas', 'Yangtsé', 'Misisipi'],
      'correct': 1
    },
    {
      'questionText': '¿Quién pintó la Mona Lisa?',
      'answers': [
        'Vincent van Gogh',
        'Pablo Picasso',
        'Leonardo da Vinci',
        'Claude Monet'
      ],
      'correct': 2
    },
    {
      'questionText': '¿Cuál es el país más grande del mundo?',
      'answers': ['Canadá', 'China', 'Estados Unidos', 'Rusia'],
      'correct': 3
    }
  ];

  // Controlador de animación para las preguntas
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Ajustar la cantidad de preguntas según la dificultad (opcional)
    // Por ejemplo, podrías filtrar o ordenar las preguntas basándote en la dificultad
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
      // Si no se ha seleccionado ninguna opción, mostrar un mensaje
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Por favor, selecciona una respuesta antes de confirmar.'),
            backgroundColor: Colors.red),
      );
      return;
    }

    // Verificar la respuesta
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
      return Scaffold(
        backgroundColor: Color(0xFF4B2C20),
        appBar: AppBar(
          backgroundColor: Color(0xFF4B2C20),
          title: const Text(
            'Quiz Finalizado',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '¡Has completado el quiz!',
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20.0),
                Text(
                  'Tu puntuación: $score/${questions.length}',
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 30.0),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4B2C20),
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    'Volver',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final currentQ = questions[currentQuestion];

    return Scaffold(
      backgroundColor: Color(0xFF5D4037), // Fondo principal actualizado
      appBar: AppBar(
        backgroundColor: Color(0xFF4B2C20),
        title: const Text(
          'Quiz de Preguntas',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0, // Tamaño de fuente aumentado
            fontWeight: FontWeight.bold,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pregunta ${currentQuestion + 1}/${questions.length}',
                  style: const TextStyle(
                    fontSize: 22.0, // Tamaño de fuente aumentado
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20.0),
                Text(
                  currentQ['questionText'] as String,
                  style: const TextStyle(
                    fontSize: 20.0, // Tamaño de fuente aumentado
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30.0),
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
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0, // Tamaño de fuente aumentado
                        ),
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
                const SizedBox(height: 30.0),
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
                          fontSize: 18.0, // Tamaño de fuente aumentado
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
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
                          fontSize: 18.0, // Tamaño de fuente aumentado
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
                            fontSize: 18.0, // Tamaño de fuente aumentado
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
