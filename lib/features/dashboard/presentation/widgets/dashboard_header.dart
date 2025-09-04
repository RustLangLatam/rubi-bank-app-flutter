import 'package:flutter/material.dart';
import '../../../../core/common/theme/app_theme.dart';

class DashboardHeader extends StatelessWidget {
  final String userName;
  final String? avatarUrl;

  const DashboardHeader({
    super.key,
    required this.userName,
    this.avatarUrl,
  });

  String _capitalizeEachWord(String text) {
    if (text.isEmpty) return text;

    return text
        .trim()
        .split(RegExp(r'\s+'))
        .map((word) {
      if (word.isEmpty) return word;
      if (word.contains("'") || word.contains("-")) {
        return word.split(RegExp(r"['-]")).map((part) {
          if (part.isEmpty) return part;
          return part[0].toUpperCase() + part.substring(1).toLowerCase();
        }).join(word.contains("'") ? "'" : "-");
      }
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    })
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = AppTheme.darkTheme;
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    final capitalizedUserName = _capitalizeEachWord(userName);

    return Container(
      padding: const EdgeInsets.only(
        left: 18,
        right: 18,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back,',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.shadow,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  capitalizedUserName,
                  style: textTheme.displayMedium?.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: colorScheme.primary,
                width: 2,
              ),
            ),
            child: ClipOval(
              child: avatarUrl != null
                  ? Image.network(
                avatarUrl!,
                fit: BoxFit.cover,
                width: 48,
                height: 48,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: colorScheme.surface,
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: colorScheme.surface,
                    child: Icon(
                      Icons.person,
                      color: colorScheme.shadow,
                      size: 24,
                    ),
                  );
                },
              )
                  : Container(
                color: colorScheme.surface,
                child: Icon(
                  Icons.person,
                  color: colorScheme.shadow,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}