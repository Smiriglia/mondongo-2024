import 'package:json_annotation/json_annotation.dart';
part 'cliente.g.dart';

@JsonSerializable()
class Cliente {
  final String id;
  final String nombre;
  final String apellido;
  final String dni;
  final String? fotoUrl;
  final DateTime createdAt;
  final String estado;

  Cliente({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.dni,
    this.fotoUrl,
    required this.createdAt,
    required this.estado,
  });

  Map<String, dynamic> toJson() => _$ClienteToJson(this);

  factory Cliente.fromJson(Map<String, dynamic> json) =>
      _$ClienteFromJson(json);
}
