import 'package:flutter/material.dart';
import 'package:liby/app_exports.dart';

class ArticleDetailPage extends StatefulWidget {
  final Article article;
  const ArticleDetailPage({Key? key, required this.article}) : super(key: key);

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final isMatch = (String text) {
      if (_searchQuery.trim().isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return text.toLowerCase().contains(q);
    };

    final highlight = (String text) {
      if (_searchQuery.trim().isEmpty) return Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      );
      final q = _searchQuery.toLowerCase();
      final matches = text.toLowerCase().indexOf(q);
      if (matches == -1) return Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      );
      final before = text.substring(0, matches);
      final match = text.substring(matches, matches + q.length);
      final after = text.substring(matches + q.length);
      return RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 16, color: Colors.white),
          children: [
            TextSpan(text: before),
            TextSpan(
              text: match,
              style: const TextStyle(
                backgroundColor: Color(0xFFFCF79A),
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(text: after),
          ],
        ),
      );
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Artigo'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Campo de busca "Explorar"
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: TextField(
                    onChanged: (value) => setState(() => _searchQuery = value),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Explorar',
                      hintStyle: const TextStyle(
                        color: Colors.white70,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      filled: true,
                      fillColor: Colors.black,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isMatch(widget.article.subTitulo))
                        Text(
                          widget.article.subTitulo,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                      const SizedBox(height: 20),
                      // Destaque no texto conforme pesquisa
                      if (isMatch(widget.article.texto))
                        highlight(widget.article.texto)
                      else
                        const Text(
                          'Nenhum trecho correspondente ao filtro.',
                          style: TextStyle(fontSize: 16, color: Colors.white54),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
