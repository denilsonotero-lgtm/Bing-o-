import 'package:flutter/material.dart';

void main() {
  runApp(const BingaoApp());
}

class BingaoApp extends StatelessWidget {
  const BingaoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BINGÃO',
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const BingaoHomePage(),
    );
  }
}

class BingaoHomePage extends StatelessWidget {
  const BingaoHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎱 BINGÃO'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Bem-vindo ao BINGÃO!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
