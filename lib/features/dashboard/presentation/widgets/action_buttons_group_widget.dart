import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback? onPressed;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          // Icon container with exact dimensions and centered icon
          Container(
            width: 56, // w-14 (14 * 4 = 56)
            height: 56, // h-14
            decoration: BoxDecoration(
              color: colorScheme.surface.withOpacity(0.5), // bg-surface-dark/50
              borderRadius: BorderRadius.circular(28), // rounded-full
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center( // ← AÑADIDO: Centra el icono perfectamente
              child: SizedBox(
                width: 24, // h-6 w-6 exact size
                height: 24,
                child: icon,
              ),
            ),
          ),
          const SizedBox(height: 8), // gap-2
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.shadow, // text-muted
              fontSize: 12, // text-xs
              fontWeight: FontWeight.w600, // font-semibold
            ),
          ),
        ],
      ),
    );
  }
}

// Custom SVG icons as Widgets with proper centering
class SendIcon extends StatelessWidget {
  final Color color;

  const SendIcon({super.key, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SendIconPainter(color: color),
    );
  }
}

class ReceiveIcon extends StatelessWidget {
  final Color color;

  const ReceiveIcon({super.key, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ReceiveIconPainter(color: color),
    );
  }
}

class BillsIcon extends StatelessWidget {
  final Color color;

  const BillsIcon({super.key, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BillsIconPainter(color: color),
    );
  }
}

class MoreIcon extends StatelessWidget {
  final Color color;

  const MoreIcon({super.key, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _MoreIconPainter(color: color),
    );
  }
}

class _SendIconPainter extends CustomPainter {
  final Color color;

  _SendIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final scale = size.width / 24;
    canvas.save();
    canvas.scale(scale);

    final path = Path()
      ..moveTo(12, 19)
      ..lineTo(21, 21)
      ..lineTo(12, 3)
      ..lineTo(3, 21)
      ..lineTo(12, 19)
      ..moveTo(12, 19)
      ..lineTo(12, 11);

    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ReceiveIconPainter extends CustomPainter {
  final Color color;

  _ReceiveIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final scale = size.width / 24;
    canvas.save();
    canvas.scale(scale);

    final path = Path()
      ..moveTo(12, 4.5)
      ..lineTo(12, 19.5)
      ..moveTo(12, 19.5)
      ..lineTo(18.75, 12.75)
      ..moveTo(12, 19.5)
      ..lineTo(5.25, 12.75);

    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BillsIconPainter extends CustomPainter {
  final Color color;

  _BillsIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final scale = size.width / 24;
    canvas.save();
    canvas.scale(scale);

    final path = Path()
      ..moveTo(9, 12)
      ..lineTo(15, 12)
      ..moveTo(9, 16)
      ..lineTo(15, 16)
      ..moveTo(17, 21)
      ..lineTo(7, 21)
      ..cubicTo(5.895, 21, 5, 20.105, 5, 19)
      ..lineTo(5, 5)
      ..cubicTo(5, 3.895, 5.895, 3, 7, 3)
      ..lineTo(12.586, 3)
      ..cubicTo(12.851, 3, 13.105, 3.105, 13.293, 3.293)
      ..lineTo(18.707, 8.707)
      ..cubicTo(18.895, 8.895, 19, 9.149, 19, 9.414)
      ..lineTo(19, 19)
      ..cubicTo(19, 20.105, 18.105, 21, 17, 21)
      ..close();

    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MoreIconPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _MoreIconPainter({
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

    // Draw the horizontal line: M5 12h14
    canvas.drawLine(
      const Offset(5, 12),
      const Offset(19, 12),
      paint,
    );

    // Draw the top rectangle: M5 12a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v4a2 2 0 01-2 2
    final topRect = Path()
      ..moveTo(5, 12)
      ..addRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTRB(3, 4, 21, 12),
          const Radius.circular(2),
        ),
      );
    canvas.drawPath(topRect, paint);

    // Draw the bottom rectangle: M5 12a2 2 0 00-2 2v4a2 2 0 002 2h14a2 2 0 002-2v-4a2 2 0 00-2-2
    final bottomRect = Path()
      ..moveTo(5, 12)
      ..addRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTRB(3, 12, 21, 20),
          const Radius.circular(2),
        ),
      );
    canvas.drawPath(bottomRect, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ActionButtonsGroup extends StatelessWidget {
  final VoidCallback? onSend;
  final VoidCallback? onReceive;
  final VoidCallback? onBills;
  final VoidCallback? onMore;

  const ActionButtonsGroup({
    super.key,
    this.onSend,
    this.onReceive,
    this.onBills,
    this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8), // py-2
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ActionButton(
            icon: SendIcon(color: theme.colorScheme.primary),
            label: 'Send',
            onPressed: onSend,
          ),
          ActionButton(
            icon: ReceiveIcon(color: theme.colorScheme.primary),
            label: 'Request',
            onPressed: onReceive,
          ),
          ActionButton(
            icon: BillsIcon(color: theme.colorScheme.primary),
            label: 'Bills',
            onPressed: onBills,
          ),
          ActionButton(
            icon: MoreIcon(color: theme.colorScheme.primary),
            label: 'More',
            onPressed: onMore,
          ),
        ],
      ),
    );
  }
}