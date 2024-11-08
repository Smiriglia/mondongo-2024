import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:auto_route/auto_route.dart';
import 'package:mondongo/models/producto.dart';
import 'package:mondongo/services/data_service.dart';
import 'package:mondongo/services/qr_service.dart';
import 'package:mondongo/services/storage_service.dart';

@RoutePage()
class CreateProductPage extends StatefulWidget {
  const CreateProductPage({Key? key}) : super(key: key);

  @override
  _CreateProductPageState createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final _formKey = GlobalKey<FormState>();
  final DataService _dataService = GetIt.instance.get<DataService>();
  final StorageService _storageService = GetIt.instance.get<StorageService>();
  final QRService _qrService = GetIt.instance.get<QRService>();

  String _nombre = '';
  String? _descripcion;
  int _tiempoElaboracion = 0;
  double _precio = 0.0;
  String _sector = 'cocina'; // Valor predeterminado
  List<File> _images = [];
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  // Colores y estilos
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

  Future<void> _pickImages() async {
    final images = await _picker.pickMultiImage();

    if (images != null && images.length == 3) {
      setState(() {
        _images = images.map((fileX) => File(fileX.path)).toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, selecciona exactamente 3 imágenes.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate() && _images.length == 3) {
      _formKey.currentState!.save();
      setState(() => _isLoading = true);

      try {
        List<String> imageUrls = await _uploadImages(_images);
        String qrCodeUrl = await _generateQr(_nombre);

        Producto newProduct = Producto(
          id: '',
          nombre: _nombre,
          descripcion: _descripcion,
          tiempoElaboracion: _tiempoElaboracion,
          precio: _precio,
          fotosUrls: imageUrls,
          qrCodeUrl: qrCodeUrl,
          createdAt: DateTime.now(),
          sector: _sector,
        );

        await _dataService.addProducto(newProduct);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Producto registrado exitosamente')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al registrar el producto: ${e.toString()}'),
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<List<String>> _uploadImages(List<File> images) async {
    List<String>? imageUrls = await _storageService.uploadProductImages(images);
    if (imageUrls == null) throw Exception('Error al subir las imágenes');
    return imageUrls;
  }

  Future<String> _generateQr(String name) async {
    String? qrUrl = await _qrService.generateAndUploadQRCode(
      'producto-$name',
      'qr_codes',
      'productos/$name',
    );
    if (qrUrl == null) throw Exception('Error al generar el código QR');
    return qrUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Crear Producto',
          style: TextStyle(color: accentColor),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    SizedBox(height: 5),
                    TextFormField(
                      decoration: _inputDecoration('Nombre', Icons.edit),
                      validator: (value) => value!.isEmpty
                          ? 'Ingrese el nombre del producto'
                          : null,
                      onSaved: (value) => _nombre = value!,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: _inputDecoration(
                          'Descripción', Icons.description),
                      onSaved: (value) => _descripcion = value,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: _inputDecoration(
                          'Tiempo de Elaboración (min)', Icons.timer),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty
                          ? 'Ingrese el tiempo de elaboración'
                          : null,
                      onSaved: (value) =>
                          _tiempoElaboracion = int.parse(value!),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration:
                          _inputDecoration('Precio', Icons.attach_money),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value!.isEmpty ? 'Ingrese el precio' : null,
                      onSaved: (value) => _precio = double.parse(value!),
                    ),
                    SizedBox(height: 16),

                    // Select de Sector
                    DropdownButtonFormField<String>(
                      value: _sector,
                      items: [
                        DropdownMenuItem(
                          child: Text('Cocina'),
                          value: 'cocina',
                        ),
                        DropdownMenuItem(
                          child: Text('Bar'),
                          value: 'bar',
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _sector = value!;
                        });
                      },
                      decoration:
                          _inputDecoration('Sector', Icons.kitchen),
                    ),

                    SizedBox(height: 16),

                    // Mostrar imágenes seleccionadas
                    _images.isNotEmpty
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _images
                                .map((image) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          image,
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ))
                                .toList(),
                          )
                        : Center(
                            child: Text(
                              'No se han seleccionado imágenes',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                    SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _pickImages,
                      icon: Icon(Icons.photo_library),
                      label: Text('Seleccionar 3 Imágenes'),
                      style: _buttonStyle(),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _saveProduct,
                      child: Text('Guardar Producto'),
                      style: _buttonStyle(),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
