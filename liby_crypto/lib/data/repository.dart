// lib/data/repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/article.dart';

class Repository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collection = 'article';

  Stream<List<Article>> getArticles() {
    return _firestore.collection(collection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Article(
          id: doc.id,
          titulo: data['titulo'] ?? '',
          texto: data['texto'] ?? '',
        );
      }).toList();
    });
  }

  Future<void> createArticle(String titulo, String texto) async {
    try {
      await _firestore.collection(collection).add({
        'titulo': titulo,
        'texto': texto,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Erro ao criar artigo: $e');
      rethrow;
    }
  }

  Future<void> updateArticle(String docId, String titulo, String texto) async {
    try {
      await _firestore.collection(collection).doc(docId).set({
        'titulo': titulo,
        'texto': texto,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Erro ao atualizar artigo: $e');
      rethrow;
    }
  }

  Future<void> deleteArticle(String docId) async {
    try {
      await _firestore.collection(collection).doc(docId).delete();
    } catch (e) {
      print('Erro ao deletar artigo: $e');
      rethrow;
    }
  }

  Future<Article?> getArticleById(String id) async {
    try {
      final doc = await _firestore.collection(collection).doc(id).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return Article(
          id: doc.id,
          titulo: data['titulo'] ?? '',
          texto: data['texto'] ?? '',
        );
      }
      return null;
    } catch (e) {
      print('Erro ao buscar artigo: $e');
      return null;
    }
  }
}
