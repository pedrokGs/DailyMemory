class Compromisso {
  final int id;
  final String titulo;
  final String descricao;
  final String data;

  Compromisso({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.data,
  });

  factory Compromisso.fromJson(Map<String, dynamic> json) {
    return Compromisso(
      id: json['id'] ?? 0, // Protege contra null
      titulo: json['titulo'] ?? '',
      descricao: json['descricao'] ?? '',
      data: json['data'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'data': data,
    };
  }
}
