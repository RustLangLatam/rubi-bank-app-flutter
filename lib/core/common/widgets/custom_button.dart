import 'package:flutter/material.dart';

enum ButtonType { primary, secondary }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType type;
  final bool isFullWidth;
  final double verticalPadding;
  final Color? customColor;
  final Color? customTextColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.isFullWidth = true,
    this.verticalPadding = 16,
    this.customColor,
    this.customTextColor,
    this.fontSize,
    this.fontWeight,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final Color backgroundColor = customColor ??
        (type == ButtonType.primary ? colorScheme.secondary : Colors.transparent);

    final Color foregroundColor = customTextColor ??
        (type == ButtonType.primary ? Colors.black : colorScheme.secondary);

    final ButtonStyle buttonStyle = type == ButtonType.primary
        ? ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
      elevation: 0,
    )
        : OutlinedButton.styleFrom(
      side: BorderSide(
        color: customColor ?? colorScheme.secondary,
        width: 1.5,
      ),
      foregroundColor: foregroundColor,
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
      backgroundColor: Colors.transparent,
    );

    Widget child = isLoading
        ? SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
        strokeWidth: 2,
      ),
    )
        : Text(
      text,
      style: theme.textTheme.labelLarge?.copyWith(
        color: foregroundColor,
        fontSize: fontSize,
        fontWeight: fontWeight ?? FontWeight.bold,
      ),
    );

    Widget button = type == ButtonType.primary
        ? ElevatedButton(
      style: buttonStyle,
      onPressed: isLoading ? null : onPressed,
      child: child,
    )
        : OutlinedButton(
      style: buttonStyle,
      onPressed: isLoading ? null : onPressed,
      child: child,
    );

    return isFullWidth
        ? SizedBox(
      width: double.infinity,
      child: button,
    )
        : button;
  }
}