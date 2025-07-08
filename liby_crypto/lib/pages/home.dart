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
      drawer: const MenuDrawer(),
      body: StreamBuilder<List<Article>>(
        stream: repository.getArticles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          final articles = (snapshot.data ?? [])
              .where((a) {
                if (_searchQuery.isEmpty) return true;
                final q = _searchQuery.toLowerCase();
                return a.titulo.toLowerCase().contains(q) ||
                       a.texto.toLowerCase().contains(q);
              })
              .toList();
          if (articles.isEmpty) {
            return const Center(child: Text('Nenhum artigo encontrado.'));
          }
          return ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: colorScheme.surfaceVariant,
                child: ListTile(
                  leading: Icon(Icons.article_outlined, color: colorScheme.secondary),
                  title: Text(
                    article.titulo,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    article.texto,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            },
          );
        },
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
