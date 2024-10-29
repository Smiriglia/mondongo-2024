import 'dart:io';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mondongo/models/dueno_supervisor.dart';
import 'package:mondongo/services/dueno_supervisor_service.dart';

@RoutePage() // Añade esta línea
class RegisterDuenoSupervisorPage extends StatefulWidget {
  @override
  _RegisterDuenoSupervisorPageState createState() =>
      _RegisterDuenoSupervisorPageState();
}

class _RegisterDuenoSupervisorPageState
    extends State<RegisterDuenoSupervisorPage> {
  final _formKey = GlobalKey<FormState>();
  final DuenoSupervisorService _service = DuenoSupervisorService();

  String _nombre = '';
  String _apellido = '';
  String _dni = '';
  String _cuil = '';
  String _perfil = 'dueño';
  File? _foto;

  final ImagePicker _picker = ImagePicker();

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

      String? fotoUrl;
      if (_foto != null) {
        fotoUrl = await _service.uploadFoto(_foto!, _dni);
        if (fotoUrl == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al subir la foto')),
          );
          return;
        }
      }

      final dueno = DuenoSupervisor(
        id: '', // Será generado por la base de datos
        nombre: _nombre,
        apellido: _apellido,
        dni: _dni,
        cuil: _cuil,
        fotoUrl: fotoUrl,
        perfil: _perfil,
        createdAt: DateTime.now(),
      );

      final success = await _service.crearDuenoSupervisor(dueno);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registro exitoso')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrar')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Registrar Dueño/Supervisor'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Campos del formulario
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Nombre'),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Ingresa el nombre' : null,
                    onSaved: (val) => _nombre = val!.trim(),
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Apellido'),
                    validator: (val) => val == null || val.isEmpty
                        ? 'Ingresa el apellido'
                        : null,
                    onSaved: (val) => _apellido = val!.trim(),
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'DNI'),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Ingresa el DNI' : null,
                    onSaved: (val) => _dni = val!.trim(),
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'CUIL'),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Ingresa el CUIL' : null,
                    onSaved: (val) => _cuil = val!.trim(),
                  ),
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
                    decoration: InputDecoration(labelText: 'Perfil'),
                  ),
                  SizedBox(height: 10),
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
                    child: Text('Registrar'),
                  ),
                ],
              )),
        ));
  }
}
