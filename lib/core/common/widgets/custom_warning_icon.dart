// Custom SVG-like icons (alternative if you want exact SVG paths)
import 'package:flutter/material.dart';

class CustomWarningIcon extends StatelessWidget {
  const CustomWarningIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(24, 24),
      painter: _WarningIconPainter(color: Colors.red[400]!),
    );
  }
}

class _WarningIconPainter extends CustomPainter {
  final Color color;

  _WarningIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(12, 9)
      ..lineTo(12, 12.75)
      ..moveTo(2.697, 16.126)
      ..cubicTo(1.832, 17.626, 2.915, 19.5, 4.645, 19.5)
      ..lineTo(19.355, 19.5)
      ..cubicTo(21.085, 19.5, 22.168, 17.626, 21.303, 16.126)
      ..lineTo(13.949, 3.378)
      ..cubicTo(13.084, 1.878, 10.916, 1.878, 10.051, 3.378)
      ..lineTo(2.697, 16.126)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}