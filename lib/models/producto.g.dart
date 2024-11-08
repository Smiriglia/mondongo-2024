// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'producto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Producto _$ProductoFromJson(Map<String, dynamic> json) => Producto(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String?,
      tiempoElaboracion: (json['tiempoElaboracion'] as num).toInt(),
      precio: (json['precio'] as num).toDouble(),
      fotosUrls:
          (json['fotosUrls'] as List<dynamic>).map((e) => e as String).toList(),
      qrCodeUrl: json['qrCodeUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      sector: json['sector'] as String,
    );

Map<String, dynamic> _$ProductoToJson(Producto instance) => <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'descripcion': instance.descripcion,
      'tiempoElaboracion': instance.tiempoElaboracion,
      'precio': instance.precio,
      'fotosUrls': instance.fotosUrls,
      'qrCodeUrl': instance.qrCodeUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'sector': instance.sector,
    };
