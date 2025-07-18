import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:liby_crypto/app_exports.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final repository = Provider.of<Repository>(context, listen: false);

    return Scaffold(
      drawer: const MenuDrawer(),
      appBar: AppBar(
        title: const Text('Think Crypto'),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final String? result = await showSearch<String>(
                context: context,
                delegate: ArticleSearchDelegate(),
              );
              if (result != null) {
                setState(() => _searchQuery = result);
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 980),
            child: Column(
              children: [
                // Filtros de categoria removidos daqui!
                const SizedBox(height: 8),
                Expanded(
                  child: StreamBuilder<List<Article>>(
                    stream: repository.getArticles(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Erro: ${snapshot.error}'));
                      }
                      final articles = (snapshot.data ?? []).where((a) {
                        if (_searchQuery.isEmpty) return true;
                        final q = _searchQuery.toLowerCase();
                        return a.titulo.toLowerCase().contains(q) ||
                            a.texto.toLowerCase().contains(q);
                      }).toList();

                      if (articles.isEmpty) {
                        return const Center(child: Text('Nenhuma notícia encontrada.'));
                      }

                      final isWide = MediaQuery.of(context).size.width > 700;
                      if (isWide) {
                        return GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 1.4,
                          ),
                          itemCount: articles.length,
                          itemBuilder: (ctx, i) {
                            final art = articles[i];
                            return _NewsCard(article: art, colorScheme: colorScheme);
                          },
                        );
                      } else {
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: articles.length,
                          itemBuilder: (ctx, i) {
                            final art = articles[i];
                            return _NewsCard(article: art, colorScheme: colorScheme);
                          },
                        );
                      }
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

class _NewsCard extends StatelessWidget {
  final Article article;
  final ColorScheme colorScheme;

  const _NewsCard({required this.article, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: colorScheme.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article.titulo,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            if (article.subTitulo.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 3.0, bottom: 6.0),
                child: Text(
                  article.subTitulo,
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            Text(
              article.texto,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class ArticleSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    close(context, query);
    return const SizedBox.shrink();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.search),
      title: Text(query.isEmpty ? 'Digite para pesquisar...' : query),
      onTap: () => close(context, query),
    );
  }
}
