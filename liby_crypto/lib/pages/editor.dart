import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/repository.dart';
import '../models/article.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({Key? key}) : super(key: key);

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _tituloController = TextEditingController();
  final _textoController = TextEditingController();
  String? _editingArticleId;
  bool _isLoading = false;

  void _startEdit(Article article) {
    setState(() {
      _editingArticleId = article.id;
      _tituloController.text = article.titulo;
      _textoController.text = article.texto;
    });
  }

  void _clearForm() {
    setState(() {
      _editingArticleId = null;
      _idController.clear();
      _tituloController.clear();
      _textoController.clear();
    });
  }

  Future<void> _saveArticle() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final repository = Provider.of<Repository>(context, listen: false);

    try {
      if (_editingArticleId == null) {
        await repository.createArticle(
          _tituloController.text.trim(),
          _textoController.text.trim(),
        );
      } else {
        await repository.updateArticle(
          _editingArticleId!,
          _tituloController.text.trim(),
          _textoController.text.trim(),
        );
      }
      _clearForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteArticle(String docId) async {
    setState(() => _isLoading = true);
    final repository = Provider.of<Repository>(context, listen: false);

    try {
      await repository.deleteArticle(docId);
      if (_editingArticleId == docId) {
        _clearForm();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao deletar: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _tituloController.dispose();
    _textoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final repository = Provider.of<Repository>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editor de Artigos'),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        actions: [
          if (_editingArticleId != null)
            IconButton(
              icon: const Icon(Icons.clear),
              tooltip: 'Cancelar edição',
              onPressed: _clearForm,
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isLoading ? null : _saveArticle,
        icon: const Icon(Icons.save),
        label: Text(_editingArticleId == null ? 'Adicionar' : 'Salvar'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Card(
                    elevation: 2,
                    color: colorScheme.surfaceVariant,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _tituloController,
                              decoration: const InputDecoration(
                                labelText: 'Título',
                                filled: true,
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) => value == null || value.isEmpty ? 'Informe o título' : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _textoController,
                              decoration: const InputDecoration(
                                labelText: 'Texto',
                                filled: true,
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 4,
                              validator: (value) => value == null || value.isEmpty ? 'Informe o texto' : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
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
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('Nenhum artigo cadastrado.'));
                        }
                        final articles = snapshot.data!;
                        return ListView.builder(
                          itemCount: articles.length,
                          itemBuilder: (context, index) {
                            final article = articles[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: colorScheme.primaryContainer,
                                  foregroundColor: colorScheme.onPrimaryContainer,
                                  child: Text((index + 1).toString()),
                                ),
                                title: Text(
                                  article.titulo,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  article.texto,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      tooltip: 'Editar',
                                      onPressed: () => _startEdit(article),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      tooltip: 'Excluir',
                                      onPressed: () => _deleteArticle(article.id),
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
    );
  }
}
