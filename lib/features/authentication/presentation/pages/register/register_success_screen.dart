import 'package:flutter/material.dart';

import '../../../../../core/common/widgets/custom_button.dart';
import '../../../../../core/common/widgets/elegant_check_painter.dart';

class RegisterSuccessScreen extends StatefulWidget {
  final VoidCallback onGoToDashboard;
  final String userName;

  const RegisterSuccessScreen({
    super.key,
    required this.onGoToDashboard,
    required this.userName,
  });

  @override
  State<RegisterSuccessScreen> createState() => _RegisterSuccessScreenState();
}

class _RegisterSuccessScreenState extends State<RegisterSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuint),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color(0xFF22C55E).withOpacity(0.3),
                                width: 1.5,
                              ),
                            ),
                            child: CustomPaint(painter: ElegantCheckPainter()),
                          ),
                        ),
                      ),

                      const SizedBox(height: 48),

                      // Welcome Title
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          'Account Created',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      // Elegant Divider
                      const SizedBox(height: 32),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          width: 80,
                          height: 2,
                          color: const Color(0xFF22C55E).withOpacity(0.5),
                        ),
                      ),

                      // Success Message
                      const SizedBox(height: 32),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Línea 1
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "Your exclusive RubiBank account is now active.",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xFFA9B4C4),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Línea 2
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "We are delighted to have you with us.",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xFFA9B4C4),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Línea 3
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "Begin your unparalleled banking journey.",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xFFA9B4C4),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              Center(
                child: CustomButton(
                  text: "Access Dashboard",
                  onPressed: widget.onGoToDashboard,
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
