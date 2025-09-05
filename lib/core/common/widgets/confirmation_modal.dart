import 'package:flutter/material.dart';
import 'package:rubi_bank_app/core/common/widgets/warning_icon.dart';
import 'package:rubi_bank_app/core/common/widgets/info_icon.dart';
import 'package:rubi_bank_app/core/common/widgets/logout_icon.dart';

enum IconType { warning, logout, info }
enum ConfirmButtonVariant { primary, danger }

class ConfirmationModal {
  static void show({
    required BuildContext context,
    required VoidCallback onConfirm,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    IconType iconType = IconType.info,
    ConfirmButtonVariant confirmButtonVariant = ConfirmButtonVariant.primary,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return _ConfirmationDialog(
          onConfirm: onConfirm,
          title: title,
          message: message,
          confirmText: confirmText,
          cancelText: cancelText,
          iconType: iconType,
          confirmButtonVariant: confirmButtonVariant,
        );
      },
    );
  }
}

class _ConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final IconType iconType;
  final ConfirmButtonVariant confirmButtonVariant;

  const _ConfirmationDialog({
    required this.onConfirm,
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
    required this.iconType,
    required this.confirmButtonVariant,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget getIcon() {
      switch (iconType) {
        case IconType.warning:
          return const WarningIcon();
        case IconType.logout:
          return const LogoutIcon();
        case IconType.info:
        default:
          return const InfoIcon();
      }
    }

    BoxDecoration getConfirmButtonDecoration() {
      switch (confirmButtonVariant) {
        case ConfirmButtonVariant.danger:
          return BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red[600]!, Colors.red[700]!],
            ),
            borderRadius: BorderRadius.circular(8),
          );
        case ConfirmButtonVariant.primary:
        default:
          return BoxDecoration(
            gradient: LinearGradient(
              colors: [colorScheme.primary, colorScheme.secondary],
            ),
            borderRadius: BorderRadius.circular(8),
          );
      }
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: colorScheme.primary.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  getIcon(),
                  const SizedBox(width: 16),

                  // Text content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          message,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.shadow,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Buttons
            Container(
              decoration: BoxDecoration(
                color: colorScheme.background.withOpacity(0.5),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Cancel button
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      backgroundColor: colorScheme.surface,
                      foregroundColor: colorScheme.onSurface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: colorScheme.primary.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: Text(cancelText),
                  ),
                  const SizedBox(width: 12),

                  // Confirm button
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      onConfirm();
                    },
                    child: Container(
                      decoration: getConfirmButtonDecoration(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      child: Text(
                        confirmText,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: confirmButtonVariant ==
                              ConfirmButtonVariant.danger
                              ? Colors.white
                              : colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}