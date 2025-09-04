import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Provider;
import 'package:rubi_bank_app/features/authentication/presentation/pages/register/register_success_screen.dart';

import '../../../../../core/common/theme/app_theme.dart';
import '../../../../../core/common/widgets/custom_back_button.dart';
import '../../../../../core/common/widgets/custom_button.dart';
import '../../../../../core/common/widgets/elegant_progress_indicator.dart';
import '../../../../../core/common/widgets/responsive_otp_fields.dart';
import '../../providers/register_provider.dart';
import 'create_customer_screen.dart';

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
    if (phone.length <= 3) return '+971 $phone';

    return '+971 (${phone.substring(0, 3)}) ${phone.substring(3, 6)}-${phone.substring(6)}';
  }

  bool get _isOtpComplete {
    return _otpControllers.every((controller) => controller.text.isNotEmpty);
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
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                CustomBackButton(
                  onPressed: widget.onBack,
                  color: colorScheme.onBackground,
                ),
                const SizedBox(height: 16),

                // Progress indicator
                ElegantProgressIndicator(
                  currentStep: 4,
                  totalSteps: 4,
                ),
                const SizedBox(height: 32),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Title
                        Text(
                          'Enter Verification Code',
                          style: textTheme.displayLarge?.copyWith(
                            fontSize: 30, // text-3xl
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),

                        // Subtitle with phone number
                        Text(
                          'A 6-digit code has been sent to',
                          style: textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formattedPhoneNumber,
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),

                        // OTP input fields
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: ResponsiveOtpFields(
                            controllers: _otpControllers,
                            focusNodes: _otpFocusNodes,
                            onChanged: _handleOtpChange,
                            enabled: !_isAutoFilling,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Resend code section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Didn't receive the code? ",
                              style: textTheme.bodySmall,
                            ),
                            _timer > 0
                                ? Text(
                              'Resend in ${_timer}s',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.shadow,
                              ),
                            )
                                : GestureDetector(
                              onTap: _handleResend,
                              child: Text(
                                'Resend Code',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Verify button
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: _isVerifying
                      ? ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.primary,
                        ),
                        strokeWidth: 2,
                      ),
                    ),
                  )
                      : CustomButton.primary(
                    text: "Verify",
                    onPressed: _isOtpComplete ? widget.onVerify : () {},
                  ),
                ),
              ],
            ),
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

    return RegisterOtpScreen(
      onBack: () => Navigator.pop(context),
      onVerify: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateCustomerScreen(
              onSuccess: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/dashboard',
                  arguments: registerState.customer,
                );
              },
              userName:
                  '${registerState.customer.givenName} ${registerState.customer.familyName}',
            ),
          ),
        );
      },
    );
  }
}
