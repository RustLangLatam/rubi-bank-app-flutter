import 'package:flutter/material.dart';

import 'eye_off_icon_painter.dart';

class EyeOffIcon extends StatelessWidget {
  final double size;
  final Color color;

  const EyeOffIcon({super.key, this.size = 24, this.color = Colors.grey});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: EyeOffIconPainter(color: color),
      ),
    );
  }
}
