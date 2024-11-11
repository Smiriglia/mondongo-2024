// games_screen.dart

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:get_it/get_it.dart';
import 'package:mondongo/routes/app_router.gr.dart';
import 'package:mondongo/services/data_service.dart';
import 'package:mondongo/models/pedido.dart';

@RoutePage()
class GamesScreen extends StatefulWidget {
  final Pedido pedido;

  const GamesScreen({super.key, required this.pedido});

  @override
  GamesScreenState createState() => GamesScreenState();
}

class GamesScreenState extends State<GamesScreen>
    with SingleTickerProviderStateMixin {
  double discount = 0.0;
  double totalPedido = 0.0;
  double finalPrice = 0.0;
  String selectedGame = '';
  double difficulty = 1.0;
  bool winOnFirstAttempt =
      false; // Nueva variable para verificar el primer intento exitoso

  final List<String> games = [
    'Adivina el Número',
    'Quiz de Preguntas',
    'Juego de Taps Rápidos',
  ];

  late AnimationController _controller;
  late Animation<double> _animation;

  final DataService _dataService = GetIt.instance.get<DataService>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
    _fetchTotalPedido();
  }

  Future<void> _fetchTotalPedido() async {
    totalPedido = await _dataService.calcularTotalPedido(widget.pedido.id);
    setState(() {
      finalPrice = totalPedido - (totalPedido * (discount / 100));
    });
  }

  void _selectDiscount(double value) {
    setState(() {
      discount = value;
      difficulty = 1.0 + ((value - 10) / 10) * 0.5;
      finalPrice = totalPedido - (totalPedido * (discount / 100));
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF4B2C20),
        title: Text('Error', style: TextStyle(color: Colors.white)),
        content: Text(message, style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Confirmar', style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }

  void _startGame(String game) async {
    bool? gameResult;

    switch (game) {
      case 'Adivina el Número':
        gameResult = await context.router.push(
          NumberGuessingGameRoute(difficulty: difficulty),
        );
        break;
      case 'Quiz de Preguntas':
        gameResult = await context.router.push(
          QuizGameRoute(difficulty: difficulty),
        );
        break;
      case 'Juego de Taps Rápidos':
        gameResult = await context.router.push(
          TappingGameRoute(difficulty: difficulty),
        );
        break;
      default:
        _showErrorDialog('Juego no encontrado.');
        return;
    }

    if (!mounted) return;

    if (gameResult != null && gameResult) {
      setState(() {
        winOnFirstAttempt = true;
        _applyDiscount();
      });
    }
  }

  void _applyDiscount() async {
    await _dataService.updatePedido(widget.pedido);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF4B2C20),
        title: Text('¡Felicidades!',
            style: TextStyle(color: Colors.white, fontSize: 20.0)),
        content: Text(
          'Has ganado un descuento del $discount%. Total con descuento: \$${finalPrice.toStringAsFixed(2)}',
          style: TextStyle(color: Colors.white70, fontSize: 16.0),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _proceedToSurvey();
            },
            child: Text('Continuar',
                style: TextStyle(color: Colors.white70, fontSize: 16.0)),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountButton(double value) {
    bool isSelected = discount == value;
    return GestureDetector(
      onTap: () => _selectDiscount(value),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orangeAccent : Color(0xFF4B2C20),
          borderRadius: BorderRadius.circular(12.0),
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
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _proceedToSurvey() {
    context.router
        .push(SurveyRouteRoute(pedido: widget.pedido, discount: discount));
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
            fontSize: 20.0,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FadeTransition(
        opacity: _animation,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              if (winOnFirstAttempt)
                Text(
                  '¡Total a Pagar con Descuento!',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.greenAccent,
                  ),
                ),
              Text(
                'Precio Total: \$${totalPedido.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
              Text(
                'Descuento Seleccionado: $discount%',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white70,
                ),
              ),
              Text(
                'Precio Final: \$${finalPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent,
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDiscountButton(10),
                  _buildDiscountButton(15),
                  _buildDiscountButton(20),
                ],
              ),
              SizedBox(height: 24.0),
              Expanded(
                child: ListView.builder(
                  itemCount: games.length,
                  itemBuilder: (context, index) {
                    return FadeTransition(
                      opacity: _animation,
                      child: Card(
                        color: Color(0xFF5A3B28),
                        margin: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 0.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        elevation: 8.0,
                        child: ListTile(
                          leading: Icon(
                            Icons.videogame_asset,
                            color: Colors.white,
                            size: 32.0,
                          ),
                          title: Text(
                            games[index],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
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
                                  horizontal: 20.0, vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              elevation: 5.0,
                            ),
                            child: Text(
                              'Jugar',
                              style: TextStyle(
                                fontSize: 16.0,
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
              if (winOnFirstAttempt)
                ElevatedButton(
                  onPressed: _proceedToSurvey,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 5.0,
                  ),
                  child: Text(
                    'Ir a la Encuesta',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
