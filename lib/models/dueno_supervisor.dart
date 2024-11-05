import 'package:json_annotation/json_annotation.dart';
import 'package:mondongo/models/profile.dart';
part 'dueno_supervisor.g.dart';

@JsonSerializable()
class DuenoSupervisor extends Profile {
  final String cuil;

  DuenoSupervisor({
    required this.cuil,
    required super.id,
    required super.nombre,
    required super.apellido,
    required super.dni,
    required super.createdAt,
    super.rol = 'dueño/supervisor',
    super.fotoUrl,
  });

  Map<String, dynamic> toJson() => _$DuenoSupervisorToJson(this);

  factory DuenoSupervisor.fromJson(Map<String, dynamic> json) =>
      _$DuenoSupervisorFromJson(json);
}
