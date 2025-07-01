import 'package:flutter/material.dart';
import '../models/article.dart';

class WikiArticleTile extends StatelessWidget {
  final WikiArticle article;
  final VoidCallback onTap;

  const WikiArticleTile({super.key, required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(article.title),
      subtitle: Text(article.summary),
      onTap: onTap,
    );
  }
}
