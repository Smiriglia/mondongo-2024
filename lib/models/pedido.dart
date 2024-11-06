import 'package:json_annotation/json_annotation.dart';

part 'pedido.g.dart';

@JsonSerializable()
class Pedido {
  final String id;
  final String clienteId;
  final int mesaNumero;
  final String estado;
  final DateTime fecha;

  Pedido({
    required this.id,
    required this.clienteId,
    required this.mesaNumero,
    required this.estado,
    required this.fecha,
  });

  // Método para generar una instancia de Pedido desde JSON
  factory Pedido.fromJson(Map<String, dynamic> json) => _$PedidoFromJson(json);

  // Método para convertir una instancia de Pedido a JSON
  Map<String, dynamic> toJson() => _$PedidoToJson(this);
}
