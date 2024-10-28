import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mondongo/services/auth_services.dart';
import 'package:get_it/get_it.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = GetIt.instance.get<AuthService>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () async {
              var router = AutoRouter.of(context);
              await authService
                  .signOut(); // Make sure authService is properly defined
              router.reevaluateGuards(); // Reevaluates route guards
            },
            child: Icon(
                Icons.menu), // Add a child widget, such as an icon or button
          ),
        ),
      ),
      body: Center(
        child: const Text('Home'),
      ),
    );
  }
}
