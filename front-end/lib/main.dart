import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/login/login_page.dart';

void main() {
  runApp(const GoodFoodApp());
}

class GoodFoodApp extends StatelessWidget {
  const GoodFoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoodFood',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark, // mantém o “cinza/fosco” por padrão
      home: const LoginPage(),
    );
  }
}
