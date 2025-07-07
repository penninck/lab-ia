# Think Crypto

![Think Crypto Logo](assets/logo.png)

Um aplicativo Flutter moderno para gerenciamento e leitura de artigos sobre criptomoedas, construído com Material Design 3 e integração completa com Firebase.

## 🚀 Características

- **Multiplataforma**: Funciona perfeitamente em Web e Android
- **Material Design 3**: Interface moderna seguindo as diretrizes mais recentes do Google
- **Firebase Integration**: Armazenamento em tempo real com Cloud Firestore
- **PWA Ready**: Configurado como Progressive Web App para instalação
- **Busca Avançada**: Sistema de pesquisa em tempo real nos artigos
- **Interface Responsiva**: Adaptável para diferentes tamanhos de tela

## 🎨 Design System

### Paleta de Cores Oficial

| Função | Cor | Hex |
|--------|-----|-----|
| Primária (Brand) | Verde Brasil | `#009B3A` |
| Destaque (Ação) | Laranja Bitcoin | `#F7931A` |
| Neutro (Base) | Deep Blue | `#1E3A8A` |

## 📱 Funcionalidades

### ✅ Implementadas
- [x] Visualização de artigos em tempo real
- [x] Criação e edição de artigos
- [x] Exclusão de artigos
- [x] Sistema de busca
- [x] Navigation Drawer com logo
- [x] Material Design 3
- [x] Firebase/Firestore integration
- [x] Responsive design
- [x] PWA configuration



## 🏗️ Arquitetura

```
lib/
├── assets/           # Recursos estáticos (logo, imagens)
├── data/            # Repositórios e acesso aos dados
├── models/          # Modelos de dados (Article)
├── pages/           # Telas do aplicativo
├── widgets/         # Componentes reutilizáveis
├── app_routes.dart  # Definição de rotas
└── main.dart        # Ponto de entrada
```

## 🔧 Tecnologias

- **Flutter**: Framework UI multiplataforma
- **Firebase Core**: Inicialização do Firebase
- **Cloud Firestore**: Banco de dados NoSQL em tempo real
- **Material 3**: Sistema de design da Google

## 📋 Pré-requisitos

- Flutter SDK 3.16.0 ou superior
- Dart SDK 3.0.0 ou superior
- Conta Firebase com projeto configurado
- Chrome/Edge para desenvolvimento web

## 🎯 Como Usar

### Visualizar Artigos
1. Abra o aplicativo
2. Na tela inicial, visualize todos os artigos disponíveis
3. Use o ícone de busca para encontrar artigos específicos

### Criar Artigo
1. Abra o menu lateral (drawer)
2. Clique em "Editor"
3. Preencha os campos ID, Título e Texto
4. Clique em "Adicionar"

### Editar Artigo
1. Na tela do Editor, clique no ícone de edição ao lado do artigo
2. Modifique os campos desejados
3. Clique em "Salvar"

### Excluir Artigo
1. Na tela do Editor, clique no ícone de lixeira
2. O artigo será removido imediatamente

## 📁 Estrutura de Dados

### Model Article

```dart
class Article {
  final String id;
  final String titulo;
  final String texto;

  Article({
    required this.id,
    required this.titulo,
    required this.texto,
  });
}
```

## 🎨 Customização

### Alterando Cores

Edite as constantes no `main.dart`:

```dart
const brandGreen = Color(0xFF009B3A);
const bitcoinOrange = Color(0xFFF7931A);
const deepBlue = Color(0xFF1E3A8A);
```



## 📈 Performance

- Usa `StreamBuilder` para atualizações em tempo real
- `StatelessWidget` onde possível
- Lazy loading nas listas
- Material 3 otimizado

## 🤝 Contribuindo

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está licenciado sob a MIT License - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 👨‍💻 Autor

**Seu Nome**
- GitHub: [@seu-usuario](https://github.com/seu-usuario)
- LinkedIn: [Seu Perfil](https://linkedin.com/in/seu-perfil)

---

⭐ Se este projeto foi útil, considere dar uma estrela no GitHub!

---

**Think Crypto** - Simplificando o conhecimento sobre criptomoedas 🚀