// custom_icons.dart
import 'package:flutter/material.dart';

class CardIcon extends StatelessWidget {
  final double size;
  final Color color;

  const CardIcon({super.key, this.size = 24, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CardIconPainter(color: color),
      ),
    );
  }
}

class _CardIconPainter extends CustomPainter {
  final Color color;

  _CardIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(size.width * 0.0625, size.height * 0.34375);
    path.lineTo(size.width * 0.9375, size.height * 0.34375);
    path.moveTo(size.width * 0.0625, size.height * 0.375);
    path.lineTo(size.width * 0.9375, size.height * 0.375);
    path.moveTo(size.width * 0.25, size.height * 0.6875);
    path.lineTo(size.width * 0.4375, size.height * 0.6875);
    path.moveTo(size.width * 0.25, size.height * 0.8125);
    path.lineTo(size.width * 0.5, size.height * 0.8125);
    path.moveTo(size.width * 0.1875, size.height * 0.875);
    path.lineTo(size.width * 0.8125, size.height * 0.875);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class LoanIcon extends StatelessWidget {
  final double size;
  final Color color;

  const LoanIcon({super.key, this.size = 24, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _LoanIconPainter(color: color),
      ),
    );
  }
}

class _LoanIconPainter extends CustomPainter {
  final Color color;

  _LoanIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
