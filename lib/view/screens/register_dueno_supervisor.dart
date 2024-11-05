import 'dart:io';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mondongo/main.dart';
import 'package:mondongo/models/dueno_supervisor.dart';
import 'package:mondongo/services/auth_services.dart';
import 'package:mondongo/services/data_service.dart';
import 'package:mondongo/services/storage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mondongo/view/screens/qr_reader_page.dart';

@RoutePage()
class RegisterDuenoSupervisorPage extends StatefulWidget {
  @override
  _RegisterDuenoSupervisorPageState createState() =>
      _RegisterDuenoSupervisorPageState();
}

class _RegisterDuenoSupervisorPageState
    extends State<RegisterDuenoSupervisorPage> {
  final _formKey = GlobalKey<FormState>();
  final StorageService _storageService = StorageService();
  final _dataService = getIt.get<DataService>();
  final _authService = getIt.get<AuthService>();

  String _nombre = '';
  String _apellido = '';
  String _dni = '';
  String _cuil = '';
  String _perfil = 'dueño';
  String _email = '';
  String _password = '';
  bool _obscureText = true;
  File? _foto;

  final ImagePicker _picker = ImagePicker();

  // Colores personalizados
  final Color primaryColor = Color(0xFF4B2C20); // Marrón
  final Color accentColor = Color(0xFFD2B48C); // Canela
  final Color backgroundColor = Color(0xFFF5F5F5); // Gris claro
  final Color textColor = Colors.black87;

  Future<void> _pickFoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _foto = File(pickedFile.path);
      });
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        User? newUser = await _authService.signUpWithEmail(_email, _password);
        if (newUser == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Error: No se pudo registrar el usuario.')),
          );
          return;
        }

        String? fotoUrl;
        if (_foto != null) {
          fotoUrl = await _storageService.uploadProfileImage(_foto!);
          if (fotoUrl == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error al subir la foto',
                    style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }
        }

        final dueno = DuenoSupervisor(
          id: newUser.id,
          nombre: _nombre,
          apellido: _apellido,
          dni: _dni,
          cuil: _cuil,
          fotoUrl: fotoUrl,
          rol: _perfil,
          createdAt: DateTime.now(),
        );

        await _dataService.addDuenoSupervisor(dueno);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Registro exitoso', style: TextStyle(color: Colors.white)),
            backgroundColor: primaryColor,
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al registrar: ${e.toString()}',
                style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  InputDecoration _buildInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: primaryColor),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
    );
  }

  TextStyle _buildTextStyle() {
    return TextStyle(color: textColor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text(
            'Registrar Dueño/Supervisor',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: primaryColor,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Foto
                    GestureDetector(
                      onTap: _pickFoto,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: accentColor,
                        backgroundImage:
                            _foto != null ? FileImage(_foto!) : null,
                        child: _foto == null
                            ? Icon(
                                Icons.camera_alt,
                                size: 50,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Campos del formulario
                    TextFormField(
                      decoration: _buildInputDecoration('Nombre'),
                      style: _buildTextStyle(),
                      validator: (val) => val == null || val.isEmpty
                          ? 'Ingresa el nombre'
                          : null,
                      onSaved: (val) => _nombre = val!.trim(),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: _buildInputDecoration('Apellido'),
                      style: _buildTextStyle(),
                      validator: (val) => val == null || val.isEmpty
                          ? 'Ingresa el apellido'
                          : null,
                      onSaved: (val) => _apellido = val!.trim(),
                    ),
                    const SizedBox(height: 10),
// DNI
                    TextFormField(
                      decoration: _buildInputDecoration('DNI').copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.qr_code_scanner,
                            color: primaryColor,
                          ),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QRReaderPage(
                                  onQRRead: (data) {
                                    setState(() {
                                      _dni = data;
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      style: _buildTextStyle(),
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Ingresa el DNI' : null,
                      onSaved: (val) => _dni = val!.trim(),
                      keyboardType: TextInputType.number,
                      controller: TextEditingController(text: _dni),
                    ),

                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: _buildInputDecoration('CUIL'),
                      style: _buildTextStyle(),
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Ingresa el CUIL' : null,
                      onSaved: (val) => _cuil = val!.trim(),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _perfil,
                      items: [
                        DropdownMenuItem(
                          child: Text('Dueño'),
                          value: 'dueño',
                        ),
                        DropdownMenuItem(
                          child: Text('Supervisor'),
                          value: 'supervisor',
                        ),
                      ],
                      onChanged: (val) {
                        setState(() {
                          _perfil = val!;
                        });
                      },
                      decoration: _buildInputDecoration('Perfil'),
                      style: _buildTextStyle(),
                      dropdownColor: backgroundColor,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: _buildInputDecoration('Email'),
                      style: _buildTextStyle(),
                      validator: (val) => val == null || val.isEmpty
                          ? 'Ingresa el email'
                          : null,
                      onSaved: (val) => _email = val!.trim(),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: _buildInputDecoration('Contraseña').copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: primaryColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscureText,
                      style: _buildTextStyle(),
                      validator: (val) => val == null || val.isEmpty
                          ? 'Ingresa la contraseña'
                          : null,
                      onSaved: (val) => _password = val!.trim(),
                    ),
                    const SizedBox(height: 20),
                    // Botón de registrar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Registrar',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ));
  }
}
