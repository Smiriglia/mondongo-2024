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

  factory DuenoSupervisor.fromJson(Map<String, dynamic> json) {
    return DuenoSupervisor(
      id: json['id'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      dni: json['dni'],
      cuil: json['cuil'],
      fotoUrl: json['foto_url'],
      perfil: json['perfil'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'dni': dni,
      'cuil': cuil,
      'foto_url': fotoUrl,
      'perfil': perfil,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
