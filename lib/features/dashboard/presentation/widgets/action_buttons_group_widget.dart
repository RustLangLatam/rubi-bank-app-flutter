import 'package:flutter/material.dart';
import '../../../../core/common/theme/app_theme.dart';

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

// Painters for each icon - Ajustados para viewBox 0 0 24 24
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

    // Ajustado para viewBox 24x24
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

  _MoreIconPainter({required this.color});

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
      ..moveTo(5, 12)
      ..lineTo(19, 12)
      ..moveTo(5, 12)
      ..cubicTo(5, 10.895, 5.895, 10, 7, 10)
      ..lineTo(17, 10)
      ..cubicTo(18.105, 10, 19, 10.895, 19, 12)
      ..cubicTo(19, 13.105, 18.105, 14, 17, 14)
      ..lineTo(7, 14)
      ..cubicTo(5.895, 14, 5, 13.105, 5, 12)
      ..moveTo(5, 12)
      ..cubicTo(5, 13.105, 5.895, 14, 7, 14)
      ..lineTo(17, 14)
      ..cubicTo(18.105, 14, 19, 13.105, 19, 12)
      ..cubicTo(19, 10.895, 18.105, 10, 17, 10)
      ..lineTo(7, 10)
      ..cubicTo(5.895, 10, 5, 10.895, 5, 12);

    canvas.drawPath(path, paint);
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