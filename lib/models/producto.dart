import 'package:json_annotation/json_annotation.dart';

part 'producto.g.dart';

@JsonSerializable()
class Producto {
  final String id;
  final String nombre;
  final String? descripcion;
  final int tiempoElaboracion;
  final double precio;
  final List<String> fotosUrls;
  final String? qrCodeUrl;
  final DateTime createdAt;

  Producto({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.tiempoElaboracion,
    required this.precio,
    required this.fotosUrls,
    this.qrCodeUrl,
    required this.createdAt,
  });

  factory Producto.fromJson(Map<String, dynamic> json) =>
      _$ProductoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductoToJson(this);
}
