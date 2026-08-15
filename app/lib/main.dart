import 'package:flutter/material.dart';
import 'app_routes.dart';

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
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
    );
  }
}
