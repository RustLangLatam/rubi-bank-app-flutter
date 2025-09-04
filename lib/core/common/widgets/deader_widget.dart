import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  final String userName;
  final String? avatarUrl;

  const DashboardHeader({
    super.key,
    required this.userName,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.only(
        top: 48, // pt-12 (12 * 4 = 48)
        bottom: 20, // pb-5 (5 * 4 = 20)
        left: 24, // px-6 (6 * 4 = 24)
        right: 24,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Welcome text and user name
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome Back,',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.shadow, // text-muted
                  fontSize: 14, // text-sm
                ),
              ),
              const SizedBox(height: 4), // Espacio entre textos
              Text(
                userName,
                style: textTheme.displayMedium?.copyWith(
                  fontSize: 24, // text-2xl
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface, // text-on-surface
                ),
              ),
            ],
          ),

          // User avatar
          Container(
            width: 48, // w-12 (12 * 4 = 48)
            height: 48, // h-12
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24), // rounded-full
              border: Border.all(
                color: colorScheme.primary, // border-primary
                width: 2, // border-2
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