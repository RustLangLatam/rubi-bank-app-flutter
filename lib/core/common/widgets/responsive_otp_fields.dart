import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

import '../../../../../core/common/theme/app_theme.dart';

class ResponsiveOtpFields extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final Function(String, int) onChanged;
  final bool enabled;
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
    this.fieldCount = 6,
    this.maxFieldWidth = 48.0,
    this.minFieldWidth = 40.0,
    this.maxSpacing = 8.0,
    this.minSpacing = 4.0,
    this.fieldHeight = 56.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;

        // Calculate a base field width and spacing that scales with available width
        final responsiveFieldWidth = availableWidth > 400 ? maxFieldWidth : minFieldWidth;
        final responsiveSpacing = availableWidth > 400 ? maxSpacing : minSpacing;

        // Calculate the total space taken by fields and initial spacing
        final totalSpacingSlots = fieldCount - 1;
        final totalWidthForFieldsAndSpacing = (responsiveFieldWidth * fieldCount) + (responsiveSpacing * totalSpacingSlots);

        double actualFieldWidth;
        double actualSpacing;

        if (totalWidthForFieldsAndSpacing > availableWidth) {
          actualSpacing = minSpacing;
          actualFieldWidth = (availableWidth - (actualSpacing * totalSpacingSlots)) / fieldCount;

          if (actualFieldWidth < minFieldWidth) {
            actualFieldWidth = minFieldWidth;
            actualSpacing = (availableWidth - (actualFieldWidth * fieldCount)) / totalSpacingSlots;
            if (actualSpacing < 0) actualSpacing = 0;
          }
        } else {
          actualFieldWidth = responsiveFieldWidth;
          actualSpacing = responsiveSpacing;

          final extraWidth = availableWidth - totalWidthForFieldsAndSpacing;

          if (totalSpacingSlots > 0) {
            actualSpacing += extraWidth / totalSpacingSlots;
            actualSpacing = math.min(actualSpacing, maxSpacing);
          } else if (fieldCount == 1) {
            actualFieldWidth = availableWidth;
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(fieldCount, (index) {
              return SizedBox(
                width: actualFieldWidth,
                height: fieldHeight,
                child: AnimatedOtpDigit(
                  controller: controllers[index],
                  focusNode: focusNodes[index],
                  onChanged: (value) => onChanged(value, index),
                  enabled: enabled,
                  fieldWidth: actualFieldWidth,
                  fieldHeight: fieldHeight,
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

class AnimatedOtpDigit extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChanged;
  final bool enabled;
  final double fieldWidth;
  final double fieldHeight;

  const AnimatedOtpDigit({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.enabled,
    required this.fieldWidth,
    required this.fieldHeight,
  });

  @override
  State<AnimatedOtpDigit> createState() => _AnimatedOtpDigitState();
}

class _AnimatedOtpDigitState extends State<AnimatedOtpDigit> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  String _currentValue = '';
  String _previousValue = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _currentValue = widget.controller.text;
    widget.controller.addListener(_handleTextChange);
  }

  void _handleTextChange() {
    if (widget.controller.text != _currentValue) {
      setState(() {
        _previousValue = _currentValue;
        _currentValue = widget.controller.text;
        _animationController.forward(from: 0.0);
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    widget.controller.removeListener(_handleTextChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final fontSize = widget.fieldWidth > 42 ? 24.0 : 20.0;

    return Stack(
      children: [
        TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,
          style: const TextStyle(
            fontSize: 0,
            color: Colors.transparent,
          ),
          decoration: const InputDecoration(
            counterText: '',
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: (value) => widget.onChanged(value),
          enabled: widget.enabled,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),

        Center(
          child: Container(
            width: widget.fieldWidth,
            height: widget.fieldHeight,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12.0), // rounded-xl
              border: Border.all(
                color: colorScheme.primary.withOpacity(0.2), // border-primary/20
                width: 1,
              ),
            ),
            child: _AnimatedDigit(
              animation: _animationController,
              currentValue: _currentValue,
              previousValue: _previousValue,
              fontSize: fontSize,
              color: colorScheme.onSurface, // text-on-surface
            ),
          ),
        ),
      ],
    );
  }
}

class _AnimatedDigit extends StatelessWidget {
  final Animation<double> animation;
  final String currentValue;
  final String previousValue;
  final double fontSize;
  final Color color;

  const _AnimatedDigit({
    required this.animation,
    required this.currentValue,
    required this.previousValue,
    required this.fontSize,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return SizedBox(
          width: fontSize * 1.2,
          height: fontSize * 1.2,
          child: ClipRect(
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (previousValue.isNotEmpty)
                  Positioned(
                    top: -animation.value * fontSize,
                    child: Opacity(
                      opacity: 1.0 - animation.value,
                      child: Text(
                        previousValue,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.w700,
                          color: color,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),

                if (currentValue.isNotEmpty)
                  Positioned(
                    top: (1 - animation.value) * fontSize,
                    child: Opacity(
                      opacity: animation.value,
                      child: Text(
                        currentValue,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.w700,
                          color: color,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),

                if (currentValue.isEmpty && previousValue.isEmpty)
                  Container(
                    width: 2,
                    height: fontSize * 1.5,
                    color: Colors.transparent,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}