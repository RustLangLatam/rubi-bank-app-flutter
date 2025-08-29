import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rubi_bank_api_sdk/rubi_bank_api_sdk.dart';
import 'package:rubi_bank_app/features/authentication/presentation/pages/register/register_success_screen.dart';
import '../../../../../core/common/widgets/custom_button.dart';
import '../../../../../core/common/widgets/custom_back_button.dart';
import '../../../../../core/common/widgets/elegant_progress_indicator.dart';
import '../../../../../core/transitions/custom_page_route.dart';
import '../../providers/register_provider.dart';

class RegisterPhoneScreen extends StatefulWidget {
  final VoidCallback onBack;

  const RegisterPhoneScreen({super.key, required this.onBack});

  @override
  State<RegisterPhoneScreen> createState() => _RegisterPhoneScreenState();
}

class _RegisterPhoneScreenState extends State<RegisterPhoneScreen> {
  final _phoneNumberController = TextEditingController();
  bool _agreedToTerms = false;
  String _phoneError = '';
  String _termsError = '';

  @override
  void initState() {
    super.initState();
    // Prefill with existing customer data from provider
    final provider = Provider.of<RegisterProvider>(context, listen: false);
    if (provider.customer.phoneNumber.number.isNotEmpty) {
      _phoneNumberController.text = provider.customer.phoneNumber.number;
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
    final cleanedNumber = _phoneNumberController.text.replaceAll(
      RegExp(r'\D'),
      '',
    );
    return _phoneError.isEmpty &&
        _termsError.isEmpty &&
        cleanedNumber.isNotEmpty &&
        cleanedNumber.length >= 9 &&
        cleanedNumber.length <= 15 &&
        _agreedToTerms;
  }

  void _handleNext() {
    final cleanedNumber = _phoneNumberController.text.replaceAll(
      RegExp(r'\D'),
      '',
    );

    _validatePhoneNumber(_phoneNumberController.text);
    _validateTerms(_agreedToTerms);

    if (_areAllFieldsValid()) {
      final provider = Provider.of<RegisterProvider>(context, listen: false);

      final newPhone = Phone(
        (r) => r
          ..number = cleanedNumber
          ..countryCode = 1,
      );

      provider.updatePhone(newPhone);

      Navigator.pushNamed(context, '/register/otp');
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button with custom widget
              CustomBackButtonWithSpacing(
                onPressed: widget.onBack,
                color: colorScheme.secondary,
                spacing: 16,
              ),

              ElegantProgressIndicator(currentStep: 4, totalSteps: 4),
              const SizedBox(height: 32),

              // Title
              Text(
                'Phone Verification',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle
              Text(
                'Please enter your phone number. We will send you a verification code.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFFA9B4C4),
                ),
              ),
              const SizedBox(height: 40),

              // Form fields
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Country code prefix
                              Container(
                                constraints: const BoxConstraints(
                                  minHeight: 48,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.surface,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10.5),
                                    bottomLeft: Radius.circular(10.5),
                                  ),
                                  border: Border.all(
                                    color: colorScheme.surface.withOpacity(0.8),
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '+1',
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                ),
                              ),

                              // Phone number input
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: TextFormField(
                                    controller: _phoneNumberController,
                                    keyboardType: TextInputType.phone,
                                    style: theme.textTheme.bodyLarge,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: colorScheme.surface,
                                      hintText: 'Phone Number *',
                                      hintStyle: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: const Color(0xFF94A3B8),
                                          ),
                                      enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10.5),
                                          bottomRight: Radius.circular(10.5),
                                        ),
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                          width: 1,
                                        ),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10.5),
                                          bottomRight: Radius.circular(10.5),
                                        ),
                                        borderSide: BorderSide(
                                          color: Color(0xFFFCD34D),
                                          width: 1.5,
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                      border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10.5),
                                          bottomRight: Radius.circular(10.5),
                                        ),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    onChanged: (value) {
                                      final cleanedValue = value.replaceAll(
                                        RegExp(r'\D'),
                                        '',
                                      );
                                      if (value != cleanedValue) {
                                        _phoneNumberController
                                            .value = _phoneNumberController
                                            .value
                                            .copyWith(
                                              text: cleanedValue,
                                              selection:
                                                  TextSelection.collapsed(
                                                    offset: cleanedValue.length,
                                                  ),
                                            );
                                      }
                                      _validatePhoneNumber(cleanedValue);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),

                          if (_phoneError.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 8.0,
                                left: 8.0,
                              ),
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
                      const SizedBox(height: 20),

                      // Terms and conditions
                      Row(
                        children: [
                          // Checkbox
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: _agreedToTerms,
                              onChanged: (bool? value) {
                                setState(() {
                                  _agreedToTerms = value ?? false;
                                  _validateTerms(_agreedToTerms);
                                });
                              },
                              fillColor:
                                  MaterialStateProperty.resolveWith<Color>((
                                    Set<MaterialState> states,
                                  ) {
                                    if (states.contains(
                                      MaterialState.selected,
                                    )) {
                                      return colorScheme.secondary;
                                    }
                                    return colorScheme.surface.withOpacity(0.8);
                                  }),
                              checkColor: Colors.black,
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
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xFFA9B4C4),
                                ),
                                children: [
                                  const TextSpan(text: 'I agree to the '),
                                  TextSpan(
                                    text: 'Terms & Conditions',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.secondary,
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
                          padding: const EdgeInsets.only(top: 8.0, left: 36.0),
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
                ),
              ),

              // Next button
              const SizedBox(height: 32),
              CustomButton(
                text: "Send Code",
                onPressed: _handleNext,
                type: ButtonType.primary,
              ),
            ],
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
