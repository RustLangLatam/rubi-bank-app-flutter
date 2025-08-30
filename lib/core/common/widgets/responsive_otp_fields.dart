import 'package:flutter/material.dart';
import 'dart:math' as math;

class ResponsiveOtpFields extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final Function(String, int) onChanged;
  final bool enabled;
  final ThemeData theme;
  final int fieldCount;
  final double maxFieldWidth;
  final double minFieldWidth;
  final double maxSpacing;
  final double minSpacing;
  final double fieldHeight;

  const ResponsiveOtpFields({
    super.key,
    required this.controllers,
    required this.focusNodes,
    required this.onChanged,
    required this.enabled,
    required this.theme,
    this.fieldCount = 6,
    this.maxFieldWidth = 48.0,
    this.minFieldWidth = 40.0,
    this.maxSpacing = 8.0,
    this.minSpacing = 4.0,
    this.fieldHeight = 56.0,
  });

  @override
  Widget build(BuildContext context) {
    final  colorScheme = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;

        // Calculate a base field width and spacing that scales with available width
        // We want the fields to grow up to maxFieldWidth and spacing up to maxSpacing
        // while always fitting within the available width.

        // Determine target field width and spacing based on responsive breakpoints or direct calculation
        final responsiveFieldWidth = availableWidth > 400 ? maxFieldWidth : minFieldWidth;
        final responsiveSpacing = availableWidth > 400 ? maxSpacing : minSpacing;

        // Calculate the total space taken by fields and initial spacing
        final totalSpacingSlots = fieldCount - 1;
        final totalWidthForFieldsAndSpacing = (responsiveFieldWidth * fieldCount) + (responsiveSpacing * totalSpacingSlots);

        double actualFieldWidth;
        double actualSpacing;

        if (totalWidthForFieldsAndSpacing > availableWidth) {
          // Let's assume equal spacing is desired, so total fields + total spacing sections
          // are our "units" to divide the remaining width by.
          // For simplicity, we can aim for a fixed ratio of field width to spacing,
          // or just ensure the fields take up as much as possible while maintaining spacing.

          // A more robust approach:
          // We know: (fieldWidth * fieldCount) + (spacing * totalSpacingSlots) = availableWidth
          // And we want to maintain a certain ratio, or prioritize field size.
          // Let's prioritize fitting the fields nicely.
          actualSpacing = minSpacing; // Start with minimum spacing to maximize field width
          actualFieldWidth = (availableWidth - (actualSpacing * totalSpacingSlots)) / fieldCount;

          // Ensure field width doesn't go below minFieldWidth if possible
          if (actualFieldWidth < minFieldWidth) {
            actualFieldWidth = minFieldWidth;
            actualSpacing = (availableWidth - (actualFieldWidth * fieldCount)) / totalSpacingSlots;
            if (actualSpacing < 0) actualSpacing = 0; // Prevent negative spacing
          }

        } else {
          // If ideal responsive size fits, we can either:
          // 1. Center the block of fields with the calculated sizes.
          // 2. Expand fields and/or spacing to fill the available width.
          // To "take advantage of all available width," we'll expand.
          // We can use the responsiveFieldWidth and responsiveSpacing as initial targets.

          actualFieldWidth = responsiveFieldWidth;
          actualSpacing = responsiveSpacing;

          // Now, we distribute the remaining extra space.
          final extraWidth = availableWidth - totalWidthForFieldsAndSpacing;

          // We can either add this extra width to each field, or to each spacing.
          // A common approach is to distribute it proportionally or just add it to spacing.
          // Let's try distributing it to spacing to keep field sizes more consistent if desired.
          if (totalSpacingSlots > 0) {
            actualSpacing += extraWidth / totalSpacingSlots;
            // Cap spacing at maxSpacing if it becomes too large
            actualSpacing = math.min(actualSpacing, maxSpacing);
          } else if (fieldCount == 1) {
            actualFieldWidth = availableWidth; // If only one field, it takes all width
          }
        }

        // Ensure field width is within bounds
        actualFieldWidth = math.max(minFieldWidth, actualFieldWidth);
        actualFieldWidth = math.min(maxFieldWidth, actualFieldWidth);

        // Ensure spacing is within bounds
        actualSpacing = math.max(minSpacing, actualSpacing);
        actualSpacing = math.min(maxSpacing, actualSpacing);


        return SizedBox(
          width: availableWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // This will spread out fields
            children: List.generate(fieldCount, (index) {
              return SizedBox(
                width: actualFieldWidth,
                height: fieldHeight,
                child: TextField(
                  controller: controllers[index],
                  focusNode: focusNodes[index],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontSize: actualFieldWidth > 42 ? 24 : 20,
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    filled: true,
                    fillColor: colorScheme.surface,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (value) => onChanged(value, index),
                  enabled: enabled,
                ),
              );
            }),
          ),
        );
      },
    );
  }
}