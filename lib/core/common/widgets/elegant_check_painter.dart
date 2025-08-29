import 'package:flutter/material.dart';

class ElegantCheckPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint checkPaint = Paint()
      ..color = const Color(0xFF22C55E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 // Línea muy delgada
      ..strokeCap = StrokeCap.round;

    // Check mark minimalista
    final Path checkPath = Path();

    checkPath.moveTo(size.width * 0.3, size.height * 0.5);
    checkPath.lineTo(size.width * 0.45, size.height * 0.65);
    checkPath.lineTo(size.width * 0.7, size.height * 0.35);

    canvas.drawPath(checkPath, checkPaint);

    // Puntos de énfasis en los extremos
    final Paint dotPaint = Paint()
      ..color = const Color(0xFF22C55E)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.5), 1.5, dotPaint);
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.35), 1.5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}