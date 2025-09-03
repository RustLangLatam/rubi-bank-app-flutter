import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rubi_bank_api_sdk/rubi_bank_api_sdk.dart' as sdk;
import 'package:rubi_bank_app/core/utils/decimal_precision.dart';

class RecentActivityEnhanced extends StatefulWidget {
  final List<sdk.Transaction> transactions;

  const RecentActivityEnhanced({super.key, required this.transactions});

  @override
  State<RecentActivityEnhanced> createState() => _RecentActivityEnhancedState();
}

class _RecentActivityEnhancedState extends State<RecentActivityEnhanced> {
  final Map<String, bool> _newTransactionHighlights = {};
  final List<String> _previousTransactionIds = [];

  @override
  void didUpdateWidget(RecentActivityEnhanced oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Detect new transactions and trigger highlight animation
    _detectAndAnimateNewTransactions(oldWidget.transactions);
  }

  void _detectAndAnimateNewTransactions(List<sdk.Transaction> oldTransactions) {
    final newIds = widget.transactions.map((t) => t.name!).toList();
    final oldIds = oldTransactions.map((t) => t.name!).toList();

    // Find newly added transactions (those in new list but not in old list)
    final newTransactions = newIds.where((id) => !oldIds.contains(id)).toList();

    // Highlight new transactions
    for (final id in newTransactions) {
      _newTransactionHighlights[id] = true;

      // Remove highlight after animation duration
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _newTransactionHighlights.remove(id);
          });
        }
      });
    }

    _previousTransactionIds.clear();
    _previousTransactionIds.addAll(newIds);
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('d MMM y').format(date);
    }
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

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.transactions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final transaction = widget.transactions[index];
        final amount = transaction.amount.value.toDecimal();
        final isDebit = transaction.ledgerEntryType == sdk.TransactionLedgerEntryTypeEnum.LEDGER_ENTRY_TYPE_DEBIT;
        final description = _getDescription(transaction);
        final isNew = _newTransactionHighlights.containsKey(transaction.name);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: isNew
                ? theme.colorScheme.primary.withOpacity(0.1)
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: isNew
                ? Border.all(color: theme.colorScheme.primary.withOpacity(0.3), width: 2)
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isNew ? 0.2 : 0.1),
                blurRadius: isNew ? 8 : 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // New transaction indicator
              if (isNew)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      description,
                      style: theme.textTheme.bodyLarge!.copyWith(
                        fontSize: 16,
                        color: isNew ? theme.colorScheme.primary : null,
                        fontWeight: isNew ? FontWeight.bold : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(transaction.createTime ?? DateTime.now()),
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: isNew ? theme.colorScheme.primary.withOpacity(0.8) : null,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              AnimatedScale(
                duration: const Duration(milliseconds: 300),
                scale: isNew ? 1.1 : 1.0,
                child: Text(
                  '${isDebit ? '-' : '+'}${amount.toCurrencyString()}',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: isNew
                        ? theme.colorScheme.primary
                        : isDebit
                        ? theme.textTheme.bodyLarge!.color
                        : Colors.green,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
