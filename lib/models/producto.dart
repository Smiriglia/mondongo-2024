import 'package:json_annotation/json_annotation.dart';

part 'producto.g.dart';

@JsonSerializable()
class Producto {
  final String id;
  final String nombre;
  final String? descripcion;
  @JsonKey(name: 'tiempo_elaboracion')
  final int tiempoElaboracion;
  final double precio;
  @JsonKey(name: 'fotos_urls')
  final List<String> fotosUrls;
  @JsonKey(name: 'qr_code_url')
  final String? qrCodeUrl;
  @JsonKey(name: 'created_at')
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
