import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import necesario para inputFormatters
import 'package:auto_route/auto_route.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mondongo/main.dart';
import 'package:mondongo/models/dueno_supervisor.dart';
import 'package:mondongo/services/auth_services.dart';
import 'package:mondongo/services/data_service.dart';
import 'package:mondongo/services/storage_service.dart';
import 'package:mondongo/view/widgets/qr_reader_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  // Controladores de texto
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();

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

  /// Procesa los datos del QR y actualiza los campos
  void _processQRData(String data) {
    final dniData = data.split('@');
    setState(() {
      _apellido = dniData.length > 1 ? dniData[1] : '';
      _nombre = dniData.length > 2 ? dniData[2] : '';
      _dni = dniData.length > 4 ? dniData[4] : '';

      _apellidoController.text = _apellido;
      _nombreController.text = _nombre;
      _dniController.text = _dni;
    });
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        bool dniExist = await _dataService.dniExist(_dni);
        if (dniExist) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: El DNI ya está registrado.')),
          );
          return;
        }

        bool cuilExist = await _dataService.cuilExist(_cuil);
        if (cuilExist) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: El Cuil ya está registrado.')),
          );
          return;
        }

        User? newUser = await _authService.signUpWithEmail(_email, _password);
        if (newUser == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: Ese email ya esta en uso.')),
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
          email: _email,
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
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _dniController.dispose();
    super.dispose();
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
                      controller: _nombreController,
                      decoration: _buildInputDecoration('Nombre'),
                      style: _buildTextStyle(),
                      validator: (val) => val == null || val.isEmpty
                          ? 'Ingresa el nombre'
                          : null,
                      onSaved: (val) => _nombre = val!.trim(),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _apellidoController,
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
                      controller: _dniController,
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
                                    _processQRData(data);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      style: _buildTextStyle(),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(8),
                      ],
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Ingresa el DNI';
                        }
                        if (val.length != 8) {
                          return 'El DNI debe tener exactamente 8 dígitos';
                        }
                        return null;
                      },
                      onSaved: (val) => _dni = val!.trim(),
                    ),
                    const SizedBox(height: 10),
                    // CUIL
                    TextFormField(
                      decoration: _buildInputDecoration('CUIL').copyWith(
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
                                    _processQRData(data);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      style: _buildTextStyle(),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Ingresa el CUIL';
                        }
                        if (val.length != 10) {
                          return 'El CUIL debe tener exactamente 10 dígitos';
                        }
                        return null;
                      },
                      onSaved: (val) => _cuil = val!.trim(),
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
