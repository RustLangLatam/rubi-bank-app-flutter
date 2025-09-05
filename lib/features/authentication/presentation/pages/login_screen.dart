import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/theme/app_theme.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/common/widgets/rubi_bank_logo.dart';
import '../providers/customer_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _showPassword = false;
  bool _isLoading = false; // Local loading state
  final _emailController = TextEditingController(text: 'pinto@gmail.com');
  final _passwordController = TextEditingController(text: '12345678');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!_emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
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
        _isLoading = true; // Show loading only when button is pressed
      });

      try {
        await ref
            .read(customerProvider.notifier)
            .loginCustomer(_emailController.text, _passwordController.text);

        final customer = ref.read(customerProvider).value;
        if (customer != null) {
          Navigator.pushReplacementNamed(context, '/dashboard', arguments: customer);
        }
      } on CustomerException catch (e) {
        // Error will be shown through the state listener
        debugPrint('Login error: ${e.message}');
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false; // Hide loading when done
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    // Watch the customer provider state for errors only
    final customerState = ref.watch(customerProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.appGradient(colorScheme)),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 64,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Logo and Header
                      Column(
                        children: [
                          RubiBankLogo(
                            size: 52,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Welcome Back',
                            style: textTheme.displayLarge?.copyWith(
                              fontSize: 36,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Securely access your account.',
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),

                      // Error message if exists
                      if (customerState.hasError)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colorScheme.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: colorScheme.error.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            customerState.errorMessage, // Clean and safe
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.error,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                      if (customerState.hasError) const SizedBox(height: 16),

                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: textTheme.bodyLarge,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: 'Email',
                        ),
                        validator: _validateEmail,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      const SizedBox(height: 16),

                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_showPassword,
                        style: textTheme.bodyLarge,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          suffixIcon: IconButton(
                            onPressed: _togglePasswordVisibility,
                            icon: _showPassword
                                ? Icon(Icons.visibility_off, color: colorScheme.shadow)
                                : Icon(Icons.visibility, color: colorScheme.shadow),
                            splashRadius: 20,
                          ),
                        ),
                        validator: _validatePassword,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),

                      const SizedBox(height: 32),

                      // Login Button with loading inside
                      CustomButton.primary(
                        text: 'Sign In',
                        onPressed: _isLoading ? () {} : _submitForm, // Disable when loading
                        isLoading: _isLoading, // Show loading indicator inside button
                      ),

                      const SizedBox(height: 24),

                      // Forgot Password Button
                      CustomButton.muted(
                        text: 'Forgot Password?',
                        onPressed: _isLoading ? () {} : () { // Disable when loading
                          // Navigate to forgot password screen
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}