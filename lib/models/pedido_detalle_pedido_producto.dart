import 'package:json_annotation/json_annotation.dart';
import 'package:mondongo/models/detalle_pedido_producto.dart';
import 'package:mondongo/models/pedido.dart';

part 'pedido_detalle_pedido_producto.g.dart';

@JsonSerializable()
class PedidoDetallePedidoProducto {
  final Pedido pedido;
  final List<DetallePedidoProducto> detallesPedidoProducto;

  PedidoDetallePedidoProducto({
    required this.pedido,
    required this.detallesPedidoProducto,
  });

  factory PedidoDetallePedidoProducto.fromJson(Map<String, dynamic> json) =>
      _$PedidoDetallePedidoProductoFromJson(json);

  Map<String, dynamic> toJson() => _$PedidoDetallePedidoProductoToJson(this);
}