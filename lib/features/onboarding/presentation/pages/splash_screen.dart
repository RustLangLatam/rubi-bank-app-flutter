import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/common/theme/app_theme.dart';
import '../../../../core/common/widgets/elegant_rubi_loader.dart';
import '../../../../data/providers/user_preferences_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

// Enhanced SplashScreen with better error handling and animation
class _SplashScreenState extends ConsumerState<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _opacity = 1.0);
      _checkUserRegistration();
    });
  }

  Future<void> _checkUserRegistration() async {
    try {
      // Add a minimum splash time of 2 seconds
      final results = await Future.wait([
        Future.delayed(const Duration(seconds: 2)),
        ref.read(userRegisteredProvider.future),
      ], eagerError: true);

      final isRegistered = results[1] as bool;

      if (mounted) {
        _navigateToNextScreen(isRegistered);
      }
    } catch (error) {
      // If there's an error, default to onboarding after minimum time
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        _navigateToNextScreen(false);
      }
    }
  }

  void _navigateToNextScreen(bool isRegistered) {
    if (isRegistered) {
      Navigator.pushReplacementNamed(context, '/welcome-back');
    } else {
      Navigator.pushReplacementNamed(context, '/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(milliseconds: 800),
          child: Container(
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
                          const ElegantRubiLoader(),
                          const SizedBox(height: 24),
                          Text(
                            'RUBIBANK',
                            style: GoogleFonts.playfairDisplay(
                              color: theme.colorScheme.primary,
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
                        style: GoogleFonts.inter(
                          color: theme.colorScheme.onBackground,
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
      ),
    );
  }
}
