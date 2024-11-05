// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cliente.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cliente _$ClienteFromJson(Map<String, dynamic> json) => Cliente(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      apellido: json['apellido'] as String,
      dni: json['dni'] as String,
      fotoUrl: json['fotoUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      estado: json['estado'] as String,
    );

Map<String, dynamic> _$ClienteToJson(Cliente instance) => <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'apellido': instance.apellido,
      'dni': instance.dni,
      'fotoUrl': instance.fotoUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'estado': instance.estado,
    };
