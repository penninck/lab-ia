import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/article.dart';

class Repository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collection = 'article';

  // LISTAR artigos (com subTitulo)
  Stream<List<Article>> getArticles() {
    return _firestore.collection(collection).orderBy('createdAt', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Article(
          id: doc.id,
          titulo: data['titulo'] ?? '',
          subTitulo: data['subTitulo'] ?? '', // <-- ADICIONADO
          texto: data['texto'] ?? '',
        );
      }).toList();
    });
  }

  // CRIAR artigo (agora com subTitulo)
  Future<void> createArticle(String titulo, String subTitulo, String texto) async {
    try {
      await _firestore.collection(collection).add({
        'titulo': titulo,
        'subTitulo': subTitulo, // <-- ADICIONADO
        'texto': texto,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Erro ao criar artigo: $e');
      rethrow;
    }
  }

  // ATUALIZAR artigo (agora com subTitulo)
  Future<void> updateArticle(String docId, String titulo, String subTitulo, String texto) async {
    try {
      await _firestore.collection(collection).doc(docId).set({
        'titulo': titulo,
        'subTitulo': subTitulo, // <-- ADICIONADO
        'texto': texto,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Erro ao atualizar artigo: $e');
      rethrow;
    }
  }

  // DELETAR artigo (sem mudança)
  Future<void> deleteArticle(String docId) async {
    try {
      await _firestore.collection(collection).doc(docId).delete();
    } catch (e) {
      print('Erro ao deletar artigo: $e');
      rethrow;
    }
  }

  // BUSCAR artigo por id (com subTitulo)
  Future<Article?> getArticleById(String id) async {
    try {
      final doc = await _firestore.collection(collection).doc(id).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return Article(
          id: doc.id,
          titulo: data['titulo'] ?? '',
          subTitulo: data['subTitulo'] ?? '', // <-- ADICIONADO
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
