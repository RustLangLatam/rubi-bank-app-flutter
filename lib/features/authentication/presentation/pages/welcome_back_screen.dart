import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/common/theme/app_theme.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/common/widgets/rubi_bank_logo.dart';
import '../../../../data/providers/user_preferences_provider.dart';
import '../providers/customer_provider.dart';

class WelcomeBackScreen extends ConsumerStatefulWidget {
  final VoidCallback? onLogin;

  const WelcomeBackScreen({super.key, this.onLogin});

  @override
  ConsumerState<WelcomeBackScreen> createState() => _WelcomeBackScreenState();
}

class _WelcomeBackScreenState extends ConsumerState<WelcomeBackScreen> {
  bool _showPassword = false;
  bool _isLoading = false;
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _userName;
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userService = ref.read(userPreferencesServiceProvider);
      final userName = await userService.getUserName();
      final userEmail = await userService.getUserEmail();

      if (mounted) {
        setState(() {
          _userName = userName;
          _userEmail = userEmail;
        });
      }
    } catch (error) {
      debugPrint('Error loading user data: $error');
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final userEmail = await ref
            .read(userPreferencesServiceProvider)
            .getUserEmail();

        if (userEmail == null) {
          throw CustomerException('User email not found. Please log in again.');
        }

        await ref
            .read(customerProvider.notifier)
            .loginCustomer(userEmail, _passwordController.text);

        final customer = ref
            .read(customerProvider)
            .value;
        if (customer != null) {
          Navigator.pushReplacementNamed(
              context, '/dashboard', arguments: customer);
        }
      } on CustomerException catch (e) {
        debugPrint('Login error: ${e.message}');
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _navigateToFullLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    final customerState = ref.watch(customerProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.appGradient(colorScheme),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Main content - centered using Center widget
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          // Important for centering
                          children: [
                            // Logo
                            RubiBankLogo(
                              size: 52,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(height: 24),

                            // Welcome text
                            Text(
                              'Welcome Back,',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              _userName ?? 'User',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            // const SizedBox(height: 8),
                            // Text(
                            //   _userEmail ?? 'user@example.com',
                            //   style: textTheme.bodyMedium?.copyWith(
                            //     color: colorScheme.shadow,
                            //   ),
                            // ),
                            const SizedBox(height: 40),

                            // Error message
                            if (customerState.hasError)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: colorScheme.error.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: colorScheme.error.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  customerState.errorMessage,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.error,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),

                            // Password field
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: colorScheme.surface.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: colorScheme.primary.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: !_showPassword,
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  hintStyle: textTheme.bodyLarge?.copyWith(
                                    color: colorScheme.shadow,
                                  ),
                                  contentPadding: const EdgeInsets.all(20),
                                  suffixIcon: IconButton(
                                    onPressed: _togglePasswordVisibility,
                                    icon: _showPassword
                                        ? Icon(Icons.visibility_off, color: colorScheme.shadow)
                                        : Icon(Icons.visibility, color: colorScheme.shadow),
                                    splashRadius: 20,
                                  ),
                                ),
                                validator: _validatePassword,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Forgot password
                            CustomButton.muted(
                              text: 'Forgot Password?',
                              onPressed: _isLoading
                                  ? () {}
                                  : () {
                                // Navigate to forgot password screen
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Bottom buttons
                  Column(
                    children: [
                      CustomButton.primary(
                        text: 'Sign In',
                        onPressed: _isLoading ? () {} : _submitForm,
                        isLoading: _isLoading,
                      ),
                      const SizedBox(height: 16),
                      CustomButton.muted(
                        text: 'Login with another account',
                        onPressed: _isLoading ? () {} : _navigateToFullLogin,
                      ),
                      const SizedBox(height: 20),
                    ],
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