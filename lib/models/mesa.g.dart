// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mesa.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mesa _$MesaFromJson(Map<String, dynamic> json) => Mesa(
      numero: (json['numero'] as num).toInt(),
      cantidadComensales: (json['cantidadComensales'] as num).toInt(),
      tipo: $enumDecode(_$TipoMesaEnumMap, json['tipo']),
      fotoUrl: json['fotoUrl'] as String?,
      qrCodeUrl: json['qrCodeUrl'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$MesaToJson(Mesa instance) => <String, dynamic>{
      'numero': instance.numero,
      'cantidadComensales': instance.cantidadComensales,
      'tipo': _$TipoMesaEnumMap[instance.tipo]!,
      'fotoUrl': instance.fotoUrl,
      'qrCodeUrl': instance.qrCodeUrl,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$TipoMesaEnumMap = {
  TipoMesa.VIP: 'VIP',
  TipoMesa.discapacitados: 'discapacitados',
  TipoMesa.estandar: 'estandar',
  TipoMesa.otro: 'otro',
};
