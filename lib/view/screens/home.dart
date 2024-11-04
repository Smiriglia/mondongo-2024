import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:mondongo/routes/app_router.gr.dart';
import 'package:mondongo/services/auth_services.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = GetIt.instance.get<AuthService>();
    final User? currentUser = authService.getUser();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/icon.png',
              height: 60,
              width: 60,
            ),
            SizedBox(width: 8),
            Text(
              'Restaurante Mondongo',
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
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF4B2C20),
                    Color(0xFF5D4037),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: CircleAvatar(
                                radius: 35,
                                backgroundColor: Colors.brown[200],
                                child: Icon(
                                  Icons.person,
                                  color: Colors.brown[800],
                                  size: 40,
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Bienvenido',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    currentUser?.email?.split('@')[0] ??
                                        'Usuario',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.email,
                                color: Colors.white.withOpacity(0.9),
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                currentUser?.email ?? 'No email',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 1.1,
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
                          title: 'Registrar Dueño/Sup',
                          icon: Icons.supervisor_account,
                          color: Color(0xFF5D4037),
                          onTap: () {
                            context.router
                                .push(const RegisterDuenoSupervisorRoute());
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
                          icon: Icons.table_restaurant,
                          color: Color(0xFF5D4037),
                          onTap: () {
                            context.router.push(const RegisterMesaRoute());
                          },
                        ),
                        _buildMenuCard(
                          context,
                          title: 'Descuentos para Clientes',
                          icon: Icons.percent,
                          color: Color(0xFF5D4037),
                          onTap: () {
                            context.router.push(const RegisterMesaRoute());
                          },
                        ),
                        _buildMenuCard(
                          context,
                          title: 'GPS para Delivery',
                          icon: Icons.gps_fixed,
                          color: Color(0xFF5D4037),
                          onTap: () {
                            context.router.push(const RegisterMesaRoute());
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
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
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: Colors.white),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
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
