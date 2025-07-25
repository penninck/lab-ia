class Article {
  final String id;
  final String titulo;
  final String subTitulo;
  final String texto;

  Article({
    required this.id,
    required this.titulo,
    required this.subTitulo,
    required this.texto,
  });

  factory Article.fromJson(Map<String, dynamic> json, {required String id}) {
    return Article(
      id: id,
      titulo: json['titulo'] ?? '',
      subTitulo: json['subTitulo'] ?? '',
      texto: json['texto'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'subTitulo': subTitulo,
      'texto': texto,
    };
  }
}
