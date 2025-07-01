import 'models/wiki_article.dart';

class WikiController {
  final List<WikiArticle> _articles = [
    WikiArticle(
      id: '1',
      title: 'O que é Blockchain?',
      summary: 'Uma explicação simples sobre blockchain.',
      content: 'Blockchain é uma tecnologia de registro distribuído...',
    ),
    // Adicione mais artigos aqui
  ];

  List<WikiArticle> get articles => List.unmodifiable(_articles);

  WikiArticle? getById(String id) =>
      _articles.firstWhere((a) => a.id == id, orElse: () => null);
}
