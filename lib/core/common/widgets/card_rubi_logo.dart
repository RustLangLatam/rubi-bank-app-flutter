import 'package:flutter/material.dart';

class CardRubiLogo extends StatelessWidget {
  const CardRubiLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: CustomPaint(
        painter: _RubiLogoPainter(),
      ),
    );
  }
}

class _RubiLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // Diamond shape
    path.moveTo(size.width * 0.5, size.height * 0.05);
    path.lineTo(size.width * 0.9, size.height * 0.35);
    path.lineTo(size.width * 0.75, size.height * 0.9);
    path.lineTo(size.width * 0.25, size.height * 0.9);
    path.lineTo(size.width * 0.1, size.height * 0.35);
    path.close();

    // Draw with opacity
    paint.color = Colors.white.withOpacity(0.3);
    canvas.drawPath(path, paint);

    // Vertical line
    paint.strokeWidth = 3;
    paint.color = Colors.white.withOpacity(0.2);
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.05),
      Offset(size.width * 0.5, size.height * 0.9),
      paint,
    );

    // Diagonal lines
    canvas.drawLine(
      Offset(size.width * 0.1, size.height * 0.35),
      Offset(size.width * 0.75, size.height * 0.9),
      paint,
    );

    canvas.drawLine(
      Offset(size.width * 0.9, size.height * 0.35),
      Offset(size.width * 0.25, size.height * 0.9),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}