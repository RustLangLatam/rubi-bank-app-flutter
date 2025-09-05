// lib/app/router/app_router.dart
import 'package:flutter/material.dart';

import '../../features/authentication/presentation/pages/login_screen.dart';
import '../../features/authentication/presentation/pages/register/register_address_screen.dart';
import '../../features/authentication/presentation/pages/register/register_identity_screen.dart';
import '../../features/authentication/presentation/pages/register/register_otp_screen.dart';
import '../../features/authentication/presentation/pages/register/register_personal_info_screen.dart';
import '../../features/authentication/presentation/pages/register/register_phone_screen.dart';
import '../../features/authentication/presentation/pages/welcome_back_screen.dart';
import '../../features/common/presentation/pages/under_development_screen.dart';
import '../../features/dashboard/presentation/pages/dashboard_screen.dart';
import '../../features/onboarding/presentation/pages/onboarding_screen.dart';
import '../../features/onboarding/presentation/pages/splash_screen.dart';
import '../transitions/custom_page_route.dart';
import 'package:rubi_bank_api_sdk/rubi_bank_api_sdk.dart' as sdk;

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return CustomPageRoute.fade(const SplashScreen());

      case '/onboarding':
        return CustomPageRoute.fade(const OnboardingScreen());

      case '/login':
        return CustomPageRoute.fade(const LoginScreen());

      case '/welcome-back':
        return CustomPageRoute.fade(const WelcomeBackScreen());

      case '/register':
        return CustomPageRoute.slide(const RegisterPersonalInfoScreenWrapper());

      case '/register/identity':
        return CustomPageRoute.slide(const RegisterIdentityScreenWrapper());

      case '/register/address':
        return CustomPageRoute.slide(const RegisterAddressScreenWrapper());

      case '/register/phone':
        return CustomPageRoute.slide(const RegisterPhoneScreenWrapper());

      case '/register/otp':
        return CustomPageRoute.slide(const RegisterOtpScreenWrapper());

      case '/dashboard':
        final customer = settings.arguments as sdk.Customer;
        return CustomPageRoute.fade(DashboardScreen(customer: customer));

      case '/under-development':
        return CustomPageRoute.scale(const UnderDevelopmentScreen());

      case '/transactions':
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
