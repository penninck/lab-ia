import 'package:flutter/material.dart';
import '../app_routes.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 170,
            child: DrawerHeader(
              decoration: BoxDecoration(color: colorScheme.primary),
              child: Center(
                child: Image.asset(
                  'assets/logo.png',
                  width: 90,
                  height: 90,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.article, size: 24),
            title: const Text('Think'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, AppRoutes.home);
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit, size: 24),
            title: const Text('Editor'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, AppRoutes.editor);
            },
          ),
        ],
      ),
    );
  }
}
