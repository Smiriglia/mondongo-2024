import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mondongo/main.dart';
import 'package:mondongo/models/cliente.dart';
import 'package:mondongo/routes/app_router.gr.dart';
import 'package:mondongo/services/auth_services.dart';
import 'package:mondongo/services/data_service.dart';
import '../../theme/theme.dart';

@RoutePage()
class RegisterPage extends StatefulWidget {
  final Function(bool) onResult;
  const RegisterPage({super.key, required this.onResult});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService _authService = GetIt.instance<AuthService>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String _email = '';
  String _fullName = '';
  String _errorMessage = '';
  String _dni = '';

  bool _isLoading = false;
  
  DataService _dataService = getIt.get<DataService>();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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
                      'Crear una Cuenta',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person, color: Colors.white),
                        hintText: 'Nombre Completo',
                        hintStyle: TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Colors.brown[600]!.withOpacity(0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                      validator: (val) => val == null || val.isEmpty
                          ? 'Ingresa tu nombre completo'
                          : null,
                      onSaved: (val) => _fullName = val!.trim(),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
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
                      onSaved: (val) => _email = val!.trim(),
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
                      validator: (val) => val == null || val.length < 6
                          ? 'La contraseña debe tener al menos 6 caracteres'
                          : null,
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        prefixIcon:
                            Icon(Icons.lock_outline, color: Colors.white),
                        hintText: 'Confirmar Contraseña',
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
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Confirma tu contraseña';
                        } else if (val != _passwordController.text) {
                          return 'Las contraseñas no coinciden';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _register,
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                backgroundColor: Colors.brown[600],
                              ),
                              child: Text(
                                'Registrarse',
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
                        AutoRouter.of(context).removeLast();
                      },
                      child: Text(
                        '¿Ya tiene una cuenta? Ingresa por aquí',
                        style: TextStyle(color: Colors.white),
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

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      try {
        final user = await _authService.signUpWithEmail(
            _email, _passwordController.text);
        if (user != null) {
          Cliente newCliente = Cliente(
              estado: 'pendiente',
              id: user.id,
              nombre: _fullName,
              apellido: _fullName,
              dni: _dni,
              createdAt: DateTime.now());
          await _dataService.addCliente(newCliente);
          widget.onResult(true);
        } else {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Error en el registro';
          });
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error: ${e.toString()}';
        });
      }
    }
  }
}
