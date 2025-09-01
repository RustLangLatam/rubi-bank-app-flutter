import 'package:flutter/cupertino.dart';

class EyeOffIconPainter extends CustomPainter {
  final Color color;

  EyeOffIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw crossed lines (simplified version)
    canvas.drawLine(
      Offset(size.width * 0.2, size.height * 0.2),
      Offset(size.width * 0.8, size.height * 0.8),
      paint,
    );

    canvas.drawLine(
      Offset(size.width * 0.8, size.height * 0.2),
      Offset(size.width * 0.2, size.height * 0.8),
      paint,
    );

    // Outer circle (crossed out eye)
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2.4,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
