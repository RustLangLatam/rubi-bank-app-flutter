import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rubi_bank_api_sdk/rubi_bank_api_sdk.dart' as sdk;
import 'package:rubi_bank_app/core/utils/decimal_precision.dart';
import '../../../../core/common/theme/app_theme.dart';

class RecentActivityEnhanced extends StatefulWidget {
  final List<sdk.Transaction> transactions;

  const RecentActivityEnhanced({super.key, required this.transactions});

  @override
  State<RecentActivityEnhanced> createState() => _RecentActivityEnhancedState();
}

class _RecentActivityEnhancedState extends State<RecentActivityEnhanced> {
  final Map<String, bool> _newTransactionHighlights = {};

  @override
  void didUpdateWidget(RecentActivityEnhanced oldWidget) {
    super.didUpdateWidget(oldWidget);
    _detectNewTransactions(oldWidget.transactions);
  }

  void _detectNewTransactions(List<sdk.Transaction> oldTransactions) {
    final newIds = widget.transactions.map((t) => t.name!).toList();
    final oldIds = oldTransactions.map((t) => t.name!).toList();

    final newTransactions = newIds.where((id) => !oldIds.contains(id)).toList();

    for (final id in newTransactions) {
      _newTransactionHighlights[id] = true;
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _newTransactionHighlights.remove(id));
      });
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inDays == 0) return 'Today';
    if (difference.inDays == 1) return 'Yesterday';
    if (difference.inDays < 7) return '${difference.inDays} days ago';
    return DateFormat('d MMM y').format(date);
  }

  String _getDescription(sdk.Transaction transaction) {
    if (transaction.oneOf.value is sdk.TransferDetails) {
      return (transaction.oneOf.value as sdk.TransferDetails).description ?? 'Transaction';
    }
    return 'Transaction';
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Column(
      children: widget.transactions.map((transaction) {
        final amount = transaction.amount.value.toDecimal();
        final isDebit = transaction.ledgerEntryType == sdk.TransactionLedgerEntryTypeEnum.LEDGER_ENTRY_TYPE_DEBIT;
        final description = _getDescription(transaction);
        final isNew = _newTransactionHighlights.containsKey(transaction.name);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isNew
                ? colorScheme.primary.withOpacity(0.1)
                : colorScheme.surface.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isNew ? 0.1 : 0.05),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        description,
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isNew ? colorScheme.primary : colorScheme.onBackground,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(transaction.createTime ?? DateTime.now()),
                        style: textTheme.bodyMedium?.copyWith(
                          color: isNew ? colorScheme.primary.withOpacity(0.8) : colorScheme.shadow,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${isDebit ? '' : '+'}${amount.toCurrencyString()}',
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: isNew
                        ? colorScheme.primary
                        : isDebit
                        ? colorScheme.onSurface
                        : Colors.green.shade400,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}