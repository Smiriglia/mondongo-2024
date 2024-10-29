class Empleado {
  final String id;
  final String nombre;
  final String apellido;
  final String dni;
  final String cuil;
  final String? fotoUrl;
  final String tipoEmpleado;
  final DateTime createdAt;

  Empleado({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.dni,
    required this.cuil,
    this.fotoUrl,
    required this.tipoEmpleado,
    required this.createdAt,
  });

  factory Empleado.fromJson(Map<String, dynamic> json) {
    return Empleado(
      id: json['id'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      dni: json['dni'],
      cuil: json['cuil'],
      fotoUrl: json['foto_url'],
      tipoEmpleado: json['tipo_empleado'],
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
      'tipo_empleado': tipoEmpleado,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
