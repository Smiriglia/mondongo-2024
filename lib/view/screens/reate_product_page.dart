import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mondongo/models/producto.dart';
import 'package:mondongo/services/data_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:auto_route/auto_route.dart';
import 'dart:async';

@RoutePage()
class CreateProductPage extends StatefulWidget {
  const CreateProductPage({Key? key}) : super(key: key);

  @override
  _CreateProductPageState createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final _formKey = GlobalKey<FormState>();
  final DataService _dataService = GetIt.instance.get<DataService>();

  String _nombre = '';
  String? _descripcion;
  int _tiempoElaboracion = 0;
  double _precio = 0.0;
  List<XFile> _images = [];

  Future<void> _pickImages() async {
    final ImagePicker _picker = ImagePicker();
    final images = await _picker.pickMultiImage();

    if (images != null && images.length == 3) {
      setState(() {
        _images = images;
      });
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select exactly 3 images.')),
      );
    }
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate() && _images.length == 3) {
      _formKey.currentState!.save();

      // Upload images and get URLs (implementation depends on your storage solution)
      List<String> imageUrls = await _uploadImages(_images);

      Producto newProduct = Producto(
        id: '', // ID will be generated by the database
        nombre: _nombre,
        descripcion: _descripcion,
        tiempoElaboracion: _tiempoElaboracion,
        precio: _precio,
        fotosUrls: imageUrls,
        qrCodeUrl: null,
        createdAt: DateTime.now(),
      );

      await _dataService.addProducto(newProduct);

      // Navigate back or show success message
      Navigator.pop(context);
    }
  }

  Future<List<String>> _uploadImages(List<XFile> images) async {
    // Implement your image upload logic here
    // For now, let's return dummy URLs
    return images.map((_) => 'https://example.com/image.jpg').toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese el nombre' : null,
                onSaved: (value) => _nombre = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Descripción'),
                onSaved: (value) => _descripcion = value,
              ),
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Tiempo de Elaboración (min)'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese el tiempo' : null,
                onSaved: (value) =>
                    _tiempoElaboracion = int.parse(value ?? '0'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese el precio' : null,
                onSaved: (value) => _precio = double.parse(value ?? '0'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImages,
                child: Text('Seleccionar 3 Imágenes'),
              ),
              SizedBox(height: 10),
              _images.isNotEmpty
                  ? Text('${_images.length} imágenes seleccionadas.')
                  : Text('No hay imágenes seleccionadas.'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProduct,
                child: Text('Guardar Producto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
