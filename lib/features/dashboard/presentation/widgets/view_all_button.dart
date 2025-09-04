import 'package:flutter/material.dart';
import '../../../../core/common/theme/app_theme.dart';

class ViewAllButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const ViewAllButton({
    super.key,
    required this.onPressed,
    this.text = 'View All',
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = AppTheme.darkTheme;
    final ColorScheme colorScheme = theme.colorScheme;

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: colorScheme.primary,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: colorScheme.primary,
        ),
      ),
    );
  }
}