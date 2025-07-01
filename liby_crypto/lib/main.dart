import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'wiki/controller.dart';
import 'wiki/pages/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const LibyCryptoApp());
}

class LibyCryptoApp extends StatelessWidget {
  const LibyCryptoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Controller();

    return MaterialApp(
      title: 'Liby Crypto Wiki',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(controller: controller),
    );
  }
}
