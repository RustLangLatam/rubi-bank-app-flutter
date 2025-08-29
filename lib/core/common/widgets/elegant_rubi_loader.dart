import 'dart:math';

import 'package:flutter/material.dart';

class ElegantRubiLoader extends StatefulWidget {
  final double size;

  const ElegantRubiLoader({
    super.key,
    this.size = 96.0,
  });

  @override
  State<ElegantRubiLoader> createState() => _ElegantRubiLoaderState();
}

class _ElegantRubiLoaderState extends State<ElegantRubiLoader>
    with TickerProviderStateMixin {
  late AnimationController _spinController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();

    // Spin animation - 3 seconds linear infinite
    _spinController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    // Pulse animation - 2.5 seconds
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _spinController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        children: [
          // Spinning layer
          RotationTransition(
            turns: _spinController,
            child: CustomPaint(
              size: Size(widget.size, widget.size),
              painter: _DiamondPainter(
                showInnerLines: true,
                opacity: 0.4,
              ),
            ),
          ),

          // Pulsing layer
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              final pulseValue = _pulseController.value;
              final opacity = 0.4 + 0.4 * _calculatePulseOpacity(pulseValue);
              final scale = 0.95 + 0.1 * _calculatePulseScale(pulseValue);

              return Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity,
                  child: CustomPaint(
                    size: Size(widget.size, widget.size),
                    painter: _DiamondPainter(
                      showInnerLines: false,
                      opacity: 0.4,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  double _calculatePulseOpacity(double value) {
    return (sin(value * 2 * 3.14159) + 1) / 2; // Smooth pulse effect
  }

  double _calculatePulseScale(double value) {
    return (sin(value * 2 * 3.14159) + 1) / 2; // Smooth scale effect
  }
}

class _DiamondPainter extends CustomPainter {
  final bool showInnerLines;
  final double opacity;

  _DiamondPainter({
    required this.showInnerLines,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.35;

    final paint = Paint()
      ..color = Colors.white.withOpacity(opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    // Draw diamond shape
    final path = Path()
      ..moveTo(center.dx, center.dy - radius)
      ..lineTo(center.dx + radius, center.dy)
      ..lineTo(center.dx, center.dy + radius)
      ..lineTo(center.dx - radius, center.dy)
      ..close();

    canvas.drawPath(path, paint);

    if (showInnerLines) {
      final innerPaint = Paint()
        ..color = Colors.white.withOpacity(0.3 * opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;

      // Vertical line
      canvas.drawLine(
        Offset(center.dx, center.dy - radius),
        Offset(center.dx, center.dy + radius),
        innerPaint,
      );

      // Diagonal lines
      canvas.drawLine(
        Offset(center.dx - radius, center.dy),
        Offset(center.dx + radius, center.dy),
        innerPaint,
      );

      canvas.drawLine(
        Offset(center.dx, center.dy - radius),
        Offset(center.dx, center.dy + radius),
        innerPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DiamondPainter oldDelegate) {
    return oldDelegate.showInnerLines != showInnerLines ||
        oldDelegate.opacity != opacity;
  }
}