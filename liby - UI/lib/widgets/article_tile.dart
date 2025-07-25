// lib/wiki/widgets/article_tile.dart
import 'package:flutter/material.dart';
import '../models/article.dart';

class ArticleTile extends StatelessWidget {
  final Article article;
  final VoidCallback onTap;

  const ArticleTile({
    Key? key,
    required this.article,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        article.title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        article.summary,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
