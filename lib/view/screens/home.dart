import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mondongo/routes/app_router.gr.dart';
import 'package:mondongo/services/auth_services.dart';
import 'package:get_it/get_it.dart';
import '../../theme/theme.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = GetIt.instance.get<AuthService>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        title: Text('Inicio', style: TextStyle(color: AppColors.onPrimary)),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: AppColors.onPrimary),
            onPressed: () async {
              await authService.signOut();
              context.router.replace(LoginRoute(onResult: (result) {}));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          children: [
            _buildMenuCard(
              context,
              title: 'Registrar Empleado',
              icon: Icons.person_add,
              color: AppColors.primaryLight,
              onTap: () {
                context.router.push(const RegisterEmpleadoRoute());
              },
            ),
            _buildMenuCard(
              context,
              title: 'Registrar Dueño/Supervisor',
              icon: Icons.admin_panel_settings,
              color: AppColors.primaryLight,
              onTap: () {
                context.router.push(const RegisterDuenoSupervisorRoute());
              },
            ),
            _buildMenuCard(
              context,
              title: 'Registrar Cliente',
              icon: Icons.person_outline,
              color: AppColors.primaryLight,
              onTap: () {
                context.router.push(const RegisterClienteRoute());
              },
            ),
            _buildMenuCard(
              context,
              title: 'Registrar Mesa',
              icon: Icons.table_chart,
              color: AppColors.primaryLight,
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
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 50, color: AppColors.onBackground),
              SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTypography.bodyText1.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.onBackground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
