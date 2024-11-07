import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mondongo/models/detalle_pedido.dart';
import 'package:mondongo/models/pedido.dart';
import 'package:mondongo/models/producto.dart';
import 'package:mondongo/routes/app_router.gr.dart';
import 'package:mondongo/services/data_service.dart';
import 'package:auto_route/auto_route.dart';
import 'package:mondongo/view/screens/home.dart';

@RoutePage()
class ProductsListPage extends StatefulWidget {
  final Pedido pedido;
  const ProductsListPage({super.key, required this.pedido});

  @override
  ProductsListPageState createState() => ProductsListPageState();
}

class ProductsListPageState extends State<ProductsListPage> {
  final DataService _dataService = GetIt.instance.get<DataService>();
  late Future<List<Producto>> _productosFuture;
  final Map<Producto, int> _cart =
      {}; // Para almacenar los productos y sus cantidades
  bool _isLoading = false; // Loader flag

  @override
  void initState() {
    super.initState();
    _productosFuture = _dataService.fetchProductos();
  }

  double _calculateTotal() {
    return _cart.entries.fold(0, (sum, entry) {
      return sum + (entry.key.precio * entry.value);
    });
  }

  int _calculateEstimatedTime() {
    return _cart.entries.fold(0, (sum, entry) {
      return sum + (entry.key.tiempoElaboracion * entry.value);
    });
  }

  void _addToCart(Producto producto) {
    setState(() {
      _cart[producto] = (_cart[producto] ?? 0) + 1;
    });
  }

  void _removeFromCart(Producto producto) {
    setState(() {
      if (_cart.containsKey(producto) && _cart[producto]! > 0) {
        _cart[producto] = _cart[producto]! - 1;
        if (_cart[producto] == 0) {
          _cart.remove(producto);
        }
      }
    });
  }

  Future<void> _ordenar() async {
    if (_cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, agrega al menos un producto al carrito.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Muestra el loader
    });

    try {
      final router = AutoRouter.of(context);
      for (var producto in _cart.keys) {
        int cantidad = _cart[producto]!;
        final newDetalle = DetallePedido(
          id: '',
          productoId: producto.id,
          pedidoId: widget.pedido.id,
          cantidad: cantidad,
          estado: 'pendiente',
        );
        await _dataService.addDetallePedido(newDetalle);
      }

      widget.pedido.estado = 'orden';
      await _dataService.updatePedido(widget.pedido);

      // Mostrar diálogo de confirmación con botón para navegar a QrScannerRoute
      showDialog(
        context: context,
        barrierDismissible: false, // Evita cerrar el diálogo al tocar fuera
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Orden Completada'),
            content: Text('Tu orden ha sido completada exitosamente.'),
            actions: [
              TextButton(
                onPressed: () async {
                  final router = AutoRouter.of(context);
                  router.removeLast();
                  await router.push(QrScannerRoute());
                },
                child: Text('Escanear QR'),
              ),
            ],
          );
        },
      );

      // Si prefieres navegar directamente sin un botón adicional, puedes usar:
      // router.push(const QrScannerRoute());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al completar la orden: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false; // Oculta el loader
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Productos'),
        backgroundColor: Color(0xFF4B2C20),
      ),
      body: Stack(
        children: [
          FutureBuilder<List<Producto>>(
            future: _productosFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No hay productos disponibles.'));
              } else {
                final productos = snapshot.data!;
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: productos.length,
                        itemBuilder: (context, index) {
                          final producto = productos[index];
                          return Card(
                            margin: EdgeInsets.all(8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      producto.nombre,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF4B2C20),
                                      ),
                                    ),
                                    subtitle: Text(
                                      '${producto.descripcion ?? ''}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                        100, // Altura del slider de imágenes
                                    child: PageView.builder(
                                      itemCount: producto.fotosUrls.length,
                                      itemBuilder: (context, imgIndex) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.network(
                                              producto.fotosUrls[imgIndex],
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Precio: \$${producto.precio.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green[800],
                                          ),
                                        ),
                                        Text(
                                          'Tiempo: ${producto.tiempoElaboracion} min',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.remove),
                                        onPressed: () =>
                                            _removeFromCart(producto),
                                        color: Colors.red,
                                      ),
                                      Text(
                                        '${_cart[producto] ?? 0}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: () => _addToCart(producto),
                                        color: Colors.green,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16.0),
                      color: Color(0xFF4B2C20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total: \$${_calculateTotal().toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Tiempo estimado: ${_calculateEstimatedTime()} min',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: _isLoading ? null : _ordenar,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF5D4037),
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  'Ordenar',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
