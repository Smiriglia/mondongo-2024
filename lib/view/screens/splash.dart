// lib/view/screens/splash.dart
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:get_it/get_it.dart';
import 'package:mondongo/routes/app_router.gr.dart';
import 'package:mondongo/services/auth_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../theme/theme.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  final AuthService _authService = GetIt.instance.get<AuthService>();

  late AnimationController _logoController;
  late Animation<double> _logoAnimation;

  late AnimationController _utensilsController;
  late Animation<double> _knifeAnimation;
  late Animation<double> _forkAnimation;

  late AnimationController _plateController;
  late Animation<double> _plateAnimation;

  late AnimationController _textController;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _textFadeAnimation;

  @override
  void initState() {
    super.initState();

    // Animación del Logo
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _logoAnimation =
        CurvedAnimation(parent: _logoController, curve: Curves.easeInOut);
    _logoController.forward();

    // Animación de Utensilios (Cuchillo y Tenedor)
    _utensilsController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _knifeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _utensilsController,
          curve: Interval(0.0, 0.5, curve: Curves.easeIn)),
    );

    _forkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _utensilsController,
          curve: Interval(0.5, 1.0, curve: Curves.easeIn)),
    );

    _utensilsController.forward();

    // Animación del Plato
    _plateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _plateAnimation =
        CurvedAnimation(parent: _plateController, curve: Curves.easeInOut);
    _plateController.forward();

    // Animación del Texto
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeInOut),
    );

    _textFadeAnimation =
        CurvedAnimation(parent: _textController, curve: Curves.easeIn);
    _textController.forward();

    // Inicializar la navegación después de un retraso
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Simular un proceso de carga
    await Future.delayed(const Duration(seconds: 4));

    User? user = _authService.getUser();
    if (user != null) {
      context.router.replace(const HomeRoute());
    } else {
      context.router.replace(LoginRoute(onResult: (result) {
        if (result) {
          context.router.replace(const HomeRoute());
        } else {
          // Manejar según sea necesario
        }
      }));
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _utensilsController.dispose();
    _plateController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Fondo con un gradiente sutil
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryLight, AppColors.background],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo con animación de escala y fade-in
                FadeTransition(
                  opacity: _logoAnimation,
                  child: ScaleTransition(
                    scale: _logoAnimation,
                    child: Image.asset(
                      'assets/icon.png',
                      width: 250,
                      height: 250,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Animación de platos que aparecen
                FadeTransition(
                  opacity: _plateAnimation,
                  child: Image.asset(
                    'assets/1.png',
                    width: 100,
                    height: 100,
                  ),
                ),
                const SizedBox(height: 20),
                // Animación de utensilios: cuchillo y tenedor girando
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeTransition(
                      opacity: _knifeAnimation,
                      child: RotationTransition(
                        turns: Tween<double>(begin: 0.0, end: 1.0)
                            .animate(_utensilsController),
                        child: Image.asset(
                          'assets/2.png',
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    FadeTransition(
                      opacity: _forkAnimation,
                      child: RotationTransition(
                        turns: Tween<double>(begin: 0.0, end: -1.0)
                            .animate(_utensilsController),
                        child: Image.asset(
                          'assets/3.png',
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                // Animación de texto: Nombre del restaurante
                SlideTransition(
                  position: _textSlideAnimation,
                  child: FadeTransition(
                    opacity: _textFadeAnimation,
                    child: Text(
                      'Mondongo Div - 2',
                      style: AppTypography.headline1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
