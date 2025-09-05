import 'package:flutter/material.dart';

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
