import 'package:flutter/material.dart';

class NavigationService {
  static Future<void> openPage(
    BuildContext context,
    Widget page,
  ) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => page,
      ),
    );
  }

  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }
}
