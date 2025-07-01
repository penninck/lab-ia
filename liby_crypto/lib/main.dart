import 'package:flutter/material.dart';
import 'wiki/controller.dart';
import 'wiki/pages/home.dart';

void main() {
  runApp(const LibyCryptoApp());
}

class LibyCryptoApp extends StatelessWidget {
  const LibyCryptoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = WikiController();

    return MaterialApp(
      title: 'Liby Crypto Wiki',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: WikiHomePage(controller: controller),
    );
  }
}
