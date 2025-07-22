import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/menu_drawer.dart';
import '../models/article.dart';
import '../theme/theme.dart';
import '../pages/article_detail.dart';
import '../data/repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final typography = context.appTypography;
    final repository = Provider.of<Repository>(context, listen: false);

    return Scaffold(
      drawer: const MenuDrawer(),
      backgroundColor: colors.backgroundLight,
      appBar: AppBar(
        backgroundColor: colors.primaryGreen,
        foregroundColor: colors.backgroundLight,
        title: Text(
          'Think Crypto',
          style: typography.titleLarge.copyWith(color: colors.backgroundLight),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: TextField(
                    onChanged: (value) => setState(() => _searchQuery = value),
                    style: typography.bodyLarge.copyWith(color: colors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Explorar',
                      hintStyle: typography.bodyLarge.copyWith(color: colors.textSecondary),
                      filled: true,
                      fillColor: colors.cardBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<List<Article>>(
                    stream: repository.getArticles(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Erro: ${snapshot.error}',
                            style: typography.bodyMedium.copyWith(color: colors.textPrimary),
                          ),
                        );
                      }
                      final filteredArticles = (snapshot.data ?? []).where((article) {
                        if (_searchQuery.isEmpty) return true;
                        final q = _searchQuery.toLowerCase();
                        return article.titulo.toLowerCase().contains(q) ||
                            article.subTitulo.toLowerCase().contains(q) ||
                            article.texto.toLowerCase().contains(q);
                      }).toList();

                      if (filteredArticles.isEmpty) {
                        return Center(
                          child: Text(
                            'Nenhuma notícia encontrada.',
                            style: typography.bodyMedium.copyWith(color: colors.textPrimary),
                          ),
                        );
                      }

                      final isWide = MediaQuery.of(context).size.width > 900;
                      final crossAxisCount = isWide ? 3 : MediaQuery.of(context).size.width > 600 ? 2 : 1;

                      return GridView.builder(
                        padding: const EdgeInsets.all(24),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 24,
                          childAspectRatio: 1.2,
                        ),
                        itemCount: filteredArticles.length,
                        itemBuilder: (ctx, i) {
                          final article = filteredArticles[i];
                          return InkWell(
                            borderRadius: BorderRadius.circular(24),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ArticleDetailPage(article: article),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: colors.primaryGreen,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    article.subTitulo,
                                    style: typography.titleLarge.copyWith(
                                      color: colors.backgroundLight,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    article.texto,
                                    style: typography.bodyMedium.copyWith(
                                      color: colors.backgroundLight,
                                    ),
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
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
