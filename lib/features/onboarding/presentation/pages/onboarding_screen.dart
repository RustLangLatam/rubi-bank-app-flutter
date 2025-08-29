import 'package:flutter/material.dart';
import '../../../../core/common/theme/app_theme.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/common/widgets/security_icon.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  void _navigateToLogin(BuildContext context) {
    Navigator.pushNamed(context, '/login');
  }

  void _navigateToRegister(BuildContext context) {
    Navigator.pushNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = AppTheme.darkTheme;

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DefaultTextStyle.merge(
                      style: TextStyle(color: theme.colorScheme.secondary),
                      child: SecurityIcon(
                        size: 128,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'World-Class Security',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Your finances, protected with the most advanced technology.",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                children: [
                  CustomButton(
                    text: 'Create Account',
                    onPressed: () => _navigateToRegister(context),
                    type: ButtonType.primary,
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    text: 'Sign In',
                    onPressed: () => _navigateToLogin(context),
                    type: ButtonType.secondary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}