// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dueno_supervisor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DuenoSupervisor _$DuenoSupervisorFromJson(Map<String, dynamic> json) =>
    DuenoSupervisor(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      apellido: json['apellido'] as String,
      dni: json['dni'] as String,
      cuil: json['cuil'] as String,
      fotoUrl: json['fotoUrl'] as String?,
      perfil: json['perfil'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$DuenoSupervisorToJson(DuenoSupervisor instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'apellido': instance.apellido,
      'dni': instance.dni,
      'cuil': instance.cuil,
      'fotoUrl': instance.fotoUrl,
      'perfil': instance.perfil,
      'createdAt': instance.createdAt.toIso8601String(),
    };
