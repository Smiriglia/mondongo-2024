import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mondongo/services/storage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage() // Añade esta línea
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
        debugPrint('URL de la foto: $fotoUrl'); // Log adicional
        if (fotoUrl == null) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al subir la foto')),
          );
          return;
        }
      }

      debugPrint(
          'Datos del empleado: Nombre=$_nombre, Apellido=$_apellido, DNI=$_dni, CUIL=$_cuil, Tipo=$_tipoEmpleado, FotoURL=$fotoUrl'); // Log adicional

      // Crea un nuevo registro en la tabla 'empleados'
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
        debugPrint('Error al registrar empleado: $e'); // Log adicional
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Registrar Empleado'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Nombre
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Nombre'),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Ingresa el nombre' : null,
                    onSaved: (val) => _nombre = val!.trim(),
                  ),
                  // Apellido
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Apellido'),
                    validator: (val) => val == null || val.isEmpty
                        ? 'Ingresa el apellido'
                        : null,
                    onSaved: (val) => _apellido = val!.trim(),
                  ),
                  // DNI
                  TextFormField(
                    decoration: InputDecoration(labelText: 'DNI'),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Ingresa el DNI' : null,
                    onSaved: (val) => _dni = val!.trim(),
                  ),
                  // CUIL
                  TextFormField(
                    decoration: InputDecoration(labelText: 'CUIL'),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Ingresa el CUIL' : null,
                    onSaved: (val) => _cuil = val!.trim(),
                  ),
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
                    decoration: InputDecoration(labelText: 'Tipo de Empleado'),
                  ),
                  SizedBox(height: 10),
                  // Foto
                  _foto != null
                      ? Image.file(_foto!, height: 100)
                      : Text('No se ha seleccionado ninguna foto'),
                  ElevatedButton(
                    onPressed: _pickFoto,
                    child: Text('Tomar Foto'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submit,
                    child: Text('Registrar Empleado'),
                  ),
                ],
              )),
        ));
  }
}
