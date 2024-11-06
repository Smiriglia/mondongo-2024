import 'package:json_annotation/json_annotation.dart';
part 'mesa.g.dart';

enum TipoMesa {
  VIP,
  discapacitados,
  estandar,
  otro;

  static TipoMesa getTipoMesa(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'vip':
        return TipoMesa.VIP;
      case 'discapacitados':
        return TipoMesa.discapacitados;
      case 'estandar':
        return TipoMesa.estandar;
      default:
        return TipoMesa.otro;
    }
  }
}
@JsonSerializable()
class Mesa {
  final int numero;
  final int cantidadComensales;
  final TipoMesa tipo;
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
