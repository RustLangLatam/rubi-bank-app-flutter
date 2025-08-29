import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/common/widgets/custom_button.dart';
import '../../../../../core/common/widgets/elegant_check_painter.dart';
import '../../providers/register_provider.dart';

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
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutQuint,
      ),
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
    final provider = Provider.of<RegisterProvider>(context, listen: false);
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
                            child: CustomPaint(
                              painter: ElegantCheckPainter(),
                            ),
                          ),
                        ),
                      ),

                      // Spacing
                      const SizedBox(height: 48),

                      // Welcome Title
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          'WELCOME TO RUBIBANK',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      // Client Name
                      const SizedBox(height: 8),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          widget.userName.isNotEmpty ? widget.userName : 'VALUED CLIENT',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
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
                        child: Text(
                          "You now have access to exclusive financial services designed for discerning clients.",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.6,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              CustomButton(
                text: "Access Dashboard",
                onPressed: widget.onGoToDashboard,
                type: ButtonType.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}