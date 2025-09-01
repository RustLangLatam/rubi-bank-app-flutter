import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rubi_bank_api_sdk/rubi_bank_api_sdk.dart' as sdk;
import 'package:rubi_bank_app/core/utils/decimal_precision.dart';

class RecentActivityWidget extends StatelessWidget {
  final List<sdk.Transaction> transactions;

  const RecentActivityWidget({super.key, required this.transactions});

  String _formatCurrency(Decimal amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFF3F4F6);
    final textColor = isDark ? const Color(0xFFF1F5F9) : const Color(0xFF1F2937);
    final mutedTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280);

    return Column(
      children: transactions.map((transaction) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.name ?? 'Transaction',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(transaction.createTime ?? DateTime.now()),
                      style: TextStyle(
                        fontSize: 14,
                        color: mutedTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '${transaction.amount.value.toDecimal() > Decimal.zero ? '+' : ''}${_formatCurrency(transaction.amount.value.toDecimal())}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: transaction.amount.value.toDecimal() > Decimal.zero
                      ? Colors.green
                      : textColor,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class RecentActivityEnhanced extends StatelessWidget {
  final List<sdk.Transaction> transactions;

  const RecentActivityEnhanced({super.key, required this.transactions});

  String _formatCurrency(Decimal amount) {
    final formatter = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );
    return formatter.format(amount);
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
      return DateFormat('MMM d, y').format(date);
    }
  }

  IconData _getTransactionIcon(sdk.Transaction transaction) {
    switch (transaction.type) {
      case sdk.TransactionTypeEnum.TRANSACTION_TYPE_TRANSFER:
        return Icons.swap_horiz;
      case sdk.TransactionTypeEnum.TRANSACTION_TYPE_DEPOSIT:
        return Icons.arrow_downward;
      case sdk.TransactionTypeEnum.TRANSACTION_TYPE_WITHDRAWAL:
        return Icons.arrow_upward;
      case sdk.TransactionTypeEnum.TRANSACTION_TYPE_PAYMENT:
        return Icons.receipt;
      default:
        return Icons.account_balance_wallet;
    }
  }

  Color _getTransactionColor(sdk.Transaction transaction) {
    final amount = transaction.amount.value.toDecimal();
    if (amount > Decimal.zero) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFF3F4F6);
    final textColor = isDark ? const Color(0xFFF1F5F9) : const Color(0xFF1F2937);
    final mutedTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280);

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        final amount = transaction.amount.value.toDecimal();
        final isPositive = amount > Decimal.zero;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: backgroundColor,
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
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getTransactionColor(transaction).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getTransactionIcon(transaction),
                  color: _getTransactionColor(transaction),
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "description" ?? 'Transaction',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(transaction.createTime ?? DateTime.now()),
                      style: TextStyle(
                        fontSize: 14,
                        color: mutedTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '${isPositive ? '+' : ''}${_formatCurrency(amount)}',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: isPositive ? Colors.green : textColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
