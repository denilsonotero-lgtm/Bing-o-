import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/main_dashboard_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';

  static Map<String, WidgetBuilder> get routes {
    return {
      login: (_) => const LoginScreen(),
      register: (_) => const RegisterScreen(),
      dashboard: (_) => const MainDashboardScreen(),
    };
  };
}
