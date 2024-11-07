// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'producto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Producto _$ProductoFromJson(Map<String, dynamic> json) => Producto(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String?,
      tiempoElaboracion: (json['tiempo_elaboracion'] as num).toInt(),
      precio: (json['precio'] as num).toDouble(),
      fotosUrls: (json['fotos_urls'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      qrCodeUrl: json['qr_code_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$ProductoToJson(Producto instance) => <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'descripcion': instance.descripcion,
      'tiempo_elaboracion': instance.tiempoElaboracion,
      'precio': instance.precio,
      'fotos_urls': instance.fotosUrls,
      'qr_code_url': instance.qrCodeUrl,
      'created_at': instance.createdAt.toIso8601String(),
    };
