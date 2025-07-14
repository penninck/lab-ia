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
  String _selectedCategory = 'Todas';

  final List<String> categories = [
    'Todas', 'Bitcoin', 'Ethereum', 'DeFi', 'NFTs', 'Regulamentação', 'Mineração', 'CBDCs', 'Altcoins'
  ];

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
                // Topo com logo e slogan
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    children: [
                      Image.asset('assets/logo.png', width: 64, height: 64),
                      const SizedBox(height: 8),
                      const Text(
                        'Think Crypto',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Sua fonte completa de notícias sobre criptomoedas e blockchain',
                        style: TextStyle(fontSize: 15, color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                // Card Tempo Real
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: ListTile(
                      leading: Icon(Icons.flash_on, color: colorScheme.primary),
                      title: const Text('Tempo Real'),
                      subtitle: const Text('Notícias em tempo real sobre o mundo blockchain'),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {},
                        child: const Text('Explorar Notícias'),
                      ),
                    ),
                  ),
                ),
                // Filtros de categoria
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (ctx, i) {
                      final cat = categories[i];
                      final selected = cat == _selectedCategory;
                      return ChoiceChip(
                        label: Text(cat),
                        selected: selected,
                        onSelected: (_) => setState(() => _selectedCategory = cat),
                        selectedColor: colorScheme.primary,
                        labelStyle: TextStyle(
                          color: selected ? colorScheme.onPrimary : colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        backgroundColor: colorScheme.primary.withOpacity(0.08),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                // Lista de notícias responsiva
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
                        if (_selectedCategory == 'Todas') return true;
                        return a.titulo.toLowerCase().contains(_selectedCategory.toLowerCase());
                      }).where((a) {
                        if (_searchQuery.isEmpty) return true;
                        final q = _searchQuery.toLowerCase();
                        return a.titulo.toLowerCase().contains(q) || a.texto.toLowerCase().contains(q);
                      }).toList();

                      if (articles.isEmpty) {
                        return const Center(child: Text('Nenhuma notícia encontrada.'));
                      }

                      // Responsivo: grid para web, lista para mobile
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
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.article, color: colorScheme.primary, size: 32),
        ),
        title: Text(
          article.titulo,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          article.texto,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
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
