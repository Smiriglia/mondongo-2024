// lib/view/screens/register.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mondongo/routes/app_router.gr.dart';
import 'package:mondongo/services/auth_services.dart';

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

  // Controladores para las contraseñas
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String _email = '';
  String _fullName = '';
  String _errorMessage = '';

  bool _isLoading = false;

  @override
  void dispose() {
    // Liberar los controladores cuando el widget se elimine
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    // Campo para el Nombre Completo
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Nombre Completo'),
                      validator: (val) => val == null || val.isEmpty
                          ? 'Ingresa tu nombre completo'
                          : null,
                      onSaved: (val) => _fullName = val!.trim(),
                    ),
                    const SizedBox(height: 10),
                    // Campo para el Email
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) => val == null || !val.contains('@')
                          ? 'Ingresa un email válido'
                          : null,
                      onSaved: (val) => _email = val!.trim(),
                    ),
                    const SizedBox(height: 10),
                    // Campo para la Contraseña
                    TextFormField(
                      controller: _passwordController,
                      decoration:
                          const InputDecoration(labelText: 'Contraseña'),
                      obscureText: true,
                      validator: (val) => val == null || val.length < 6
                          ? 'La contraseña debe tener al menos 6 caracteres'
                          : null,
                    ),
                    const SizedBox(height: 10),
                    // Campo para Confirmar la Contraseña
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: const InputDecoration(
                          labelText: 'Confirmar Contraseña'),
                      obscureText: true,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Confirma tu contraseña';
                        } else if (val != _passwordController.text) {
                          return 'Las contraseñas no coinciden';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Botón de Registro
                    ElevatedButton(
                      onPressed: _register,
                      child: const Text('Registrarse'),
                    ),
                    const SizedBox(height: 10),
                    // Mensaje de Error
                    if (_errorMessage.isNotEmpty)
                      Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    // Botón para Navegar al Login
                    TextButton(
                      onPressed: () {
                        // Navegar al login
                        AutoRouter.of(context)
                            .replace(RegisterRoute(onResult: widget.onResult));
                      },
                      child: const Text('¿Ya tienes una cuenta? Inicia sesión'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      // Guardar los campos del formulario
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      try {
        // Registrarse con Email y Contraseña
        final user = await _authService.signUpWithEmail(
            _email, _passwordController.text);
        if (user != null) {
          // Crear el perfil del usuario en la tabla 'profiles'
          await _authService.createUserProfile(
            id: user.id,
            email: _email,
            fullName: _fullName,
          );

          // Informar al caller que el registro fue exitoso
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
