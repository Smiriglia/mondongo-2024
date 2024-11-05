// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'empleado.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Empleado _$EmpleadoFromJson(Map<String, dynamic> json) => Empleado(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      apellido: json['apellido'] as String,
      dni: json['dni'] as String,
      cuil: json['cuil'] as String,
      fotoUrl: json['fotoUrl'] as String?,
      tipoEmpleado: json['tipoEmpleado'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$EmpleadoToJson(Empleado instance) => <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'apellido': instance.apellido,
      'dni': instance.dni,
      'cuil': instance.cuil,
      'fotoUrl': instance.fotoUrl,
      'tipoEmpleado': instance.tipoEmpleado,
      'createdAt': instance.createdAt.toIso8601String(),
    };
