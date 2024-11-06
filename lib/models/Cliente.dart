import 'package:json_annotation/json_annotation.dart';
import 'package:mondongo/models/profile.dart';
part 'cliente.g.dart';

@JsonSerializable()
class Cliente extends Profile {
  final String estado;

  Cliente({
    required this.estado,
    required super.id,
    required super.nombre,
    required super.apellido,
    required super.dni,
    required super.createdAt,
    required super.email,
    super.rol = 'cliente',
    super.fotoUrl,
  });

  @override
  Map<String, dynamic> toJson() => _$ClienteToJson(this);

  factory Cliente.fromJson(Map<String, dynamic> json) =>
      _$ClienteFromJson(json);
}
