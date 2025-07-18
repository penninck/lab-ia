class Article {
  final String id;
  final String titulo;
  final String subTitulo; // ← NOVO CAMPO!
  final String texto;

  Article({
    required this.id,
    required this.titulo,
    required this.subTitulo, // ← NOVO
    required this.texto,
  });

  // Factory para criar a partir do Firestore/JSON
  factory Article.fromJson(Map<String, dynamic> json, {required String id}) {
    return Article(
      id: id,
      titulo: json['titulo'] ?? '',
      subTitulo: json['subTitulo'] ?? '', // ← NOVO
      texto: json['texto'] ?? '',
    );
  }

  // Pode ser útil para enviar para o Firestore/JSON
  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'subTitulo': subTitulo, // ← NOVO
      'texto': texto,
    };
  }
}
