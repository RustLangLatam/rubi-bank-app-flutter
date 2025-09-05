import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/common/theme/app_theme.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/common/widgets/rubi_bank_logo.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  void _navigateToLogin(BuildContext context) {
    Navigator.pushNamed(context, '/login');
  }

  void _navigateToRegister(BuildContext context) {
    Navigator.pushNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: AppTheme.appGradient(colorScheme),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(32.0), // Matches p-8 (8 * 4 = 32px)
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.menu,
                        size: 24, // Matches h-6 w-6
                        color: theme.colorScheme.onBackground, // #EAEBF0
                      ),
                      Text(
                        'RUBIBANK',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 20, // Matches text-xl
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary, // #C5A365
                          letterSpacing: 2.0, // Matches tracking-widest
                        ),
                      ),
                      const SizedBox(width: 24), // Placeholder for alignment
                    ],
                  ),
                  // Center Content
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(
                              186,
                              186,
                            ), // Matches w-48 h-48 (48 * 4 = 192px)
                            painter: DecorativeCirclePainter(),
                          ),
                          RubiBankLogo(
                            size: 112, // Matches w-28 h-28 (28 * 4 = 112px)
                            color: theme.colorScheme.primary, // #C5A365
                          ),
                        ],
                      ),
                      const SizedBox(height: 32), // Matches mt-8
                      Text(
                        'Premium Banking',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 30, // Matches text-3xl
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface, // #FFFFFF
                        ),
                      ),
                      const SizedBox(height: 12), // Matches mb-3
                      Text(
                        'At Your Fingertips',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 30, // Matches text-3xl
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface, // #FFFFFF
                        ),
                      ),
                      const SizedBox(height: 16), // Matches mb-4
                      Text(
                        'Join an exclusive banking experience designed for the discerning individual.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 14, // Matches text-sm
                          color: theme
                              .colorScheme
                              .shadow, // Matches text-muted (#7A8C99)
                          height: 1.5, // Matches leading-relaxed
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                  // Buttons
                  Column(
                    children: [
                      CustomButton.primary(
                        text: 'Create an Account',
                        onPressed: () => _navigateToRegister(context),
                        trailingIcon: const Icon(
                          Icons.chevron_right,
                          size: 24, // Matches h-5 w-5
                          color: Color(0xFF060B14), // onPrimary
                        ),
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                      const SizedBox(height: 12), // Matches gap-3
                      CustomButton.muted(
                        text: 'Sign In',
                        onPressed: () => _navigateToLogin(context),
                      ),
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

class DecorativeCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 1;

    // Gradient circle stroke
    final circlePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFC5A365), // primary
          Color(0xFFA47D42), // darker primary
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..color = Colors.white.withOpacity(0.3); // Matches opacity="0.3"

    canvas.drawCircle(center, radius, circlePaint);

    for (int i = 0; i < 72; i++) {
      final angle =
          (i * 5) * (3.141592653589793 / 180); // Convert degrees to radians
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle);
      canvas.translate(-center.dx, -center.dy);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
