// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consulta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Consulta _$ConsultaFromJson(Map<String, dynamic> json) => Consulta(
      id: json['id'] as String,
      mesaNumero: (json['mesa_numero'] as num).toInt(),
      clienteId: json['cliente_id'] as String,
      fechaHora: DateTime.parse(json['fecha_hora'] as String),
      consulta: json['consulta'] as String,
      estado: json['estado'] as String,
      mozoId: json['mozo_id'] as String?,
      respuesta: json['respuesta'] as String?,
      fechaRespuesta: json['fecha_respuesta'] == null
          ? null
          : DateTime.parse(json['fecha_respuesta'] as String),
    );

Map<String, dynamic> _$ConsultaToJson(Consulta instance) => <String, dynamic>{
      'id': instance.id,
      'mesa_numero': instance.mesaNumero,
      'cliente_id': instance.clienteId,
      'fecha_hora': instance.fechaHora.toIso8601String(),
      'consulta': instance.consulta,
      'estado': instance.estado,
      'mozo_id': instance.mozoId,
      'respuesta': instance.respuesta,
      'fecha_respuesta': instance.fechaRespuesta?.toIso8601String(),
    };
