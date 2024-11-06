// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'empleado.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Empleado _$EmpleadoFromJson(Map<String, dynamic> json) => Empleado(
      cuil: json['cuil'] as String,
      tipoEmpleado: json['tipoEmpleado'] as String,
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      apellido: json['apellido'] as String,
      dni: json['dni'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      email: json['email'] as String,
      rol: json['rol'] as String? ?? 'empleado',
      fotoUrl: json['fotoUrl'] as String?,
    );

Map<String, dynamic> _$EmpleadoToJson(Empleado instance) => <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'apellido': instance.apellido,
      'dni': instance.dni,
      'fotoUrl': instance.fotoUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'rol': instance.rol,
      'email': instance.email,
      'cuil': instance.cuil,
      'tipoEmpleado': instance.tipoEmpleado,
    };
