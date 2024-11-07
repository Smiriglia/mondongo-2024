import 'package:json_annotation/json_annotation.dart';
import 'package:mondongo/models/cliente.dart';
import 'package:mondongo/models/dueno_supervisor.dart';
import 'package:mondongo/models/empleado.dart';

@JsonSerializable()
abstract class Profile {
  final String id;
  final String nombre;
  final String apellido;
  final String dni;
  final String? fotoUrl;
  final DateTime createdAt;
  final String rol;
  final String email;

  Profile({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.dni,
    required this.createdAt,
    required this.rol,
    required this.email,
    this.fotoUrl,
  });

  Map<String, dynamic> toJson();

  factory Profile.fromJson(Map<String, dynamic> json) {
    switch (json['rol']) {
      case 'cliente':
        return Cliente.fromJson(json);
      case 'empleado':
        return Empleado.fromJson(json);
      case 'maitre':
        return Empleado.fromJson(json);
      case 'mozo':
        return Empleado.fromJson(json);
      case 'supervisor':
        return DuenoSupervisor.fromJson(json);
      case 'dueño':
        return DuenoSupervisor.fromJson(json);
    }
    throw Exception('rol invalido');
  }
}
