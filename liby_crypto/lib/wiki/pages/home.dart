// lib/wiki/pages/home.dart
import 'package:flutter/material.dart';
import '../controller.dart';
import '../models/article.dart';
import '../widgets/article_tile.dart';
import 'article.dart';

class HomePage extends StatelessWidget {
  final Controller controller;

  const HomePage({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liby Crypto Wiki'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch<Article>(
                context: context,
                delegate: ArticleSearchDelegate(controller),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: controller.articles.length,
        itemBuilder: (context, index) {
          final article = controller.articles[index];
          return ArticleTile(
            article: article,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ArticlePage(article: article),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ArticleSearchDelegate extends SearchDelegate<Article> {
  final Controller controller;

  ArticleSearchDelegate(this.controller);

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
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = controller.articles
        .where((a) => a.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final article = suggestions[index];
        return ListTile(
          title: Text(article.title),
          onTap: () {
            query = article.title;
            showResults(context);
          },
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = controller.articles
        .where((a) => a.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final article = results[index];
        return ListTile(
          title: Text(article.title),
          subtitle: Text(article.summary),
          onTap: () => close(context, article),
        );
      },
    );
  }
}
