import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rubi_bank_api_sdk/rubi_bank_api_sdk.dart' as sdk;
import 'package:rubi_bank_app/core/utils/decimal_precision.dart';

class RecentActivityEnhanced extends StatelessWidget {
  final List<sdk.Transaction> transactions;

  const RecentActivityEnhanced({super.key, required this.transactions});

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

  // Helper method to extract description from transaction
  String _getDescription(sdk.Transaction transaction) {
    if (transaction.oneOf.value is sdk.TransferDetailsBuilder) {
      return (transaction.oneOf.value as sdk.TransferDetailsBuilder).description ?? 'Transaction';
    }
    return 'Transaction';
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        final amount = transaction.amount.value.toDecimal();
        final isDebit = transaction.ledgerEntryType == sdk.TransactionLedgerEntryTypeEnum.LEDGER_ENTRY_TYPE_DEBIT;
        final description = _getDescription(transaction);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      description,
                      style:theme.textTheme.bodyLarge!.copyWith(fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(transaction.createTime ?? DateTime.now()),
                      style:theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '${isDebit ? '+' : '-'}${amount.toCurrencyString()}',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: isDebit ? Colors.green : theme.textTheme.bodyLarge!.color,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
