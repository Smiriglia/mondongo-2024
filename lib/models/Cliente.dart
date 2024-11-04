// lib/models/Cliente.dart
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

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      apellido: json['apellido'] as String,
      dni: json['dni'] as String,
      fotoUrl: json['foto_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      estado: json['estado'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'dni': dni,
      'foto_url': fotoUrl,
      'created_at': createdAt.toIso8601String(),
      'estado': estado,
    };
  }
}
