import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mondongo/services/storage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mondongo/view/screens/qr_reader_page.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
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

  // Colores personalizados
  final Color primaryColor = Color(0xFF4B2C20); // Marrón
  final Color accentColor = Color(0xFFD2B48C); // Canela
  final Color backgroundColor = Color(0xFFF5F5F5); // Gris claro
  final Color textColor = Colors.black87;

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
          SnackBar(
            content: Text(
              'Cliente registrado exitosamente',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: primaryColor,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error al registrar el cliente: ${response.error!.message}',
              style: TextStyle(color: Colors.white),
            ),
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
        title: const Text(
          'Registrar Cliente',
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
                      backgroundImage: _foto != null ? FileImage(_foto!) : null,
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
                  // Nombre
                  TextFormField(
                    decoration: _buildInputDecoration('Nombre'),
                    style: _buildTextStyle(),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Ingresa el nombre' : null,
                    onSaved: (val) => _nombre = val!.trim(),
                  ),
                  const SizedBox(height: 10),
                  // Apellido (solo si no es anónimo)
                  if (!_isAnonymous)
                    TextFormField(
                      decoration: _buildInputDecoration('Apellido'),
                      style: _buildTextStyle(),
                      validator: (val) => val == null || val.isEmpty
                          ? 'Ingresa el apellido'
                          : null,
                      onSaved: (val) => _apellido = val!.trim(),
                    ),
                  if (!_isAnonymous) const SizedBox(height: 10),
                  // DNI (solo si no es anónimo)
                  if (!_isAnonymous)
                    TextFormField(
                      decoration: _buildInputDecoration('DNI').copyWith(
                        suffixIcon: IconButton(
                          icon:
                              Icon(Icons.qr_code_scanner, color: primaryColor),
                          onPressed: () async {
                            // Navega al lector de QR y espera el resultado
                            final qrData = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QRReaderPage(
                                  onQRRead: (data) {
                                    // Procesa el dato leído
                                    _dni = data;
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
                      ),
                      style: _buildTextStyle(),
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Ingresa el DNI' : null,
                      onSaved: (val) => _dni = val!.trim(),
                      keyboardType: TextInputType.number,
                    ),
                  if (!_isAnonymous) const SizedBox(height: 10),
                  // Checkbox para ser anónimo
                  CheckboxListTile(
                    activeColor: primaryColor,
                    title: Text('Registrar como Anónimo',
                        style: _buildTextStyle()),
                    value: _isAnonymous,
                    onChanged: (val) {
                      setState(() {
                        _isAnonymous = val ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
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
                        'Registrar Cliente',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
