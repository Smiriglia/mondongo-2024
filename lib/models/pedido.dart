import 'package:json_annotation/json_annotation.dart';

part 'pedido.g.dart';

@JsonSerializable()
class Pedido {
  String id;
  String clienteId;
  int? mesaNumero;
  String estado;
  DateTime fecha;

  Pedido({
    required this.id,
    required this.clienteId,
    this.mesaNumero,
    required this.estado,
    required this.fecha,
  });

  // Método para generar una instancia de Pedido desde JSON
  factory Pedido.fromJson(Map<String, dynamic> json) => _$PedidoFromJson(json);

  // Método para convertir una instancia de Pedido a JSON
  Map<String, dynamic> toJson() => _$PedidoToJson(this);
}
