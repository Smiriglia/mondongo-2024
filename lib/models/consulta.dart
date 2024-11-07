import 'package:json_annotation/json_annotation.dart';

part 'consulta.g.dart';

@JsonSerializable()
class Consulta {
  final String id;
  @JsonKey(name: 'mesa_numero')
  final int mesaNumero;
  @JsonKey(name: 'cliente_id')
  final String clienteId;
  @JsonKey(name: 'fecha_hora')
  final DateTime fechaHora;
  final String consulta;
  String estado;
  @JsonKey(name: 'mozo_id')
  String? mozoId;
  String? respuesta;
  @JsonKey(name: 'fecha_respuesta')
  DateTime? fechaRespuesta;

  Consulta({
    required this.id,
    required this.mesaNumero,
    required this.clienteId,
    required this.fechaHora,
    required this.consulta,
    required this.estado,
    this.mozoId,
    this.respuesta,
    this.fechaRespuesta,
  });

  factory Consulta.fromJson(Map<String, dynamic> json) =>
      _$ConsultaFromJson(json);

  Map<String, dynamic> toJson() => _$ConsultaToJson(this);
}
