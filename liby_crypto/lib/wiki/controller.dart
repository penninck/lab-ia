import 'package:flutter/material.dart';
import 'models/article.dart';
import 'data/repository.dart';

class Controller extends ChangeNotifier {
  final Repository _repository = Repository();
  
  List<Article> _articles = [];
  bool _isLoading = false;

  List<Article> get articles => _articles;
  bool get isLoading => _isLoading;

  // Carrega artigos do Firestore
  void loadArticles() {
    _isLoading = true;
    notifyListeners();

    _repository.getArticles().listen((articles) {
      _articles = articles;
      _isLoading = false;
      notifyListeners();
    });
  }

  // Adiciona novo artigo
  Future<void> addArticle(Article article) async {
    await _repository.createArticle(article);
  }

  // Busca artigo por ID
  Future<Article?> getArticleById(String id) async {
    return await _repository.getArticleById(id);
  }
}
