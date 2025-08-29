import 'package:flutter/material.dart';
import '../../../../core/common/widgets/rubiBank_logo.dart';
import '../../../../core/transitions/custom_page_route.dart';
import '../../../../core/common/theme/app_theme.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushNamed(context, '/onboarding');
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = AppTheme.darkTheme;

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const RubiBankLogo(size: 96), // Logo SVG animable
                    const SizedBox(height: 24),
                    Text(
                      'RUBIBANK',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        color: theme.colorScheme.secondary, // accent-gold
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Opacity(
                opacity: 0.5,
                child: Text(
                  '© 2024 RubiBank. All Rights Reserved.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
