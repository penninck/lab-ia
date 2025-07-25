import 'package:flutter/material.dart';
import 'package:liby/app_exports.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFF009B3A),
                    Color(0xFFF7931A),
                  ],
                ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                blendMode: BlendMode.srcIn,
                child: const Text(
                  'Think Crypto',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.article, size: 24, color: colorScheme.primary),
            title: const Text('Think'),
            subtitle: const Text('Notícias e artigos'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, AppRoutes.home);
            },
          ),
          ListTile(
            leading: Icon(Icons.edit, size: 24, color: colorScheme.secondary),
            title: const Text('Editor'),
            subtitle: const Text('Criar ou editar artigo'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, AppRoutes.editor);
            },
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Versão 1.0.0',
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.6),
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
