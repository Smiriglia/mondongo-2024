// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detalle_pedido.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetallePedido _$DetallePedidoFromJson(Map<String, dynamic> json) =>
    DetallePedido(
      id: json['id'] as String,
      pedidoId: json['pedidoId'] as String,
      productoId: json['productoId'] as String,
      cantidad: (json['cantidad'] as num).toInt(),
      estado: json['estado'] as String,
      fechaInicio: json['fechaInicio'] == null
          ? null
          : DateTime.parse(json['fechaInicio'] as String),
      fechaFinalizado: json['fechaFinalizado'] == null
          ? null
          : DateTime.parse(json['fechaFinalizado'] as String),
    );

Map<String, dynamic> _$DetallePedidoToJson(DetallePedido instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pedidoId': instance.pedidoId,
      'productoId': instance.productoId,
      'cantidad': instance.cantidad,
      'estado': instance.estado,
      'fechaInicio': instance.fechaInicio?.toIso8601String(),
      'fechaFinalizado': instance.fechaFinalizado?.toIso8601String(),
    };
