import 'package:flutter/material.dart';

class QrCodeIcon extends StatelessWidget {
  const QrCodeIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(24, 24),
      painter: _QrCodeIconPainter(color: Theme.of(context).colorScheme.onBackground),
    );
  }
}

class _QrCodeIconPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _QrCodeIconPainter({
    required this.color,
    this.strokeWidth = 1.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final scale = size.width / 24;
    canvas.save();
    canvas.scale(scale);

    // Draw the QR code pattern
    // Top-left corner
    canvas.drawRect(const Rect.fromLTRB(3.75, 3.75, 6.75, 6.75), paint);
    canvas.drawRect(const Rect.fromLTRB(3.75, 9.75, 6.75, 12.75), paint);
    canvas.drawRect(const Rect.fromLTRB(9.75, 3.75, 12.75, 6.75), paint);

    // Top-right corner
    canvas.drawRect(const Rect.fromLTRB(17.25, 3.75, 20.25, 6.75), paint);

    // Bottom-left corner
    canvas.drawRect(const Rect.fromLTRB(3.75, 17.25, 6.75, 20.25), paint);

    // Bottom-right corner
    canvas.drawRect(const Rect.fromLTRB(17.25, 17.25, 20.25, 20.25), paint);

    // Middle patterns
    canvas.drawRect(const Rect.fromLTRB(9.75, 9.75, 12.75, 12.75), paint);
    canvas.drawRect(const Rect.fromLTRB(15.75, 9.75, 18.75, 12.75), paint);
    canvas.drawRect(const Rect.fromLTRB(9.75, 15.75, 12.75, 18.75), paint);
    canvas.drawRect(const Rect.fromLTRB(15.75, 15.75, 18.75, 18.75), paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}