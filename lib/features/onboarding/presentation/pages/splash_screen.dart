import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/common/theme/app_theme.dart';
import '../../../../core/common/widgets/elegant_rubi_loader.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushNamed(context, '/onboarding');
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return PopScope(
        canPop: false,
        child: Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.appGradient(colorScheme)),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElegantRubiLoader(),
                      const SizedBox(height: 24),
                      Text(
                        'RUBIBANK',
                        style: GoogleFonts.playfairDisplay(
                          color: theme.colorScheme.primary, // #C5A365
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3.0, // Matches tracking-widest
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
                    style: GoogleFonts.inter(
                      color: theme.colorScheme.onBackground, // #EAEBF0
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
        ),
    );
  }
}
