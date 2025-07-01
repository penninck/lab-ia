import 'package:flutter/material.dart';
import '../controller.dart';
import '../widgets/article_tile.dart';
import 'article.dart';

class WikiHomePage extends StatelessWidget {
  final WikiController controller;

  const WikiHomePage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Liby Crypto Wiki')),
      body: ListView.builder(
        itemCount: controller.articles.length,
        itemBuilder: (context, index) {
          final article = controller.articles[index];
          return WikiArticleTile(
            article: article,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WikiArticlePage(article: article),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
