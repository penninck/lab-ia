import 'package:collection/collection.dart';
import 'models/wiki_article.dart';

class WikiController {
  final List<WikiArticle> _articles = [
    // ... seus artigos
  ];

  List<WikiArticle> get articles => List.unmodifiable(_articles);

  WikiArticle? getById(String id) =>
      _articles.firstWhereOrNull((a) => a.id == id);
}
