import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:mondongo/models/cliente.dart';
import 'package:mondongo/services/auth_services.dart';
import 'package:mondongo/services/data_service.dart';
import 'package:mondongo/services/push_notification_service.dart';
import 'package:mondongo/services/storage_service.dart';
import 'package:auto_route/auto_route.dart';
import 'package:mondongo/view/widgets/qr_reader_page.dart';

@RoutePage()
class RegisterPage extends StatefulWidget {
  final Function(bool) onResult;
  const RegisterPage({Key? key, required this.onResult}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService _authService = GetIt.instance<AuthService>();
  final _dataService = GetIt.instance<DataService>();
  final StorageService _storageService = GetIt.instance<StorageService>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureText = true;
  bool _isLoading = false;
  String _errorMessage = '';
  File? _foto;

  final Color primaryColor = Colors.brown[800]!;
  final Color accentColor = Colors.brown[600]!;
  final Color backgroundColor = Colors.brown[100]!;
  final Color textColor = Colors.white;

  final ImagePicker _picker = ImagePicker();

  // Métodos para imagen y QR
  Future<void> _pickFoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null && mounted) {
      setState(() {
        _foto = File(pickedFile.path);
      });
    }
  }

  void _processQRData(String data) {
    final dniData = data.split('@');
    setState(() {
      _apellidoController.text = dniData.length > 1 ? dniData[1] : '';
      _nombreController.text = dniData.length > 2 ? dniData[2] : '';
      _dniController.text = dniData.length > 4 ? dniData[4] : '';
    });
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });
      try {
        bool dniExist = await _dataService.dniExist(_dniController.text.trim());
        if (dniExist) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: El DNI ya está registrado.')),
          );
          setState(() => _isLoading = false);
          return;
        }
        final user = await _authService.signUpWithEmail(
          _emailController.text.trim(),
          _passwordController.text,
        );
        if (user == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error en el registro')),
          );
          setState(() => _isLoading = false);
          return;
        }

        String? fotoUrl;
        if (_foto != null) {
          fotoUrl = await _storageService.uploadProfileImage(_foto!);
          if (fotoUrl == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error al subir la foto')),
            );
            setState(() => _isLoading = false);
            return;
          }
        }

        Cliente newCliente = Cliente(
          id: user.id,
          nombre: _nombreController.text.trim(),
          apellido: _apellidoController.text.trim(),
          dni: _dniController.text.trim(),
          fotoUrl: fotoUrl,
          createdAt: DateTime.now(),
          estado: 'pendiente',
          email: _emailController.text.trim(),
        );

        await _dataService.addCliente(newCliente);
        widget.onResult(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Cliente registrado exitosamente',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: primaryColor,
          ),
        );
        final pushNotificationService =
            GetIt.instance<PushNotificationService>();
        pushNotificationService.sendNotification(
          topic: 'dueno_supervisor',
          title: 'Mondongo',
          body: 'Nuevo Cliente registrado',
        );
      } catch (e) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error: ${e.toString()}';
        });
      }
    }
  }

  InputDecoration _buildInputDecoration(String labelText, {IconData? icon}) {
    return InputDecoration(
      prefixIcon: icon != null ? Icon(icon, color: textColor) : null,
      labelText: labelText,
      labelStyle: TextStyle(color: textColor),
      filled: true,
      fillColor: accentColor.withOpacity(0.5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
    );
  }

  TextStyle _buildTextStyle() {
    return TextStyle(color: textColor);
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _dniController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Card(
            color: primaryColor,
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
                    Icon(Icons.person_add, size: 80, color: textColor),
                    SizedBox(height: 20),
                    Text(
                      'Registrar Cliente',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: _pickFoto,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: accentColor,
                        backgroundImage:
                            _foto != null ? FileImage(_foto!) : null,
                        child: _foto == null
                            ? Icon(Icons.camera_alt, size: 50, color: textColor)
                            : null,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _nombreController,
                      decoration: _buildInputDecoration('Nombre'),
                      style: _buildTextStyle(),
                      validator: (val) => val == null || val.isEmpty
                          ? 'Ingresa el nombre'
                          : null,
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: _apellidoController,
                      decoration: _buildInputDecoration('Apellido'),
                      style: _buildTextStyle(),
                      validator: (val) => val == null || val.isEmpty
                          ? 'Ingresa el apellido'
                          : null,
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: _dniController,
                      decoration: _buildInputDecoration('DNI',
                          icon: Icons.qr_code_scanner),
                      style: _buildTextStyle(),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(8),
                      ],
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Ingresa el DNI';
                        if (val.length != 8)
                          return 'El DNI debe tener exactamente 8 dígitos';
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: _emailController,
                      decoration: _buildInputDecoration('Correo Electrónico',
                          icon: Icons.email),
                      style: _buildTextStyle(),
                      validator: (val) => val == null || !val.contains('@')
                          ? 'Ingresa un email válido'
                          : null,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: _passwordController,
                      decoration: _buildInputDecoration(
                        'Contraseña',
                        icon: _obscureText
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      obscureText: _obscureText,
                      style: _buildTextStyle(),
                      validator: (val) => val == null || val.isEmpty
                          ? 'Ingresa la contraseña'
                          : null,
                    ),
                    SizedBox(height: 20),
                    _isLoading
                        ? CircularProgressIndicator(color: textColor)
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                backgroundColor: accentColor,
                              ),
                              child: Text(
                                'Registrar Cliente',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                    SizedBox(height: 10),
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
}
