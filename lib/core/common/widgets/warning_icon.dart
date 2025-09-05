import 'package:flutter/material.dart';

// Icons for the modal
class WarningIcon extends StatelessWidget {
  const WarningIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.warning_amber_rounded,
        size: 24,
        color: Colors.red[400],
      ),
    );
  }
}