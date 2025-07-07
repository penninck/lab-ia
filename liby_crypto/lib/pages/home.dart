import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/menu_drawer.dart';
import '../data/repository.dart';
import '../models/article.dart';
import 'editor.dart';

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
    final repository = Provider.of<Repository>(context);

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
                delegate: ArticleSearchDelegate(repository),
              );
              if (result != null) {
                setState(() {
                  _searchQuery = result;
                });
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
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum artigo encontrado.'));
          }
          
          final articles = snapshot.data!.where((article) {
            if (_searchQuery.isEmpty) return true;
            return article.titulo.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                article.texto.toLowerCase().contains(_searchQuery.toLowerCase());
          }).toList();

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
                  title: Text(
                    article.titulo,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    article.texto,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  leading: Icon(Icons.article_outlined, color: colorScheme.secondary),
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
  final Repository repository;

  ArticleSearchDelegate(this.repository);

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
  Widget buildSuggestions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      alignment: Alignment.center,
      child: const Text('Digite para pesquisar artigos...'),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  void showResults(BuildContext context) {
    close(context, query);
  }
}
