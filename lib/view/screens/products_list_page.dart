import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mondongo/models/detalle_pedido.dart';
import 'package:mondongo/models/pedido.dart';
import 'package:mondongo/models/producto.dart';
import 'package:mondongo/routes/app_router.gr.dart';
import 'package:mondongo/services/data_service.dart';
import 'package:auto_route/auto_route.dart';
import 'package:mondongo/services/push_notification_service.dart';
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
  final PushNotificationService _pushNotificationService =
      GetIt.instance.get<PushNotificationService>();
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
    if (_cart.isEmpty) return 0;

    return _cart.entries.map((entry) {
      return entry.key.tiempoElaboracion * entry.value;
    }).reduce((maxTime, currentTime) =>
        maxTime > currentTime ? maxTime : currentTime);
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
        title: Text(
          'Lista de Productos',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF4B2C20),
        actions: [
          IconButton(
            icon: Icon(Icons.chat, color: Colors.white),
            onPressed: () {
              AutoRouter.of(context).push(CustomerQueryRoute());
            },
            tooltip: 'Consulta al Mozo',
          ),
        ],
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
                return Center(
                    child: Text(
                  'No hay productos disponibles.',
                  style: TextStyle(fontSize: 20),
                ));
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
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF4B2C20),
                                      ),
                                    ),
                                    subtitle: Text(
                                      '${producto.descripcion ?? ''}',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 300,
                                    child: PageView.builder(
                                      itemCount: producto.fotosUrls.length,
                                      itemBuilder: (context, imgIndex) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: SizedBox(
                                              width: double
                                                  .infinity, // Asegura el ancho completo
                                              height:
                                                  300, // Mantiene la altura establecida
                                              child: Image.network(
                                                producto.fotosUrls[imgIndex],
                                                fit: BoxFit
                                                    .cover, // Asegura que la imagen ocupe todo el espacio disponible
                                              ),
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
                                          style: TextStyle(fontSize: 18),
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
                                'Estimado: ${_calculateEstimatedTime()} min',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white70,
                                ),
                              ),
                              Text(
                                'TOTAL: \$${_calculateTotal().toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
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
