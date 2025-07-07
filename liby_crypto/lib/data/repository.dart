import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/article.dart';

class Repository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collection = 'article';

  // Buscar todos os artigos
  Stream<List<Article>> getArticles() {
    return _firestore.collection(collection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Article(
          id: doc.id,
          title: data['title'] ?? '',
          summary: data['summary'] ?? '',
          content: data['content'] ?? '',
        );
      }).toList();
    });
  }

  // Criar novo artigo
  Future<void> createArticle(Article article) async {
    try {
      await _firestore.collection(collection).add({
        'title': article.title,
        'summary': article.summary,
        'content': article.content,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Erro ao criar artigo: $e');
    }
  }

  // Buscar artigo por ID
  Future<Article?> getArticleById(String id) async {
    try {
      final doc = await _firestore.collection(collection).doc(id).get();
      if (doc.exists) {
        final data = doc.data()!;
        return Article(
          id: doc.id,
          title: data['title'],
          summary: data['summary'],
          content: data['content'],
        );
      }
      return null;
    } catch (e) {
      print('Erro ao buscar artigo: $e');
      return null;
    }
  }
}
