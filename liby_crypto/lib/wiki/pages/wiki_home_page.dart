import 'package:flutter/material.dart';
import '../wiki_controller.dart';
import '../widgets/wiki_article_tile.dart';
import 'wiki_article_page.dart';

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
