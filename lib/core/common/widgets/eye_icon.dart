import 'package:flutter/material.dart';

class EyeIcon extends StatelessWidget {
  final double size;
  final Color color;

  const EyeIcon({super.key, this.size = 24, this.color = Colors.grey});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _EyeIconPainter(color: color),
      ),
    );
  }
}

class _EyeIconPainter extends CustomPainter {
  final Color color;

  _EyeIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Circle (eye)
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 6,
      paint,
    );

    // Outer circle (eye outline)
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2.4,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
