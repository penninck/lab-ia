import 'package:flutter/material.dart';
import '../models/wiki_article.dart';

class WikiArticlePage extends StatelessWidget {
  final WikiArticle article;

  const WikiArticlePage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(article.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(article.content),
      ),
    );
  }
}
