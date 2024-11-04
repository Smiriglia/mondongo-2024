class Mesa {
  final int numero;
  final int cantidadComensales;
  final String tipo;
  final String? fotoUrl;
  final String qrCodeUrl;
  final DateTime createdAt;

  Mesa({
    required this.numero,
    required this.cantidadComensales,
    required this.tipo,
    this.fotoUrl,
    required this.qrCodeUrl,
    required this.createdAt,
  });

  factory Mesa.fromJson(Map<String, dynamic> json) {
    return Mesa(
      numero: json['numero'] as int,
      cantidadComensales: json['cantidad_comensales'] as int,
      tipo: json['tipo'] as String,
      fotoUrl: json['foto_url'] as String?,
      qrCodeUrl: json['qr_code_url'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'numero': numero,
      'cantidad_comensales': cantidadComensales,
      'tipo': tipo,
      'foto_url': fotoUrl,
      'qr_code_url': qrCodeUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
