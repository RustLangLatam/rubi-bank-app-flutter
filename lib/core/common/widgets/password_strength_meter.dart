import 'package:flutter/material.dart';

class PasswordStrengthMeter extends StatelessWidget {
  final int score;
  final String label;

  const PasswordStrengthMeter({super.key, required this.score, required this.label});

  @override
  Widget build(BuildContext context) {
    final Map<int, Color> strengthColors = {
      1: Colors.red,
      2: Colors.yellow,
      3: Colors.green,
      4: Colors.green,
    };

    final color = strengthColors[score] ?? Colors.grey;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                children: List.generate(4, (index) {
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: index < score ? color : const Color(0xFF304A6E),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
