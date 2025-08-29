import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/utils/app_routes.dart';
import 'core/common/theme/app_theme.dart';
import 'features/authentication/presentation/providers/register_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => RegisterProvider())],
      child: MaterialApp(
        title: 'Rubi Bank',
        theme: AppTheme.lightTheme, // 🌞 Light
        darkTheme: AppTheme.darkTheme, // 🌚 Dark
        themeMode: ThemeMode.system, // System theme
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: '/',
      ),
    );
  }
}
