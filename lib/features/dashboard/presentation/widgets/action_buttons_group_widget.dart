import 'package:flutter/material.dart';

class SendIcon extends StatelessWidget {
  final double size;
  final Color color;

  const SendIcon({super.key, this.size = 24, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _SendIconPainter(color: color),
      ),
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
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(size.width * 0.1875, size.height * 0.4375); // M4.5 10.5
    path.lineTo(size.width * 0.5, size.height * 0.125); // L12 3
    path.moveTo(size.width * 0.5, size.height * 0.125); // m0 0
    path.lineTo(size.width * 0.8125, size.height * 0.4375); // l7.5 7.5
    path.moveTo(size.width * 0.5, size.height * 0.125); // M12 3
    path.lineTo(size.width * 0.5, size.height * 0.875); // v18

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ReceiveIcon extends StatelessWidget {
  final double size;
  final Color color;

  const ReceiveIcon({super.key, this.size = 24, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ReceiveIconPainter(color: color),
      ),
    );
  }
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
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(size.width * 0.8125, size.height * 0.5625); // M19.5 13.5
    path.lineTo(size.width * 0.5, size.height * 0.875); // L12 21
    path.moveTo(size.width * 0.5, size.height * 0.875); // m0 0
    path.lineTo(size.width * 0.1875, size.height * 0.5625); // l-7.5-7.5
    path.moveTo(size.width * 0.5, size.height * 0.875); // M12 21
    path.lineTo(size.width * 0.5, size.height * 0.125); // V3

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BillsIcon extends StatelessWidget {
  final double size;
  final Color color;

  const BillsIcon({super.key, this.size = 24, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _BillsIconPainter(color: color),
      ),
    );
  }
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
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // Document shape
    path.moveTo(size.width * 0.2917, size.height * 0.125); // M7 5
    path.lineTo(size.width * 0.2917, size.height * 0.7917); // V19
    path.lineTo(size.width * 0.7083, size.height * 0.7917); // H17
    path.lineTo(size.width * 0.7083, size.height * 0.2917); // V9
    path.lineTo(size.width * 0.5833, size.height * 0.2917); // H12
    path.lineTo(size.width * 0.5833, size.height * 0.125); // V5
    path.lineTo(size.width * 0.2917, size.height * 0.125); // H7
    path.close();

    // Horizontal lines inside document
    path.moveTo(size.width * 0.375, size.height * 0.375);
    path.lineTo(size.width * 0.625, size.height * 0.375);

    path.moveTo(size.width * 0.375, size.height * 0.4583);
    path.lineTo(size.width * 0.625, size.height * 0.4583);

    path.moveTo(size.width * 0.375, size.height * 0.5417);
    path.lineTo(size.width * 0.625, size.height * 0.5417);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AddIcon extends StatelessWidget {
  final double size;
  final Color color;

  const AddIcon({super.key, this.size = 24, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _AddIconPainter(color: color),
      ),
    );
  }
}

class _AddIconPainter extends CustomPainter {
  final Color color;

  _AddIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Plus sign
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.1875), // M12 4.5
      Offset(size.width * 0.5, size.height * 0.8125), // v15
      paint,
    );

    canvas.drawLine(
      Offset(size.width * 0.1875, size.height * 0.5), // m7.5-7.5
      Offset(size.width * 0.8125, size.height * 0.5), // h15
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? const Color(0xFFA9B4C4) : const Color(0xFF4B5563);
    final iconColor = isDark ? const Color(0xFFFFD700) : const Color(0xFF1E3A8A);
    final bgColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFF3F4F6);

    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconTheme(
              data: IconThemeData(color: iconColor, size: 24),
              child: icon,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class ActionButtonsGroupWidget extends StatelessWidget {
  final VoidCallback? onSend;
  final VoidCallback? onReceive;
  final VoidCallback? onPayBills;
  final VoidCallback? onAddAccount;

  const ActionButtonsGroupWidget({
    super.key,
    this.onSend,
    this.onReceive,
    this.onPayBills,
    this.onAddAccount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ActionButton(
          icon: const SendIcon(),
          label: 'Send',
          onPressed: onSend,
        ),
        ActionButton(
          icon: const ReceiveIcon(),
          label: 'Receive',
          onPressed: onReceive,
        ),
        ActionButton(
          icon: const BillsIcon(),
          label: 'Pay Bills',
          onPressed: onPayBills,
        ),
        ActionButton(
          icon: const AddIcon(),
          label: 'Add Account',
          onPressed: onAddAccount,
        ),
      ],
    );
  }
}