// lib/view/screens/splash.dart
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:get_it/get_it.dart';
import 'package:mondongo/routes/app_router.gr.dart';
import 'package:mondongo/services/auth_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key); // Use Key? here

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final AuthService _authService = GetIt.instance.get<AuthService>();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Simulate a loading process
    await Future.delayed(const Duration(seconds: 2));

    User? user = _authService.getUser();
    if (user != null) {
      context.router.replace(const HomeRoute());
    } else {
      context.router.replace(LoginRoute(onResult: (result) {
        if (result) {
          context.router.replace(const HomeRoute());
        } else {
          // Stay on the login page or handle accordingly
        }
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo or image
            Image.asset(
              'assets/splash.png',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
