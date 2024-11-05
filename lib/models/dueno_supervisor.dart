import 'package:json_annotation/json_annotation.dart';
part 'dueno_supervisor.g.dart';

@JsonSerializable()
class DuenoSupervisor {
  final String id;
  final String nombre;
  final String apellido;
  final String dni;
  final String cuil;
  final String? fotoUrl;
  final String perfil;
  final DateTime createdAt;

  DuenoSupervisor({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.dni,
    required this.cuil,
    this.fotoUrl,
    required this.perfil,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => _$DuenoSupervisorToJson(this);

  factory DuenoSupervisor.fromJson(Map<String, dynamic> json) =>
      _$DuenoSupervisorFromJson(json);
}
