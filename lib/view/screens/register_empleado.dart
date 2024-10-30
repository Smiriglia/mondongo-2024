import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mondongo/services/storage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class RegisterEmpleadoPage extends StatefulWidget {
  @override
  _RegisterEmpleadoPageState createState() => _RegisterEmpleadoPageState();
}

class _RegisterEmpleadoPageState extends State<RegisterEmpleadoPage> {
  final _formKey = GlobalKey<FormState>();
  final StorageService _storageService = StorageService();
  final SupabaseClient _client = Supabase.instance.client;

  String _nombre = '';
  String _apellido = '';
  String _dni = '';
  String _cuil = '';
  String _tipoEmpleado = 'cocinero';
  File? _foto;

  final ImagePicker _picker = ImagePicker();

  // Definición de colores y estilos
  final Color primaryColor = Color(0xFF4B2C20); // Marrón oscuro
  final Color accentColor = Colors.white; // Blanco
  final Color backgroundColor = Color(0xFFF0EDE5); // Gris claro

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

  /// Envía el formulario y crea el empleado
  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

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

      debugPrint(
          'Datos del empleado: Nombre=$_nombre, Apellido=$_apellido, DNI=$_dni, CUIL=$_cuil, Tipo=$_tipoEmpleado, FotoURL=$fotoUrl');

      final response = await _client.from('empleados').insert({
        'nombre': _nombre,
        'apellido': _apellido,
        'dni': _dni,
        'cuil': _cuil,
        'foto_url': fotoUrl,
        'tipo_empleado': _tipoEmpleado,
      });

      try {
        if (response.error == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Empleado registrado exitosamente')),
          );
          Navigator.pop(context);
        } else {
          throw Exception(
              'Error al registrar el empleado: ${response.error!.message}');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
        debugPrint('Error al registrar empleado: $e');
      }
    }
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
                  // Nombre
                  TextFormField(
                    decoration: _inputDecoration('Nombre', Icons.person),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Ingresa el nombre' : null,
                    onSaved: (val) => _nombre = val!.trim(),
                  ),
                  SizedBox(height: 16),
                  // Apellido
                  TextFormField(
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
                    decoration: _inputDecoration('DNI', Icons.credit_card),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Ingresa el DNI' : null,
                    onSaved: (val) => _dni = val!.trim(),
                  ),
                  SizedBox(height: 16),
                  // CUIL
                  TextFormField(
                    decoration: _inputDecoration('CUIL', Icons.account_balance),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Ingresa el CUIL' : null,
                    onSaved: (val) => _cuil = val!.trim(),
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
