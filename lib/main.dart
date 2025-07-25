import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'app_exports.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ThinkCryptoApp());
}

class ThinkCryptoApp extends StatelessWidget {
  const ThinkCryptoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Repository>(
          create: (_) => Repository(),
        ),
      ],
      child: MaterialApp(
        title: 'Think Crypto',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: AppRoutes.home,
        routes: {
          AppRoutes.home: (_) => const HomePage(),
          AppRoutes.editor: (_) => const EditorPage(),
        },
      ),
    );
  }
}
