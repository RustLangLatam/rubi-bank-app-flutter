import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/common/widgets/custom_back_button.dart';
import '../../../../../core/common/widgets/custom_button.dart';
import '../../../../../core/common/widgets/elegant_progress_indicator.dart';
import '../../../../../core/common/widgets/password_strength_meter.dart';
import '../../providers/register_provider.dart';

class RegisterPersonalInfoScreen extends StatefulWidget {
  final VoidCallback onBack;

  const RegisterPersonalInfoScreen({
    super.key,
    required this.onBack,
  });

  @override
  State<RegisterPersonalInfoScreen> createState() => _RegisterPersonalInfoScreenState();
}

class _RegisterPersonalInfoScreenState extends State<RegisterPersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController(text: "eleleazar");
  final _lastNameController = TextEditingController(text: "garrido");
  final _emailController = TextEditingController(text: "eleleazar@gmail.com");
  final _passwordController = TextEditingController(text: "12345678");

  bool _showPassword = false;
  String _passwordStrengthLabel = '';
  int _passwordStrengthScore = 0;
  String _emailError = '';
  String _firstNameError = '';
  String _lastNameError = '';
  String _passwordError = '';

  final RegExp _emailRegex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$'
  );

  @override
  void initState() {
    super.initState();
    // Prefill with existing customer data from provider
    final provider = Provider.of<RegisterProvider>(context, listen: false);

    if (provider.customer.givenName.isNotEmpty) {
      _firstNameController.text = provider.customer.givenName;
    }
    if (provider.customer.familyName.isNotEmpty) {
      _lastNameController.text = provider.customer.familyName;
    }
    if (provider.customer.email.isNotEmpty) {
      _emailController.text = provider.customer.email;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  Map<String, dynamic> _calculatePasswordStrength(String password) {
    if (password.isEmpty) return {'score': 0, 'label': ''};

    final checks = {
      'length': password.length >= 8,
      'uppercase': RegExp(r'[A-Z]').hasMatch(password),
      'lowercase': RegExp(r'[a-z]').hasMatch(password),
      'number': RegExp(r'\d').hasMatch(password),
      'specialChar': RegExp(r'[^A-Za-z0-9]').hasMatch(password),
    };

    if (!checks['length']!) {
      return {'score': 1, 'label': 'Too short'};
    }

    int score = checks.values.where((value) => value).length;
    score = score.clamp(1, 4);

    const labels = ['', 'Weak', 'Medium', 'Strong', 'Very Strong'];
    return {'score': score, 'label': labels[score]};
  }

  void _validateEmail(String email) {
    if (email.isEmpty) {
      setState(() => _emailError = 'Email is required');
    } else if (!_emailRegex.hasMatch(email)) {
      setState(() => _emailError = 'Please enter a valid email address');
    } else {
      setState(() => _emailError = '');
    }
  }

  void _validateFirstName(String firstName) {
    if (firstName.isEmpty) {
      setState(() => _firstNameError = 'First name is required');
    } else if (firstName.length < 2) {
      setState(() => _firstNameError = 'First name must be at least 2 characters');
    } else {
      setState(() => _firstNameError = '');
    }
  }

  void _validateLastName(String lastName) {
    if (lastName.isEmpty) {
      setState(() => _lastNameError = 'Last name is required');
    } else if (lastName.length < 2) {
      setState(() => _lastNameError = 'Last name must be at least 2 characters');
    } else {
      setState(() => _lastNameError = '');
    }
  }

  void _validatePassword(String password) {
    if (password.isEmpty) {
      setState(() => _passwordError = 'Password is required');
    } else if (password.length < 8) {
      setState(() => _passwordError = 'Password must be at least 8 characters');
    } else {
      setState(() => _passwordError = '');
    }
  }

  void _handlePasswordChange(String password) {
    final strength = _calculatePasswordStrength(password);
    setState(() {
      _passwordStrengthScore = strength['score'] as int;
      _passwordStrengthLabel = strength['label'] as String;
    });
    _validatePassword(password);
  }

  bool _areAllFieldsValid() {
    return _firstNameError.isEmpty &&
        _lastNameError.isEmpty &&
        _emailError.isEmpty &&
        _passwordError.isEmpty &&
        _firstNameController.text.isNotEmpty &&
        _lastNameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty;
  }

  void _handleNext() {
    // Validate all fields
    _validateFirstName(_firstNameController.text);
    _validateLastName(_lastNameController.text);
    _validateEmail(_emailController.text);
    _validatePassword(_passwordController.text);

    if (_areAllFieldsValid()) {
      // Update the customer data in the provider
      final provider = Provider.of<RegisterProvider>(context, listen: false);

      provider.updatePersonalInfo(
        _firstNameController.text,
        _lastNameController.text,
        _emailController.text,
      );

      provider.updatePassword(_passwordController.text);

      // Navigate to next screen using named route
      Navigator.pushNamed(context, '/register/identity');
    }
    // else {
    //   // Show error message if any field is invalid
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Please fill all required fields correctly'),
    //       backgroundColor: Colors.red,
    //     ),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                CustomBackButtonWithSpacing(
                  onPressed: widget.onBack,
                  color: colorScheme.secondary,
                  spacing: 16,
                ),

                // Progress indicator
                ElegantProgressIndicator(
                  currentStep: 1,
                  totalSteps: 4,
                ),
                const SizedBox(height: 32),

                // Title
                Text(
                  'Create your Profile',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 40),

                // Form fields
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // First Name
                        TextFormField(
                          controller: _firstNameController,
                          style: theme.textTheme.bodyLarge,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: colorScheme.surface,
                            hintText: 'First Name *',
                            hintStyle: theme.textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF94A3B8),
                            ),
                            contentPadding: const EdgeInsets.all(16),
                            errorText: _firstNameError.isNotEmpty ? _firstNameError : null,
                          ),
                          onChanged: _validateFirstName,
                        ),
                        const SizedBox(height: 20),

                        // Last Name
                        TextFormField(
                          controller: _lastNameController,
                          style: theme.textTheme.bodyLarge,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: colorScheme.surface,
                            hintText: 'Last Name *',
                            hintStyle: theme.textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF94A3B8),
                            ),
                            contentPadding: const EdgeInsets.all(16),
                            errorText: _lastNameError.isNotEmpty ? _lastNameError : null,
                          ),
                          onChanged: _validateLastName,
                        ),
                        const SizedBox(height: 20),

                        // Email
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: theme.textTheme.bodyLarge,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: colorScheme.surface,
                            hintText: 'Email Address *',
                            hintStyle: theme.textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF94A3B8),
                            ),
                            contentPadding: const EdgeInsets.all(16),
                            errorText: _emailError.isNotEmpty ? _emailError : null,
                          ),
                          onChanged: _validateEmail,
                        ),
                        const SizedBox(height: 20),

                        // Password
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_showPassword,
                          style: theme.textTheme.bodyLarge,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: colorScheme.surface,
                            hintText: 'Create Password *',
                            hintStyle: theme.textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF94A3B8),
                            ),
                            contentPadding: const EdgeInsets.all(16),
                            suffixIcon: IconButton(
                              onPressed: _togglePasswordVisibility,
                              icon: _showPassword
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility),
                              color: const Color(0xFF94A3B8),
                            ),
                            errorText: _passwordError.isNotEmpty ? _passwordError : null,
                          ),
                          onChanged: _handlePasswordChange,
                        ),

                        // Password strength meter
                        if (_passwordController.text.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: PasswordStrengthMeter(
                              score: _passwordStrengthScore,
                              label: _passwordStrengthLabel,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // Next button
                const SizedBox(height: 32),
                CustomButton(
                  text: "Next",
                  onPressed: _handleNext,
                  type: ButtonType.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterPersonalInfoScreenWrapper extends StatelessWidget {
  const RegisterPersonalInfoScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return RegisterPersonalInfoScreen(
        onBack: () => Navigator.pop(context)
    );
  }
}