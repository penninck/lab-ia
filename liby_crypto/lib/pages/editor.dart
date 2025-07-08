import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:liby_crypto/app_exports.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({Key? key}) : super(key: key);

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _textoController = TextEditingController();
  String? _editingId;
  bool _isLoading = false;

  @override
  void dispose() {
    _tituloController.dispose();
    _textoController.dispose();
    super.dispose();
  }

  void _startEdit(Article article) {
    setState(() {
      _editingId = article.id;
      _tituloController.text = article.titulo;
      _textoController.text = article.texto;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final repo = Provider.of<Repository>(context, listen: false);
    final title = _tituloController.text.trim();
    final text = _textoController.text.trim();
    try {
      if (_editingId == null) {
        await repo.createArticle(title, text);
      } else {
        await repo.updateArticle(_editingId!, title, text);
      }
      _clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _delete(String id) async {
    setState(() => _isLoading = true);
    final repo = Provider.of<Repository>(context, listen: false);
    try {
      await repo.deleteArticle(id);
      if (_editingId == id) _clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _clear() {
    setState(() {
      _editingId = null;
      _tituloController.clear();
      _textoController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final repo = Provider.of<Repository>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editor de Artigos'),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        actions: [
          if (_editingId != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clear,
            ),
        ],
      ),
      drawer: const MenuDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isLoading ? null : _save,
        icon: const Icon(Icons.save),
        label: Text(_editingId == null ? 'Adicionar' : 'Salvar'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Card(
                    color: colorScheme.surfaceVariant,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _tituloController,
                              decoration: const InputDecoration(
                                labelText: 'Título',
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) =>
                                  v == null || v.isEmpty ? 'Informe o título' : null,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _textoController,
                              maxLines: 4,
                              decoration: const InputDecoration(
                                labelText: 'Texto',
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) =>
                                  v == null || v.isEmpty ? 'Informe o texto' : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: StreamBuilder<List<Article>>(
                      stream: repo.getArticles(),
                      builder: (ctx, snap) {
                        if (snap.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final list = snap.data ?? [];
                        if (list.isEmpty) {
                          return const Center(child: Text('Nenhum artigo cadastrado.'));
                        }
                        return ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (ctx, i) {
                            final art = list[i];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                title: Text(art.titulo,
                                    style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(
                                  art.texto,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                leading: CircleAvatar(
                                  backgroundColor: colorScheme.primaryContainer,
                                  foregroundColor: colorScheme.onPrimaryContainer,
                                  child: Text('${i + 1}'),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () => _startEdit(art),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _delete(art.id),
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
