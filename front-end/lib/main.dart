import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/login/login_page.dart';
import 'state/app_state.dart';

void main() {
  runApp(GoodFoodApp(appState: AppState()));
}

class GoodFoodApp extends StatelessWidget {
  const GoodFoodApp({super.key, required this.appState});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoodFood',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: LoginPage(appState: appState),
    );
  }
}
