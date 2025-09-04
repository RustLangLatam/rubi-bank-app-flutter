import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/common/theme/app_theme.dart';
import '../../../../../core/common/widgets/custom_back_button.dart';
import '../../../../../core/common/widgets/custom_button.dart';
import '../../../../../core/common/widgets/elegant_progress_indicator.dart';
import '../../../../../core/common/widgets/password_strength_meter.dart';
import '../../providers/register_provider.dart';

class RegisterPersonalInfoScreen extends ConsumerStatefulWidget {
  final VoidCallback onBack;

  const RegisterPersonalInfoScreen({super.key, required this.onBack});

  @override
  ConsumerState<RegisterPersonalInfoScreen> createState() =>
      _RegisterPersonalInfoScreenState();
}

class _RegisterPersonalInfoScreenState
    extends ConsumerState<RegisterPersonalInfoScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _showPassword = false;
  String _passwordStrengthLabel = '';
  int _passwordStrengthScore = 0;
  String _emailError = '';
  String _firstNameError = '';
  String _lastNameError = '';
  String _passwordError = '';

  final RegExp _emailRegex = RegExp(
    r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );

  @override
  void initState() {
    super.initState();
    final registerState = ref.read(registerProvider);

    if (registerState.customer.givenName.isNotEmpty) {
      _firstNameController.text = registerState.customer.givenName;
    }
    if (registerState.customer.familyName.isNotEmpty) {
      _lastNameController.text = registerState.customer.familyName;
    }
    if (registerState.customer.email.isNotEmpty) {
      _emailController.text = registerState.customer.email;
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

  void _validateEmail(String value) {
    final trimmedValue = value.trim();
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (trimmedValue.isEmpty) {
      setState(() => _emailError = 'Email is required');
    } else if (!emailRegex.hasMatch(trimmedValue)) {
      setState(() => _emailError = 'Please enter a valid email address');
    } else {
      setState(() => _emailError = '');
    }
  }

  void _validateFirstName(String value) {
    final trimmedValue = value.trim();

    if (trimmedValue.isEmpty) {
      setState(() => _firstNameError = 'First name is required');
    } else if (trimmedValue.length < 2) {
      setState(
        () => _firstNameError = 'First name must be at least 2 characters',
      );
    } else if (RegExp(r'[0-9]').hasMatch(trimmedValue)) {
      setState(() => _firstNameError = 'First name cannot contain numbers');
    } else if (RegExp(
      r'[!@#\$%^&*()_+={}\[\]|;:"<>?/\\~`]',
    ).hasMatch(trimmedValue)) {
      setState(
        () => _firstNameError = 'First name cannot contain special characters',
      );
    } else if (RegExp(r'^\s|\s$').hasMatch(trimmedValue)) {
      setState(() => _firstNameError = 'Cannot start or end with spaces');
    } else {
      setState(() => _firstNameError = '');
    }
  }

  void _validateLastName(String value) {
    final trimmedValue = value.trim();

    if (trimmedValue.isEmpty) {
      setState(() => _lastNameError = 'Last name is required');
    } else if (trimmedValue.length < 2) {
      setState(
        () => _lastNameError = 'Last name must be at least 2 characters',
      );
    } else if (RegExp(r'[0-9]').hasMatch(trimmedValue)) {
      setState(() => _lastNameError = 'Last name cannot contain numbers');
    } else if (RegExp(
      r'[!@#\$%^&*()_+={}\[\]|;:"<>?/\\~`]',
    ).hasMatch(trimmedValue)) {
      setState(
        () => _lastNameError = 'Last name cannot contain special characters',
      );
    } else if (RegExp(r'^\s|\s$').hasMatch(trimmedValue)) {
      setState(() => _lastNameError = 'Cannot start or end with spaces');
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
    final registerState = ref.read(registerProvider.notifier);

    // Validate all fields
    _validateFirstName(_firstNameController.text);
    _validateLastName(_lastNameController.text);
    _validateEmail(_emailController.text);
    _validatePassword(_passwordController.text);

    if (_areAllFieldsValid()) {
      registerState.updatePersonalInfo(
        _firstNameController.text,
        _lastNameController.text,
        _emailController.text,
      );

      registerState.updatePassword(_passwordController.text);

      // Navigate to next screen using named route
      Navigator.pushNamed(context, '/register/identity');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.appGradient),
        child: SafeArea(
          child: KeyboardVisibilityBuilder(
            builder: (context, isKeyboardVisible) {
              return Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button
                    CustomBackButtonWithSpacing(
                      onPressed: widget.onBack,
                      color: colorScheme.onBackground,
                      spacing: 16,
                    ),
                    ElegantProgressIndicator(currentStep: 1, totalSteps: 4),
                    const SizedBox(height: 32),

                    // Title
                    Text(
                      'Create your Profile',
                      style: textTheme.displayLarge?.copyWith(
                        fontSize: 30, // text-3xl
                      ),
                    ),
                    const SizedBox(height: 32),

                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // First Name
                            TextFormField(
                              controller: _firstNameController,
                              style: textTheme.bodyLarge,
                              textCapitalization: TextCapitalization.words,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: colorScheme.surface,
                                hintText: 'First Name',
                                hintStyle: textTheme.titleMedium,
                                contentPadding: const EdgeInsets.all(16),
                                border: theme.inputDecorationTheme.border,
                                enabledBorder:
                                    theme.inputDecorationTheme.enabledBorder,
                                focusedBorder:
                                    theme.inputDecorationTheme.focusedBorder,
                                errorText: _firstNameError.isNotEmpty
                                    ? _firstNameError
                                    : null,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(
                                  RegExp(r'[0-9]'),
                                ),
                                FilteringTextInputFormatter.deny(
                                  RegExp(
                                    r'[!@#\$%^&*()_+={}\[\]|;:"<>,.?/\\~`]',
                                  ),
                                ),
                              ],
                              onChanged: _validateFirstName,
                            ),
                            const SizedBox(height: 16),

                            // Last Name
                            TextFormField(
                              controller: _lastNameController,
                              style: textTheme.bodyLarge,
                              textCapitalization: TextCapitalization.words,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: colorScheme.surface,
                                hintText: 'Last Name',
                                hintStyle: textTheme.titleMedium,
                                contentPadding: const EdgeInsets.all(16),
                                border: theme.inputDecorationTheme.border,
                                enabledBorder:
                                    theme.inputDecorationTheme.enabledBorder,
                                focusedBorder:
                                    theme.inputDecorationTheme.focusedBorder,
                                errorText: _lastNameError.isNotEmpty
                                    ? _lastNameError
                                    : null,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(
                                  RegExp(r'[0-9]'),
                                ),
                                FilteringTextInputFormatter.deny(
                                  RegExp(
                                    r'[!@#\$%^&*()_+={}\[\]|;:"<>,.?/\\~`]',
                                  ),
                                ),
                              ],
                              onChanged: _validateLastName,
                            ),
                            const SizedBox(height: 16),

                            // Email
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: textTheme.bodyLarge,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: colorScheme.surface,
                                hintText: 'Email Address',
                                hintStyle: textTheme.titleMedium,
                                contentPadding: const EdgeInsets.all(16),
                                border: theme.inputDecorationTheme.border,
                                enabledBorder:
                                    theme.inputDecorationTheme.enabledBorder,
                                focusedBorder:
                                    theme.inputDecorationTheme.focusedBorder,
                                errorText: _emailError.isNotEmpty
                                    ? _emailError
                                    : null,
                              ),
                              onChanged: _validateEmail,
                            ),
                            const SizedBox(height: 16),

                            // Password
                            TextFormField(
                              controller: _passwordController,
                              obscureText: !_showPassword,
                              style: textTheme.bodyLarge,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: colorScheme.surface,
                                hintText: 'Create Password',
                                hintStyle: textTheme.titleMedium,
                                contentPadding: const EdgeInsets.all(16),
                                border: theme.inputDecorationTheme.border,
                                enabledBorder:
                                    theme.inputDecorationTheme.enabledBorder,
                                focusedBorder:
                                    theme.inputDecorationTheme.focusedBorder,
                                suffixIcon: IconButton(
                                  onPressed: _togglePasswordVisibility,
                                  icon: _showPassword
                                      ? Icon(
                                          Icons.visibility_off,
                                          color: colorScheme.shadow,
                                        )
                                      : Icon(
                                          Icons.visibility,
                                          color: colorScheme.shadow,
                                        ),
                                  splashRadius: 20,
                                ),
                                errorText: _passwordError.isNotEmpty
                                    ? _passwordError
                                    : null,
                              ),
                              onChanged: _handlePasswordChange,
                              onFieldSubmitted: (_) {
                                if (_areAllFieldsValid()) {
                                  _handleNext();
                                }
                              },
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

                    if (!isKeyboardVisible) ...[
                      const SizedBox(height: 32),
                      CustomButton.primary(
                        text: "Next",
                        onPressed: _handleNext,
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class RegisterPersonalInfoScreenWrapper extends ConsumerWidget {
  const RegisterPersonalInfoScreenWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RegisterPersonalInfoScreen(
      onBack: () {
        final registerState = ref.read(registerProvider.notifier);
        registerState.reset();
        Navigator.pop(context);
      },
    );
  }
}
