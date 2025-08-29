import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color? color;
  final double iconSize;
  final EdgeInsetsGeometry padding;

  const CustomBackButton({
    super.key,
    required this.onPressed,
    this.color,
    this.iconSize = 24.0,
    this.padding = const EdgeInsets.all(2.0),
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color iconColor = color ?? theme.colorScheme.secondary;

    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        Icons.arrow_back,
        size: iconSize,
        color: iconColor,
      ),
      padding: padding,
      splashRadius: iconSize * 0.7,
      constraints: const BoxConstraints(),
      visualDensity: VisualDensity.compact,
    );
  }
}

class CustomBackButtonWithSpacing extends StatelessWidget {
  final VoidCallback onPressed;
  final Color? color;
  final double iconSize;
  final EdgeInsetsGeometry padding;
  final double spacing;

  const CustomBackButtonWithSpacing({
    super.key,
    required this.onPressed,
    this.color,
    this.iconSize = 24.0,
    this.padding = const EdgeInsets.all(2.0),
    this.spacing = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomBackButton(
          onPressed: onPressed,
          color: color,
          iconSize: iconSize,
          padding: padding,
        ),
        SizedBox(height: spacing),
      ],
    );
  }
}