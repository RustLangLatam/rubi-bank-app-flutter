import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Provider;
import 'package:rubi_bank_api_sdk/rubi_bank_api_sdk.dart';
import '../../../../../core/common/theme/app_theme.dart';
import '../../../../../core/common/widgets/custom_back_button.dart';
import '../../../../../core/common/widgets/custom_button.dart';
import '../../../../../core/common/widgets/elegant_progress_indicator.dart';
import '../../providers/register_provider.dart';

class RegisterPhoneScreen extends ConsumerStatefulWidget {
  final VoidCallback onBack;

  const RegisterPhoneScreen({super.key, required this.onBack});

  @override
  ConsumerState<RegisterPhoneScreen> createState() =>
      _RegisterPhoneScreenState();
}

class _RegisterPhoneScreenState extends ConsumerState<RegisterPhoneScreen> {
  final _phoneNumberController = TextEditingController(text: '501234567');
  bool _agreedToTerms = false;
  String _phoneError = '';
  String _termsError = '';

  @override
  void initState() {
    super.initState();
    final registerState = ref.read(registerProvider);
    if (registerState.customer.phoneNumber.number.isNotEmpty) {
      _phoneNumberController.text = registerState.customer.phoneNumber.number;
    }
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  void _validatePhoneNumber(String value) {
    final cleanedNumber = value.replaceAll(RegExp(r'\D'), '');
    if (cleanedNumber.isEmpty) {
      setState(() => _phoneError = 'Phone number is required');
    } else if (cleanedNumber.length < 9 || cleanedNumber.length > 15) {
      setState(() => _phoneError = 'Please enter a valid phone number');
    } else if (!RegExp(r'^\d+$').hasMatch(cleanedNumber)) {
      setState(() => _phoneError = 'Phone number must contain only digits');
    } else {
      setState(() => _phoneError = '');
    }
  }

  void _validateTerms(bool value) {
    if (!value) {
      setState(() => _termsError = 'You must agree to the Terms & Conditions');
    } else {
      setState(() => _termsError = '');
    }
  }

  bool _areAllFieldsValid() {
    final cleanedNumber = _phoneNumberController.text.replaceAll(RegExp(r'\D'), '');
    return _phoneError.isEmpty &&
        _termsError.isEmpty &&
        cleanedNumber.isNotEmpty &&
        cleanedNumber.length >= 9 &&
        cleanedNumber.length <= 15 &&
        _agreedToTerms;
  }

  Future<void> _handleNext() async {
    final cleanedNumber = _phoneNumberController.text.replaceAll(RegExp(r'\D'), '');
    _validatePhoneNumber(_phoneNumberController.text);
    _validateTerms(_agreedToTerms);

    if (_areAllFieldsValid()) {
      final registerState = ref.read(registerProvider.notifier);
      final newPhone = Phone(
            (r) => r
          ..number = cleanedNumber
          ..countryCode = 971,
      );
      registerState.updatePhone(newPhone);
      Navigator.pushNamed(context, '/register/otp');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.appGradient,
        ),
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

                    // Progress indicator
                        ElegantProgressIndicator(currentStep: 4, totalSteps: 4),
                    const SizedBox(height: 32),

                    // Title and subtitle
                    Text(
                      'Phone Verification',
                      style: textTheme.displayLarge?.copyWith(
                        fontSize: 30, // text-3xl
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please enter your phone number. We will send you a verification code.',
                      style: textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 32),

                    // Form fields
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // Phone number input with country code
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: _phoneError.isNotEmpty
                                          ? Colors.red
                                          : colorScheme.primary.withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      // Country code prefix
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 16,
                                        ),
                                        decoration: BoxDecoration(
                                          color: colorScheme.surface,
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            bottomLeft: Radius.circular(12),
                                          ),
                                        ),
                                        child: Text(
                                          '+971',
                                          style: textTheme.bodyLarge,
                                        ),
                                      ),

                                      // Phone number input
                                      Expanded(
                                        child: TextFormField(
                                          controller: _phoneNumberController,
                                          keyboardType: TextInputType.phone,
                                          style: textTheme.bodyLarge,
                                          decoration: InputDecoration(
                                            hintText: 'Phone Number',
                                            contentPadding: const EdgeInsets.all(16),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(12),
                                                bottomRight: Radius.circular(12),
                                              ),
                                              borderSide: BorderSide(color: const Color(0xFFC5A365).withOpacity(0.125), width: 1),
                                            )
                                          ),
                                          onChanged: (value) {
                                            final cleanedValue = value.replaceAll(RegExp(r'\D'), '');
                                            if (value != cleanedValue) {
                                              _phoneNumberController.value =
                                                  _phoneNumberController.value.copyWith(
                                                    text: cleanedValue,
                                                    selection: TextSelection.collapsed(
                                                      offset: cleanedValue.length,
                                                    ),
                                                  );
                                            }
                                            _validatePhoneNumber(cleanedValue);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (_phoneError.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                                    child: Text(
                                      _phoneError,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Terms and conditions
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    // Checkbox
                                    SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: Checkbox(
                                        value: _agreedToTerms,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            _agreedToTerms = value ?? false;
                                            _validateTerms(_agreedToTerms);
                                          });
                                        },
                                        fillColor: MaterialStateProperty.resolveWith<Color>((
                                            Set<MaterialState> states,
                                            ) {
                                          if (states.contains(MaterialState.selected)) {
                                            return colorScheme.primary;
                                          }
                                          return colorScheme.surface;
                                        }),
                                        checkColor: colorScheme.onPrimary,
                                        side: BorderSide(
                                          color: colorScheme.primary.withOpacity(0.3),
                                          width: 1,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    // Terms text
                                    Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                          style: textTheme.bodyMedium,
                                          children: [
                                            const TextSpan(text: 'I agree to the '),
                                            TextSpan(
                                              text: 'Terms & Conditions',
                                              style: textTheme.bodyMedium?.copyWith(
                                                color: colorScheme.primary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (_termsError.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0, left: 28.0),
                                    child: Text(
                                      _termsError,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Next button
                    if (!isKeyboardVisible) ...[
                      const SizedBox(height: 32),
                      CustomButton.primary(
                        text: "Send Code",
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

class RegisterPhoneScreenWrapper extends StatelessWidget {
  const RegisterPhoneScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return RegisterPhoneScreen(onBack: () => Navigator.pop(context));
  }
}
