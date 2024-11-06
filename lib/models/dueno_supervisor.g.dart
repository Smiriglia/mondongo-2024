// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dueno_supervisor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DuenoSupervisor _$DuenoSupervisorFromJson(Map<String, dynamic> json) =>
    DuenoSupervisor(
      cuil: json['cuil'] as String,
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      apellido: json['apellido'] as String,
      dni: json['dni'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      email: json['email'] as String,
      rol: json['rol'] as String? ?? 'dueño/supervisor',
      fotoUrl: json['fotoUrl'] as String?,
    );

Map<String, dynamic> _$DuenoSupervisorToJson(DuenoSupervisor instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'apellido': instance.apellido,
      'dni': instance.dni,
      'fotoUrl': instance.fotoUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'rol': instance.rol,
      'email': instance.email,
      'cuil': instance.cuil,
    };
