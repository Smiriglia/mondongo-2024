import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:mondongo/routes/app_router.gr.dart';
import 'package:mondongo/services/auth_services.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = GetIt.instance.get<AuthService>();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/icon.png',
              height: 32,
              width: 32,
            ),
            SizedBox(width: 8),
            Text(
              'Restaurante La Mondongo',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Color(0xFF4B2C20),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              final router = AutoRouter.of(context);
              await authService.signOut();
              router.reevaluateGuards();
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[500],
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            _buildMenuCard(
              context,
              title: 'Registrar Empleado',
              icon: Icons.person_add,
              color: Color(0xFF5D4037),
              onTap: () {
                context.router.push(const RegisterEmpleadoRoute());
              },
            ),
            _buildMenuCard(
              context,
              title: 'Registrar Dueño/Supervisor',
              icon: Icons.admin_panel_settings,
              color: Color(0xFF5D4037),
              onTap: () {
                context.router.push(const RegisterDuenoSupervisorRoute());
              },
            ),
            _buildMenuCard(
              context,
              title: 'Registrar Cliente',
              icon: Icons.person_outline,
              color: Color(0xFF5D4037),
              onTap: () {
                context.router.push(const RegisterClienteRoute());
              },
            ),
            _buildMenuCard(
              context,
              title: 'Registrar Mesa',
              icon: Icons.table_chart,
              color: Color(0xFF5D4037),
              onTap: () {
                context.router.push(const RegisterMesaRoute());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context,
      {required String title,
      required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
