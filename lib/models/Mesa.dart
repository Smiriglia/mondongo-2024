import 'package:json_annotation/json_annotation.dart';
part 'mesa.g.dart';


@JsonSerializable()
class Mesa {
  final int numero;
  final int cantidadComensales;
  final String tipo;
  final String? fotoUrl;
  final String qrCodeUrl;
  final DateTime createdAt;

  Mesa({
    required this.numero,
    required this.cantidadComensales,
    required this.tipo,
    this.fotoUrl,
    required this.qrCodeUrl,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => _$MesaToJson(this);

  factory Mesa.fromJson(Map<String, dynamic> json) =>
      _$MesaFromJson(json);
}
