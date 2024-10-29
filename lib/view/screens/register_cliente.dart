import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mondongo/services/storage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mondongo/view/screens/qr_reader_page.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage() // Añade esta línea
class RegisterClientePage extends StatefulWidget {
  const RegisterClientePage({Key? key}) : super(key: key);

  @override
  _RegisterClientePageState createState() => _RegisterClientePageState();
}

class _RegisterClientePageState extends State<RegisterClientePage> {
  final _formKey = GlobalKey<FormState>();
  final StorageService _storageService = StorageService();
  final SupabaseClient _client = Supabase.instance.client;

  String _nombre = '';
  String _apellido = '';
  String _dni = '';
  bool _isAnonymous = false;
  File? _foto;

  final ImagePicker _picker = ImagePicker();

  /// Selecciona una foto desde la cámara
  Future<void> _pickFoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      if (!mounted) return; // Verifica si el widget sigue montado
      setState(() {
        _foto = File(pickedFile.path);
      });
    }
  }

  /// Envía el formulario y crea el cliente
  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String? fotoUrl;
      if (_foto != null) {
        fotoUrl = await _storageService.uploadProfileImage(
          _foto!,
        );
        if (fotoUrl == null) {
          if (!mounted) return; // Verifica antes de usar 'context'
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al subir la foto')),
          );
          return;
        }
      }

      // Crea un nuevo registro en la tabla 'clientes'
      final response = await _client.from('clientes').insert({
        'nombre': _nombre,
        'apellido': _isAnonymous ? null : _apellido,
        'dni': _isAnonymous ? null : _dni,
        'foto_url': fotoUrl,
        'is_anonymous': _isAnonymous,
      });

      if (!mounted) return; // Verifica antes de usar 'context'

      if (response.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cliente registrado exitosamente')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Error al registrar el cliente: ${response.error!.message}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Cliente'), // Añade 'const'
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // Nombre
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Nombre'), // 'const'
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Ingresa el nombre' : null,
                  onSaved: (val) => _nombre = val!.trim(),
                ),
                // Apellido (solo si no es anónimo)
                if (!_isAnonymous)
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Apellido'), // 'const'
                    validator: (val) =>
                        !_isAnonymous && (val == null || val.isEmpty)
                            ? 'Ingresa el apellido'
                            : null,
                    onSaved: (val) => _apellido = val!.trim(),
                  ),
                // DNI (solo si no es anónimo)
                if (!_isAnonymous)
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'DNI'), // 'const'
                          validator: (val) =>
                              !_isAnonymous && (val == null || val.isEmpty)
                                  ? 'Ingresa el DNI'
                                  : null,
                          onSaved: (val) => _dni = val!.trim(),
                        ),
                      ),
                      // IconButton para QR Reader
                      IconButton(
                        icon: const Icon(Icons.qr_code_scanner), // 'const'
                        onPressed: () async {
                          // Navega al lector de QR y espera el resultado
                          final qrData = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QRReaderPage(
                                onQRRead: (data) {
                                  // Procesa el dato leído
                                  _dni =
                                      data; // Suponiendo que el QR contiene el DNI
                                },
                              ),
                            ),
                          );
                          if (qrData != null && qrData.isNotEmpty) {
                            if (!mounted)
                              return; // Verifica antes de usar 'context'
                            setState(() {
                              _dni = qrData;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                // Checkbox para ser anónimo
                CheckboxListTile(
                  title: const Text('Registrar como Anónimo'), // 'const'
                  value: _isAnonymous,
                  onChanged: (val) {
                    setState(() {
                      _isAnonymous = val ?? false;
                    });
                  },
                ),
                const SizedBox(height: 10), // 'const'
                // Foto
                _foto != null
                    ? Image.file(_foto!, height: 100)
                    : const Text(
                        'No se ha seleccionado ninguna foto'), // 'const'
                ElevatedButton(
                  onPressed: _pickFoto,
                  child: const Text('Tomar Foto'), // 'const'
                ),
                const SizedBox(height: 20), // 'const'
                ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Registrar Cliente'), // 'const'
                ),
              ],
            )),
      ),
    );
  }
}
