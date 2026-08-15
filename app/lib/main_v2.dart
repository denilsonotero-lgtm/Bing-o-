import 'package:flutter/material.dart';
import 'screens/home_screen_v2.dart';

void main() {
  runApp(const BingaoAppV2());
}

class BingaoAppV2 extends StatelessWidget {
  const BingaoAppV2({super.key});

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
      home: const HomeScreenV2(),
    );
  }
}
