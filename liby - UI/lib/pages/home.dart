import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:liby/app_exports.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final repository = Provider.of<Repository>(context, listen: false);

    return Scaffold(
      drawer: const MenuDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Think Crypto'),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: TextField(
                    onChanged: (value) => setState(() => _searchQuery = value),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Explorar',
                      hintStyle: const TextStyle(
                        color: Colors.white70,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      filled: true,
                      fillColor: Colors.black,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                    ),
                  ),
                ),
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
                            a.subTitulo.toLowerCase().contains(q) ||
                            a.texto.toLowerCase().contains(q);
                      }).toList();

                      if (articles.isEmpty) {
                        return const Center(child: Text(
                            'Nenhuma notícia encontrada.',
                            style: TextStyle(color: Colors.black)));
                      }

                      final isWide = MediaQuery.of(context).size.width > 900;
                      final crossAxisCount = isWide ? 3 : MediaQuery.of(context).size.width > 600 ? 2 : 1;

                      return GridView.builder(
                        padding: const EdgeInsets.all(24),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 24,
                          childAspectRatio: 1.2,
                        ),
                        itemCount: articles.length,
                        itemBuilder: (ctx, i) {
                          final art = articles[i];
                          return InkWell(
                            borderRadius: BorderRadius.circular(24),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ArticleDetailPage(article: art),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    art.subTitulo,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    art.texto,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
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
