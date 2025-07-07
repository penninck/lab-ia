import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  void _startEdit(Map<String, dynamic> data, String docId) {
    setState(() {
      _editingArticleId = docId;
      _idController.text = data['id']?.toString() ?? '';
      _tituloController.text = data['titulo'] ?? '';
      _textoController.text = data['texto'] ?? '';
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

    final data = {
      'id': _idController.text.trim(),
      'titulo': _tituloController.text.trim(),
      'texto': _textoController.text.trim(),
    };

    if (_editingArticleId == null) {
      await FirebaseFirestore.instance.collection('article').add(data);
    } else {
      await FirebaseFirestore.instance.collection('article').doc(_editingArticleId).set(data);
    }

    setState(() => _isLoading = false);
    _clearForm();
  }

  Future<void> _deleteArticle(String docId) async {
    setState(() => _isLoading = true);
    await FirebaseFirestore.instance.collection('article').doc(docId).delete();
    setState(() => _isLoading = false);
    if (_editingArticleId == docId) {
      _clearForm();
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
        onPressed: _saveArticle,
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
                              controller: _idController,
                              decoration: const InputDecoration(
                                labelText: 'ID',
                                filled: true,
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) => value == null || value.isEmpty ? 'Informe o ID' : null,
                            ),
                            const SizedBox(height: 16),
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
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('article').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(child: Text('Nenhum artigo cadastrado.'));
                        }
                        final docs = snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            final data = docs[index].data() as Map<String, dynamic>;
                            final docId = docs[index].id;
                            final id = data['id']?.toString() ?? '';
                            final titulo = data['titulo']?.toString() ?? '';
                            final texto = data['texto']?.toString() ?? '';
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
                                  child: Text(id),
                                ),
                                title: Text(
                                  titulo,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  texto,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      tooltip: 'Editar',
                                      onPressed: () => _startEdit(data, docId),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      tooltip: 'Excluir',
                                      onPressed: () => _deleteArticle(docId),
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
