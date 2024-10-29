import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mondongo/services/qr_service.dart';
import 'package:mondongo/services/storage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class RegisterMesaPage extends StatefulWidget {
  @override
  _RegisterMesaPageState createState() => _RegisterMesaPageState();
}

class _RegisterMesaPageState extends State<RegisterMesaPage> {
  final _formKey = GlobalKey<FormState>();
  final StorageService _storageService = StorageService();
  final QRService _qrService = QRService();
  final SupabaseClient _client = Supabase.instance.client;

  int _numero = 0;
  int _cantidadComensales = 1;
  String _tipoMesa = 'estándar';
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

  /// Envía el formulario y crea la mesa
  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Genera el código QR (por ejemplo, usando el número de mesa)
      String qrData = 'Mesa-$_numero';
      String qrPathName = 'mesas/mesa_$_numero';

      String? qrUrl = await _qrService.generateAndUploadQRCode(
          qrData, 'qr_codes', qrPathName);
      if (qrUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al generar el código QR')),
        );
        return;
      }

      // Sube la foto de la mesa
      String? fotoUrl;
      if (_foto != null) {
        fotoUrl = await _storageService.uploadProfileImage(_foto!);
        if (fotoUrl == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al subir la foto')),
          );
          return;
        }
      }

      // Crea un nuevo registro en la tabla 'mesas'
      final response = await _client.from('mesas').insert({
        'numero': _numero,
        'cantidad_comensales': _cantidadComensales,
        'tipo': _tipoMesa,
        'foto_url': fotoUrl,
        'qr_code_url': qrUrl,
      });

      if (response.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Mesa registrada exitosamente')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Error al registrar la mesa: ${response.error!.message}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Registrar Mesa'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Número de Mesa
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Número de Mesa'),
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (val == null || val.isEmpty)
                        return 'Ingresa el número de mesa';
                      if (int.tryParse(val) == null)
                        return 'Ingresa un número válido';
                      return null;
                    },
                    onSaved: (val) => _numero = int.parse(val!.trim()),
                  ),
                  // Cantidad de Comensales
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: 'Cantidad de Comensales'),
                    keyboardType: TextInputType.number,
                    initialValue: '1',
                    validator: (val) {
                      if (val == null || val.isEmpty)
                        return 'Ingresa la cantidad de comensales';
                      if (int.tryParse(val) == null)
                        return 'Ingresa un número válido';
                      return null;
                    },
                    onSaved: (val) =>
                        _cantidadComensales = int.parse(val!.trim()),
                  ),
                  // Tipo de Mesa
                  DropdownButtonFormField<String>(
                    value: _tipoMesa,
                    items: [
                      DropdownMenuItem(child: Text('VIP'), value: 'VIP'),
                      DropdownMenuItem(
                          child: Text('Discapacitados'),
                          value: 'discapacitados'),
                      DropdownMenuItem(
                          child: Text('Estándar'), value: 'estándar'),
                      DropdownMenuItem(child: Text('Otro'), value: 'otro'),
                    ],
                    onChanged: (val) {
                      setState(() {
                        _tipoMesa = val!;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Tipo de Mesa'),
                  ),
                  SizedBox(height: 10),
                  // Foto de la Mesa
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
                    child: Text('Registrar Mesa'),
                  ),
                ],
              )),
        ));
  }
}
