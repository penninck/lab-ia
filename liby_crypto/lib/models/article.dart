// lib/models/article.dart
class Article {
  final String id;
  final String titulo;
  final String texto;

  Article({
    required this.id,
    required this.titulo,
    required this.texto,
  });

  factory Article.fromFirestore(Map<String, dynamic> data, String docId) {
    return Article(
      id: docId,
      titulo: data['titulo'] ?? '',
      texto: data['texto'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'titulo': titulo,
      'texto': texto,
    };
  }
}
