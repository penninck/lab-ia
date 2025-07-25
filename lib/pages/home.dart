import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/menu_drawer.dart';
import '../models/article.dart';
import '../theme/theme.dart';
import '../theme/color.dart';        // ✅ CORRIGIDO - removida dupla barra
import '../theme/typography.dart';   // ✅ CORRIGIDO - caminho correto
import '../data/repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchQuery = '';
  String? _expandedCardId; //do

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
                // Campo de busca
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    ),
                  ),
                ),
                // Lista de artigos com expansão inline
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

                      final query = _searchQuery.trim().toLowerCase();

                      // Filtra os artigos
                      final filteredArticles = (snapshot.data ?? []).where((article) {
                        if (query.isEmpty) return true;
                        return article.titulo.toLowerCase().contains(query) ||
                            article.subTitulo.toLowerCase().contains(query) ||
                            article.texto.toLowerCase().contains(query);
                      }).toList();

                      // Ordena por relevância se houver busca
                      if (query.isNotEmpty) {
                        int calculateRelevanceScore(Article article) {
                          final titulo = article.titulo.toLowerCase();
                          final subTitulo = article.subTitulo.toLowerCase();
                          final texto = article.texto.toLowerCase();

                          if (titulo.startsWith(query)) return 0;
                          if (subTitulo.startsWith(query)) return 20;
                          if (titulo.contains(query)) return 40;
                          if (subTitulo.contains(query)) return 60;
                          if (texto.contains(query)) return 80;
                          return 100;
                        }

                        filteredArticles.sort((a, b) =>
                            calculateRelevanceScore(a).compareTo(calculateRelevanceScore(b)));
                      }

                      if (filteredArticles.isEmpty) {
                        return Center(
                          child: Text(
                            'Nenhuma notícia encontrada.',
                            style: typography.bodyMedium.copyWith(color: colors.textPrimary),
                          ),
                        );
                      }

                      // Layout responsivo com expansão inline
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        itemCount: filteredArticles.length,
                        itemBuilder: (context, index) {
                          final article = filteredArticles[index];
                          final isExpanded = _expandedCardId == article.id;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildArticleCard(
                              article: article,
                              isExpanded: isExpanded,
                              colors: colors,
                              typography: typography,
                              onTap: () {
                                setState(() {
                                  _expandedCardId = isExpanded ? null : article.id;
                                });
                              },
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

  Widget _buildArticleCard({
    required Article article,
    required bool isExpanded,
    required AppColorsExtension colors,
    required AppTypographyExtension typography,
    required VoidCallback onTap,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: colors.primaryGreen,
        borderRadius: BorderRadius.circular(24),
        boxShadow: isExpanded
            ? [
                BoxShadow(
                  color: colors.primaryGreen.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : [
                BoxShadow(
                  color: colors.primaryGreen.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cabeçalho do card
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            article.subTitulo,
                            style: typography.titleLarge.copyWith(
                              color: colors.backgroundLight,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (!isExpanded)
                            Text(
                              article.texto,
                              style: typography.bodyMedium.copyWith(
                                color: colors.backgroundLight.withOpacity(0.9),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                    // Ícone indicador
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: colors.backgroundLight,
                        size: 28,
                      ),
                    ),
                  ],
                ),
                // Conteúdo expandido
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  crossFadeState: isExpanded 
                      ? CrossFadeState.showSecond 
                      : CrossFadeState.showFirst,
                  firstChild: const SizedBox.shrink(),
                  secondChild: isExpanded
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            Container(
                              height: 1,
                              width: double.infinity,
                              color: colors.backgroundLight.withOpacity(0.3),
                            ),
                            const SizedBox(height: 16),
                            _buildExpandedContent(article, colors, typography),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedContent(
    Article article,
    AppColorsExtension colors,
    AppTypographyExtension typography,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Metadados
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: colors.backgroundLight.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.access_time, size: 16, color: colors.backgroundLight),
                  const SizedBox(width: 4),
                  Text(
                    'Há 2 horas',
                    style: typography.bodyMedium.copyWith(
                      color: colors.backgroundLight,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: colors.bitcoinOrange.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Think Crypto',
                style: typography.bodyMedium.copyWith(
                  color: colors.backgroundLight,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Texto completo
        Text(
          article.texto,
          style: typography.bodyLarge.copyWith(
            color: colors.backgroundLight,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 20),
        // Botões de ação
        Row(
          children: [
            _buildActionButton(
              icon: Icons.favorite_border,
              label: 'Curtir',
              colors: colors,
              typography: typography,
              onPressed: () {},
            ),
            const SizedBox(width: 12),
            _buildActionButton(
              icon: Icons.share,
              label: 'Compartilhar',
              colors: colors,
              typography: typography,
              onPressed: () {},
            ),
            const SizedBox(width: 12),
            _buildActionButton(
              icon: Icons.bookmark_border,
              label: 'Salvar',
              colors: colors,
              typography: typography,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required AppColorsExtension colors,
    required AppTypographyExtension typography,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: Material(
        color: colors.backgroundLight.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: colors.backgroundLight),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: typography.bodyMedium.copyWith(
                    color: colors.backgroundLight,
                    fontSize: 12,
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
