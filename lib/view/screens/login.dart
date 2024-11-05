import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mondongo/models/cliente.dart';
import 'package:mondongo/models/profile.dart';
import 'package:mondongo/routes/app_router.gr.dart';
import 'package:mondongo/services/auth_services.dart';
import 'package:mondongo/services/data_service.dart';
import '../../theme/theme.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  final Function(bool) onResult;
  const LoginPage({Key? key, required this.onResult}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = GetIt.instance<AuthService>();
  final DataService _dataService = GetIt.instance<DataService>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Card(
            color: Colors.brown[800],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.restaurant, size: 80, color: Colors.white),
                    SizedBox(height: 20),
                    Text(
                      'Bienvenido a Mondongo',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email, color: Colors.white),
                        hintText: 'Correo Electrónico',
                        hintStyle: TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Colors.brown[600]!.withOpacity(0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.white),
                      validator: (val) => val == null || !val.contains('@')
                          ? 'Ingresa un email válido'
                          : null,
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock, color: Colors.white),
                        hintText: 'Contraseña',
                        hintStyle: TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Colors.brown[600]!.withOpacity(0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      obscureText: true,
                      style: TextStyle(color: Colors.white),
                      validator: (val) => val == null || val.isEmpty
                          ? 'Ingresa tu contraseña'
                          : null,
                    ),
                    SizedBox(height: 20),
                    _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                backgroundColor: Colors.brown[600],
                              ),
                              child: Text(
                                'Iniciar Sesión',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        final router = AutoRouter.of(context);
                        router.push(RegisterRoute(onResult: (result) {
                          router.removeLast();
                        }));
                      },
                      child: Text(
                        '¿No tienes una cuenta? Regístrate aquí',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Quick login buttons
                    Text(
                      'Iniciar sesión rápido:',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildQuickLoginButton(
                            'cliente@gmail.com', '112233', 'cliente'),
                        _buildQuickLoginButton(
                            'empleado@gmail.com', '112233', 'empleado'),
                        _buildQuickLoginButton(
                            'supervisor@gmail.com', '112233', 'supervisor'),
                      ],
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: double
                          .infinity, // Para que el botón ocupe todo el ancho disponible
                      child: ElevatedButton(
                        onPressed: _loginAnonymously,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          backgroundColor: Colors.grey[600],
                        ),
                        child: Text(
                          'Ingresar como invitado',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    if (_errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          _errorMessage,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickLoginButton(String email, String password, String role) {
    return SizedBox(
      // width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _emailController.text = email;
            _passwordController.text = password;
          });
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          backgroundColor: Colors.brown[700],
        ),
        child: Image.asset(
          'assets/login/$role.png',
          color: Colors.white,
          width: 30,
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      try {
        final user = await _authService.signInWithEmail(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        if (user != null) {
          Profile? profile = await _dataService.fetchProfileById(user.id);
          if (profile != null) {
            if (profile is Cliente && profile.estado != 'aprobado') {
              throw Exception('Cliente no aprobado');
            }
            _authService.profile = profile;
            widget.onResult(true);
          }
        } else {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Error en el inicio de sesión';
          });
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'Error: ${e.toString().replaceAll('Exception: ', '')}';
        });
      }
    }
  }

  Future<void> _loginAnonymously() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final user = await _authService.signInAnonymously();
      if (user != null) {
        _authService.profile = null;
        widget.onResult(true);
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error en el inicio de sesión anónimo';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: ${e.toString().replaceAll('Exception: ', '')}';
      });
    }
  }
}
