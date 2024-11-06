import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import necesario para inputFormatters
import 'package:image_picker/image_picker.dart';
import 'package:mondongo/main.dart';
import 'package:mondongo/models/empleado.dart';
import 'package:mondongo/services/auth_services.dart';
import 'package:mondongo/services/data_service.dart';
import 'package:mondongo/services/storage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:auto_route/auto_route.dart';
import 'package:mondongo/view/screens/qr_reader_page.dart';

@RoutePage()
class RegisterEmpleadoPage extends StatefulWidget {
  @override
  _RegisterEmpleadoPageState createState() => _RegisterEmpleadoPageState();
}

class _RegisterEmpleadoPageState extends State<RegisterEmpleadoPage> {
  final _formKey = GlobalKey<FormState>();
  final StorageService _storageService = StorageService();
  final _dataService = getIt.get<DataService>();
  final _authService = getIt.get<AuthService>();

  String _nombre = '';
  String _apellido = '';
  String _dni = '';
  String _cuil = '';
  String _tipoEmpleado = 'cocinero';
  String _email = '';
  String _password = '';
  bool _obscureText = true;
  File? _foto;

  final ImagePicker _picker = ImagePicker();

  // Controladores de texto
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();

  // Definición de colores y estilos
  final Color primaryColor = Color(0xFF4B2C20);
  final Color accentColor = Colors.white;
  final Color backgroundColor = Color(0xFFF0EDE5);

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: primaryColor),
      prefixIcon: Icon(icon, color: primaryColor),
      filled: true,
      fillColor: accentColor,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: accentColor,
      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      padding: EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  /// Selecciona una foto desde la cámara
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

  /// Envía el formulario y crea el empleado
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
          debugPrint('URL de la foto: $fotoUrl');
          if (fotoUrl == null) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error al subir la foto')),
            );
            return;
          }
        }

        Empleado newEmpleado = Empleado(
          id: newUser.id,
          nombre: _nombre,
          apellido: _apellido,
          fotoUrl: fotoUrl,
          dni: _dni,
          cuil: _cuil,
          tipoEmpleado: _tipoEmpleado,
          createdAt: DateTime.now(),
          email: _email,
        );

        debugPrint(
            'Datos del empleado: Nombre=$_nombre, Apellido=$_apellido, DNI=$_dni, CUIL=$_cuil, Tipo=$_tipoEmpleado, FotoURL=$fotoUrl');

        try {
          final response = await _dataService.addEmpleado(newEmpleado);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Empleado registrado exitosamente')),
          );
          Navigator.pop(context);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Error al registrar el empleado: ${e.toString()}')),
          );
          debugPrint('Error al registrar empleado: $e');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear el usuario: ${e.toString()}')),
        );
        debugPrint('Error al crear el usuario: $e');
      }
    }
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
            'Registrar Empleado',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: primaryColor,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  SizedBox(height: 5),
                  // Nombre
                  TextFormField(
                    controller: _nombreController,
                    decoration: _inputDecoration('Nombre', Icons.person),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Ingresa el nombre' : null,
                    onSaved: (val) => _nombre = val!.trim(),
                  ),
                  SizedBox(height: 16),
                  // Apellido
                  TextFormField(
                    controller: _apellidoController,
                    decoration:
                        _inputDecoration('Apellido', Icons.person_outline),
                    validator: (val) => val == null || val.isEmpty
                        ? 'Ingresa el apellido'
                        : null,
                    onSaved: (val) => _apellido = val!.trim(),
                  ),
                  SizedBox(height: 16),
                  // DNI
                  TextFormField(
                    controller: _dniController,
                    decoration:
                        _inputDecoration('DNI', Icons.credit_card).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(Icons.qr_code_scanner, color: primaryColor),
                        onPressed: () async {
                          final String? scannedData = await Navigator.push(
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
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(8),
                    ],
                  ),
                  SizedBox(height: 16),
                  // CUIL
                  TextFormField(
                    decoration: _inputDecoration('CUIL', Icons.account_balance)
                        .copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(Icons.qr_code_scanner, color: primaryColor),
                        onPressed: () async {
                          final String? scannedData = await Navigator.push(
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
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: _inputDecoration('Correo', Icons.email),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Ingresa el correo' : null,
                    onSaved: (val) => _email = val!.trim(),
                  ),
                  SizedBox(height: 16),
                  // Contraseña
                  TextFormField(
                    decoration:
                        _inputDecoration('Contraseña', Icons.lock).copyWith(
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
                    validator: (val) => val == null || val.isEmpty
                        ? 'Ingresa la contraseña'
                        : null,
                    onSaved: (val) => _password = val!.trim(),
                  ),
                  SizedBox(height: 16),
                  // Tipo de Empleado
                  DropdownButtonFormField<String>(
                    value: _tipoEmpleado,
                    items: [
                      DropdownMenuItem(
                          child: Text('Cocinero'), value: 'cocinero'),
                      DropdownMenuItem(
                          child: Text('Bartender'), value: 'bartender'),
                      DropdownMenuItem(child: Text('Mesero'), value: 'mesero'),
                      DropdownMenuItem(child: Text('Otro'), value: 'otro'),
                    ],
                    onChanged: (val) {
                      setState(() {
                        _tipoEmpleado = val!;
                      });
                    },
                    decoration:
                        _inputDecoration('Tipo de Empleado', Icons.work),
                  ),
                  SizedBox(height: 16),
                  // Foto
                  _foto != null
                      ? Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(_foto!, height: 150),
                          ),
                        )
                      : Center(
                          child: Text(
                            'No se ha seleccionado ninguna foto',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _pickFoto,
                    icon: Icon(Icons.camera_alt),
                    label: Text('Tomar Foto'),
                    style: _buttonStyle(),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _submit,
                    child: Text('Registrar Empleado'),
                    style: _buttonStyle(),
                  ),
                ],
              )),
        ));
  }
}
