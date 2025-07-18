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
    const brandGreen = Color(0xFF009B3A);
    const bitcoinOrange = Color(0xFFF7931A);
    const deepBlue = Color(0xFF1E3A8A);

    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: brandGreen,
      onPrimary: Colors.white,
      secondary: bitcoinOrange,
      onSecondary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      background: Colors.white,
      onBackground: deepBlue,
      surface: Colors.white,
      onSurface: deepBlue,
    );

    return MultiProvider(
      providers: [
        Provider<Repository>(
          create: (_) => Repository(),
        ),
      ],
      child: MaterialApp(
        title: 'Think Crypto',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: colorScheme,
          appBarTheme: AppBarTheme(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: colorScheme.secondary,
            foregroundColor: colorScheme.onSecondary,
          ),
          drawerTheme: DrawerThemeData(
            backgroundColor: colorScheme.background,
          ),
          cardTheme: CardThemeData(
            color: colorScheme.surface,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        initialRoute: AppRoutes.home,
        routes: {
          AppRoutes.home: (_) => const HomePage(),
          AppRoutes.editor: (_) => const EditorPage(),
        },
      ),
    );
  }
}
