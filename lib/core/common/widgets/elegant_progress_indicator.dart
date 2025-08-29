import 'package:flutter/material.dart';

class ElegantProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final Color? color;


  const ElegantProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Step $currentStep of $totalSteps',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(totalSteps, (index) {
            final isActive = index < currentStep;
            final isLast = index == totalSteps - 1;

            return Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: isActive ? color ?? colorScheme.secondary : const Color(0xFF304A6E),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  if (!isLast)
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color:Colors.transparent,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}