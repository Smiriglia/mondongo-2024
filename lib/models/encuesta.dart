// lib/models/encuesta.dart
class Encuesta {
  final String id;
  final int mesaNumero;
  final double satisfaction;
  final String comentarios;
  final DateTime creadoEn;

  Encuesta({
    required this.id,
    required this.mesaNumero,
    required this.satisfaction,
    required this.comentarios,
    required this.creadoEn,
  });

  factory Encuesta.fromJson(Map<String, dynamic> json) {
    return Encuesta(
      id: json['id'] as String,
      mesaNumero: json['mesa_numero'] as int,
      satisfaction: (json['satisfaction'] as num).toDouble(),
      comentarios: json['comentarios'] as String,
      creadoEn: DateTime.parse(json['creado_en'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mesa_numero': mesaNumero,
      'satisfaction': satisfaction,
      'comentarios': comentarios,
      // 'creado_en' no es necesario ya que se establece por defecto en la base de datos
    };
  }
}
