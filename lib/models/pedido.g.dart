// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pedido.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pedido _$PedidoFromJson(Map<String, dynamic> json) => Pedido(
      id: json['id'] as String,
      clienteId: json['clienteId'] as String,
      mesaNumero: (json['mesaNumero'] as num).toInt(),
      estado: json['estado'] as String,
      fecha: DateTime.parse(json['fecha'] as String),
    );

Map<String, dynamic> _$PedidoToJson(Pedido instance) => <String, dynamic>{
      'id': instance.id,
      'clienteId': instance.clienteId,
      'mesaNumero': instance.mesaNumero,
      'estado': instance.estado,
      'fecha': instance.fecha.toIso8601String(),
    };
