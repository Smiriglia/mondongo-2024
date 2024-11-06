import 'package:json_annotation/json_annotation.dart';
import 'package:mondongo/models/profile.dart';
part 'empleado.g.dart';

@JsonSerializable()
class Empleado extends Profile {
  final String cuil;
  final String tipoEmpleado;

  Empleado({
    required this.cuil,
    required this.tipoEmpleado,
    required super.id,
    required super.nombre,
    required super.apellido,
    required super.dni,
    required super.createdAt,
    required super.email,
    super.rol = 'empleado',
    super.fotoUrl,
  });

  @override
  Map<String, dynamic> toJson() => _$EmpleadoToJson(this);

  factory Empleado.fromJson(Map<String, dynamic> json) =>
      _$EmpleadoFromJson(json);
}
