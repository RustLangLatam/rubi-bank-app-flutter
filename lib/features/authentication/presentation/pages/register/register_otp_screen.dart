import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Provider;
import 'package:rubi_bank_api_sdk/rubi_bank_api_sdk.dart';
import 'package:rubi_bank_app/features/authentication/presentation/pages/register/register_success_screen.dart';
import '../../../../../core/common/widgets/custom_button.dart';
import '../../../../../core/common/widgets/custom_back_button.dart';
import '../../../../../core/common/widgets/elegant_progress_indicator.dart';
import '../../../../../core/transitions/custom_page_route.dart';
import '../../providers/create_customer_provider.dart';
import '../../providers/register_provider.dart';

class RegisterOtpScreen extends ConsumerStatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onVerify;

  const RegisterOtpScreen({
    super.key,
    required this.onBack,
    required this.onVerify,
  });

  @override
  ConsumerState<RegisterOtpScreen> createState() => _RegisterOtpScreenState();
}

class _RegisterOtpScreenState extends ConsumerState<RegisterOtpScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );
  int _timer = 60;
  late String _generatedOtp;
  bool _isAutoFilling = false;
  bool _isVerifying = false;
  late Timer _timerController;

  @override
  void initState() {
    super.initState();
    _generatedOtp = _generateRandomOtp();
    _startTimer();
    _simulateAutoFill();
  }

  @override
  void dispose() {
    _timerController.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  String _generateRandomOtp() {
    final random = DateTime.now().millisecondsSinceEpoch;
    return (random % 900000 + 100000).toString(); // 6-digit number
  }

  void _startTimer() {
    _timerController = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && _timer > 0) {
        setState(() => _timer--);
      } else {
        timer.cancel();
      }
    });
  }

  void _stopTimer() {
    _timerController.cancel();
  }

  void _simulateAutoFill() {
    setState(() => _isAutoFilling = true);

    // Simulate waiting 2 seconds then auto-fill
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        for (int i = 0; i < 6; i++) {
          _otpControllers[i].text = _generatedOtp[i];
        }
        setState(() => _isAutoFilling = false);
        _stopTimer(); // Stop timer when OTP is filled

        // Auto-verify after 1 second
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            _verifyOtp();
          }
        });
      }
    });
  }

  void _handleOtpChange(String value, int index) {
    if (value.isNotEmpty && !RegExp(r'^\d$').hasMatch(value)) return;

    if (value.isNotEmpty && index < 5) {
      _otpFocusNodes[index + 1].requestFocus();
    }

    if (value.isEmpty && index > 0) {
      _otpFocusNodes[index - 1].requestFocus();
    }

    // Stop timer if all fields are filled
    if (_isOtpComplete) {
      _stopTimer();

      // Auto-verify after 1 second
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          _verifyOtp();
        }
      });
    }
  }

  void _verifyOtp() {
    if (_isVerifying) return;

    setState(() => _isVerifying = true);

    // Simulate verification process
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isVerifying = false);
        widget.onVerify();
      }
    });
  }

  void _handleResend() {
    setState(() {
      _timer = 60;
      _generatedOtp = _generateRandomOtp();

      // Clear all OTP fields
      for (var controller in _otpControllers) {
        controller.clear();
      }

      // Restart timer and auto-fill simulation
      _startTimer();
      _simulateAutoFill();
    });
  }

  String get _formattedPhoneNumber {
    final registerState = ref.watch(registerProvider);
    final phone = registerState.customer.phoneNumber.number;
    if (phone.length <= 3) return '+1 $phone';

    return '+1 (${phone.substring(0, 3)}) ${phone.substring(3, 6)}-${phone.substring(6)}';
  }

  bool get _isOtpComplete {
    return _otpControllers.every((controller) => controller.text.isNotEmpty);
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
              // Back button
              CustomBackButton(
                onPressed: widget.onBack,
                color: colorScheme.secondary,
              ),
              const SizedBox(height: 16),

              // Progress indicator (hidden, just for layout)
              ElegantProgressIndicator(
                currentStep: 4,
                totalSteps: 4,
                color: _isOtpComplete ? Colors.green: null,
              ),
              const SizedBox(height: 32),

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title
                  Text(
                    'Enter Verification Code',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Subtitle with phone number
                  Text(
                    'A 6-digit code has been sent to',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFFA9B4C4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formattedPhoneNumber,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // OTP input fields
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      return Container(
                        width: 48,
                        height: 56,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        child: TextField(
                          controller: _otpControllers[index],
                          focusNode: _otpFocusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: colorScheme.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: colorScheme.surface.withOpacity(0.8),
                                width: 1,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: colorScheme.surface.withOpacity(0.8),
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: colorScheme.secondary,
                                width: 1.5,
                              ),
                            ),
                          ),
                          onChanged: (value) => _handleOtpChange(value, index),
                          enabled: !_isAutoFilling,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),

                  // Resend code section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Didn't receive the code? ",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: const Color(0xFFA9B4C4),
                        ),
                      ),
                      _timer > 0
                          ? Text(
                              'Resend in ${_timer}s',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: const Color(0xFF94A3B8),
                              ),
                            )
                          : GestureDetector(
                              onTap: _handleResend,
                              child: Text(
                                'Resend Code',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.secondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                    ],
                  ),
                ],
              ),

              // Spacer to push content to top
              const Expanded(child: SizedBox()),

              // Verify button with progress indicator
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: _isVerifying
                    ? ElevatedButton(
                        onPressed: null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.secondary,
                          foregroundColor: colorScheme.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              colorScheme.secondary,
                            ),
                            strokeWidth: 2,
                          ),
                        ),
                      )
                    : CustomButton(
                        text: "Verify",
                        onPressed: _isOtpComplete ? widget.onVerify : () {},
                        type: ButtonType.primary,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterOtpScreenWrapper extends ConsumerWidget {
  const RegisterOtpScreenWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerState = ref.watch(registerProvider);
    final createCustomerState = ref.watch(createCustomerProvider);

    return RegisterOtpScreen(
      onBack: () => Navigator.pop(context),
      onVerify: () async {
        try {
          await ref.read(createCustomerProvider.notifier).createCustomer(
            customer: registerState.customer,
            password: registerState.password,
          );

          if (createCustomerState is AsyncData<Customer> && createCustomerState.value != null) {
            Navigator.push(
              context,
              CustomPageRoute.fade(
                RegisterSuccessScreen(
                  onGoToDashboard: () => Navigator.pop(context),
                  userName: '${registerState.customer.givenName} ${registerState.customer.familyName}',
                ),
              ),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
    );
  }
}