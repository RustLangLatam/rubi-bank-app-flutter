import 'package:flutter/material.dart';

class InfoIcon extends StatelessWidget {
  const InfoIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.info_outline_rounded,
        size: 24,
        color: Colors.blue[400],
      ),
    );
  }
}
