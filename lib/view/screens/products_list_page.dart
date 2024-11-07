import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mondongo/models/producto.dart';
import 'package:mondongo/routes/app_router.gr.dart';
import 'package:mondongo/services/data_service.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class ProductsListPage extends StatefulWidget {
  const ProductsListPage({super.key});

  @override
  ProductsListPageState createState() => ProductsListPageState();
}

class ProductsListPageState extends State<ProductsListPage> {
  final DataService _dataService = GetIt.instance.get<DataService>();
  late Future<List<Producto>> _productosFuture;

  @override
  void initState() {
    super.initState();
    _productosFuture = _dataService.fetchProductos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Productos'),
        actions: [
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: () {
              context.router.push(CustomerQueryRoute());
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Producto>>(
        future: _productosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While data is loading
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If there's an error
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // If no data is available
            return Center(child: Text('No hay productos disponibles.'));
          } else {
            // Display the list of products
            final productos = snapshot.data!;
            return ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, index) {
                final producto = productos[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: producto.fotosUrls.isNotEmpty
                        ? Image.network(
                            producto.fotosUrls.first,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: 50,
                            height: 50,
                            color: Colors.grey,
                            child: Icon(Icons.image_not_supported),
                          ),
                    title: Text(producto.nombre),
                    subtitle: Text(
                      '${producto.descripcion ?? ''}\n'
                      'Precio: \$${producto.precio.toStringAsFixed(2)}\n'
                      'Tiempo de elaboración: ${producto.tiempoElaboracion} min',
                    ),
                    isThreeLine: true,
                    onTap: () {
                      // Navigate to product detail page if implemented
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
