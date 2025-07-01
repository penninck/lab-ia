import 'package:collection/collection.dart';
import 'models/article.dart';

class WikiController {
  final List<WikiArticle> _articles = [
    WikiArticle(
      id: '1',
      title: 'O que é Blockchain?',
      summary: 'Uma explicação simples sobre blockchain.',
      content: 'Blockchain é uma tecnologia de registro distribuído...',
    ),
    WikiArticle(
      id: '2',
      title: 'História das Criptomoedas',
      summary: 'Breve histórico sobre a evolução das criptomoedas.',
      content: 'As criptomoedas começaram em 2009 com o Bitcoin...',
    ),
  ];

  List<WikiArticle> get articles => List.unmodifiable(_articles);

  WikiArticle? getById(String id) =>
      _articles.firstWhereOrNull((a) => a.id == id);
}
