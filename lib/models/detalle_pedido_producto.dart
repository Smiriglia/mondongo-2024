import 'package:json_annotation/json_annotation.dart';
import 'detalle_pedido.dart';
import 'producto.dart';

part 'detalle_pedido_producto.g.dart';

@JsonSerializable()
class DetallePedidoProducto {
  final DetallePedido detallePedido;
  final Producto producto;

  DetallePedidoProducto({
    required this.detallePedido,
    required this.producto,
  });

  factory DetallePedidoProducto.fromJson(Map<String, dynamic> json) =>
      _$DetallePedidoProductoFromJson(json);

  Map<String, dynamic> toJson() => _$DetallePedidoProductoToJson(this);
}