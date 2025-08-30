import 'package:flutter/material.dart';
import 'core/utils/app_routes.dart';
import 'core/common/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Rubi Bank',
        theme: AppTheme.lightTheme, // 🌞 Light
        darkTheme: AppTheme.darkTheme, // 🌚 Dark
        themeMode: ThemeMode.system, // System theme
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: '/',
    );
  }
}