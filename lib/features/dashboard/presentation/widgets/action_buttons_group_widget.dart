import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Material(
          color: theme.colorScheme.surface,
          shape: const CircleBorder(),
          elevation: 3,
          child: InkWell(
            customBorder: const CircleBorder(),
            splashColor: theme.colorScheme.secondary.withOpacity(0.2),
            highlightColor: theme.colorScheme.secondary.withOpacity(0.1),
            onTap: onPressed,
            child: SizedBox(
              width: 54,
              height: 54,
              child: Icon(
                icon,
                size: 28,
                color: theme.colorScheme.secondary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class ActionButtonsGroupWidget extends StatelessWidget {
  final VoidCallback? onSend;
  final VoidCallback? onReceive;
  final VoidCallback? onPayBills;
  final VoidCallback? onAddAccount;

  const ActionButtonsGroupWidget({
    super.key,
    this.onSend,
    this.onReceive,
    this.onPayBills,
    this.onAddAccount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ActionButton(
          icon: Symbols.arrow_upward,
          label: 'Send',
          onPressed: onSend,
        ),
        ActionButton(
          icon: Symbols.arrow_downward,
          label: 'Receive',
          onPressed: onReceive,
        ),
        ActionButton(
          icon: Symbols.receipt_long,
          label: 'Pay Bills',
          onPressed: onPayBills,
        ),
        ActionButton(
          icon: Symbols.add,
          label: 'Add Account',
          onPressed: onAddAccount,
        ),
      ],
    );
  }
}


