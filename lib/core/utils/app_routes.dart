// lib/app/router/app_router.dart
import 'package:flutter/material.dart';

import '../../features/authentication/presentation/pages/login_screen.dart';
import '../../features/authentication/presentation/pages/register/register_address_screen.dart';
import '../../features/authentication/presentation/pages/register/register_identity_screen.dart';
import '../../features/authentication/presentation/pages/register/register_otp_screen.dart';
import '../../features/authentication/presentation/pages/register/register_personal_info_screen.dart';
import '../../features/authentication/presentation/pages/register/register_phone_screen.dart';
import '../../features/common/presentation/pages/under_development_screen.dart';
import '../../features/onboarding/presentation/pages/onboarding_screen.dart';
import '../../features/onboarding/presentation/pages/splash_screen.dart';
import '../transitions/custom_page_route.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case '/onboarding':
        return CustomPageRoute.fade(const OnboardingScreen());

      case '/login':
        return CustomPageRoute.fade(const LoginScreen());

      case '/register':
        return CustomPageRoute.scale(const RegisterPersonalInfoScreenWrapper());

      case '/register/identity':
        return CustomPageRoute.slide(const RegisterIdentityScreenWrapper());

      case '/register/address':
        return CustomPageRoute.slide(const RegisterAddressScreenWrapper());

      case '/register/phone':
        return CustomPageRoute.slide(const RegisterPhoneScreenWrapper());

      case '/register/otp':
        return CustomPageRoute.slide(const RegisterOtpScreenWrapper());

      case '/under-development':
        return CustomPageRoute.scale(const UnderDevelopmentScreen());

      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
