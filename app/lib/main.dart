import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_routes.dart';
import 'supabase_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );
  } catch (e) {
    debugPrint('Erro na conexão inicial com o Supabase: $e');
  }

  runApp(const BingaoApp());
}

class BingaoApp extends StatelessWidget {
  const BingaoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;
    final initialRoute = session != null ? AppRoutes.dashboard : AppRoutes.login;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BINGÃO',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
      ),
      initialRoute: initialRoute,
      routes: AppRoutes.routes,
    );
  }
}
