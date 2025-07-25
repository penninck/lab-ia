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
    final colors = context.appColors;
    final typography = context.appTypography;

    final isMatch = (String text) {
      if (_searchQuery.trim().isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return text.toLowerCase().contains(q);
    };

    final highlight = (String text) {
      if (_searchQuery.trim().isEmpty) return Text(
        text,
        style: typography.bodyLarge.copyWith(color: colors.backgroundLight),
      );
      final q = _searchQuery.toLowerCase();
      final matches = text.toLowerCase().indexOf(q);
      if (matches == -1) return Text(
        text,
        style: typography.bodyLarge.copyWith(color: colors.backgroundLight),
      );
      final before = text.substring(0, matches);
      final match = text.substring(matches, matches + q.length);
      final after = text.substring(matches + q.length);
      return RichText(
        text: TextSpan(
          style: typography.bodyLarge.copyWith(color: colors.backgroundLight),
          children: [
            TextSpan(text: before),
            TextSpan(
              text: match,
              style: typography.bodyLarge.copyWith(
                backgroundColor: colors.bitcoinOrange,
                color: colors.backgroundDark,
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
        title: Text('Artigo', style: typography.titleLarge),
        backgroundColor: colors.primaryGreen,
        foregroundColor: colors.backgroundLight,
      ),
      backgroundColor: colors.backgroundLight,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: TextField(
                    onChanged: (value) => setState(() => _searchQuery = value),
                    style: typography.bodyLarge.copyWith(
                      color: colors.backgroundLight,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Explorar',
                      hintStyle: typography.bodyLarge.copyWith(
                        color: colors.backgroundLight.withOpacity(0.7),
                        fontWeight: FontWeight.bold,
                      ),
                      filled: true,
                      fillColor: colors.backgroundDark,
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
                    color: colors.primaryGreen,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isMatch(widget.article.subTitulo))
                        Text(
                          widget.article.subTitulo,
                          style: typography.headlineLarge.copyWith(
                            color: colors.backgroundLight,
                          ),
                        ),
                      const SizedBox(height: 20),
                      if (isMatch(widget.article.texto))
                        highlight(widget.article.texto)
                      else
                        Text(
                          'Nenhum trecho correspondente ao filtro.',
                          style: typography.bodyMedium.copyWith(
                            color: colors.backgroundLight.withOpacity(0.7),
                          ),
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
