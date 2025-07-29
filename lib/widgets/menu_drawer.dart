import 'package:flutter/material.dart';
import 'app_exports.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final typography = context.appTypography;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: colors.backgroundLight,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    colors.primaryGreen,
                    colors.bitcoinOrange,
                  ],
                ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                blendMode: BlendMode.srcIn,
                child: Text(
                  'Think Crypto',
                  style: typography.displayLarge.copyWith(
                    color: colors.backgroundLight,
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.article, size: 24, color: colors.primaryGreen),
            title: Text('Think', style: typography.titleLarge),
            subtitle: Text('Notícias e artigos', style: typography.bodyMedium),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, AppRoutes.home);
            },
          ),
          ListTile(
            leading: Icon(Icons.edit, size: 24, color: colors.bitcoinOrange),
            title: Text('Editor', style: typography.titleLarge),
            subtitle: Text('Criar ou editar artigo', style: typography.bodyMedium),
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
              style: typography.bodyMedium.copyWith(
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
