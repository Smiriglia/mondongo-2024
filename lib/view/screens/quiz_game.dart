import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class QuizGameRoute extends StatefulWidget {
  final double difficulty;

  const QuizGameRoute({super.key, required this.difficulty});

  @override
  QuizGameState createState() => QuizGameState();
}

class QuizGameState extends State<QuizGameRoute> {
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

  @override
  void initState() {
    super.initState();
    // Ajustar la cantidad de preguntas según la dificultad
  }

  void _confirmAnswer() {
    if (selectedOption == null) {
      // Si no se ha seleccionado ninguna opción, mostrar un mensaje
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Por favor, selecciona una respuesta antes de confirmar.')),
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
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentQuestion >= questions.length) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz Finalizado'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Has completado el quiz!',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              Text(
                'Tu puntuación: $score/${questions.length}',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Volver'),
              ),
            ],
          ),
        ),
      );
    }

    final currentQ = questions[currentQuestion];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz de Preguntas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Pregunta ${currentQuestion + 1}/${questions.length}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              currentQ['questionText'] as String,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ...List.generate((currentQ['answers'] as List<String>).length,
                (index) {
              return ListTile(
                title:
                    Text((currentQ['answers'] as List<String>? ?? [])[index]),
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
                ),
              );
            }),
            const SizedBox(height: 20),
            if (!answered)
              ElevatedButton(
                onPressed: _confirmAnswer,
                child: const Text('Confirmar Respuesta'),
              ),
            if (answered)
              Column(
                children: [
                  Text(
                    selectedOption == questions[currentQuestion]['correct']
                        ? '¡Correcto!'
                        : 'Incorrecto. La respuesta correcta es "${(currentQ['answers'] as List<String>)[questions[currentQuestion]['correct'] as int]}".',
                    style: TextStyle(
                      fontSize: 16,
                      color: selectedOption ==
                              questions[currentQuestion]['correct']
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _nextQuestion,
                    child: const Text('Siguiente Pregunta'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
