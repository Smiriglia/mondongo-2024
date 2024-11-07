import 'package:json_annotation/json_annotation.dart';

part 'detalle_pedido.g.dart';

@JsonSerializable()
class DetallePedido {
  final String id;
  final String pedidoId;
  final String productoId;
  final int cantidad;
  final String estado;
  final DateTime? fechaInicio;
  final DateTime? fechaFinalizado;

  DetallePedido({
    required this.id,
    required this.pedidoId,
    required this.productoId,
    required this.cantidad,
    required this.estado,
    this.fechaInicio,
    this.fechaFinalizado,
  });

  factory DetallePedido.fromJson(Map<String, dynamic> json) =>
      _$DetallePedidoFromJson(json);

  Map<String, dynamic> toJson() => _$DetallePedidoToJson(this);
}
