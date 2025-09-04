import 'package:flutter/material.dart';
import 'package:rubi_bank_api_sdk/rubi_bank_api_sdk.dart' as sdk;
import 'package:rubi_bank_app/core/utils/decimal_precision.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/common/theme/app_theme.dart';
import '../../../../core/common/widgets/eye_icon.dart';
import '../../../../core/common/widgets/eye_off_icon.dart';
import '../../../../core/common/widgets/rubi_bank_logo.dart';
import 'animated_balance_widget.dart';

class BalanceCard extends StatefulWidget {
  final sdk.Account account;
  final bool isLoading;

  const BalanceCard({super.key, required this.account, this.isLoading = false});

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  bool _isBalanceVisible = true;

  void _toggleVisibility() {
    setState(() {
      _isBalanceVisible = !_isBalanceVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    final money = widget.account.balance!.issuedBalance;
    final cardNumber = widget.account.address!.rubiHandle;
    final cardHolderName = widget.account.displayName;

    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First row with balance and logo
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Balance',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.shadow,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (widget.isLoading)
                        _buildShimmerPlaceholder(width: 150, height: 32)
                      else
                        CashRegisterBalanceText(
                          balance: money.value.toDecimal(),
                          isVisible: _isBalanceVisible,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                            fontFamily: 'Inter',
                            letterSpacing: -0.5,
                            height: 1.1,
                          ),
                          digitAnimationDuration: const Duration(milliseconds: 300),
                          delayBetweenDigits: const Duration(milliseconds: 80),
                        ),

                      const SizedBox(width: 12),
                      if (widget.isLoading)
                        _buildShimmerPlaceholder(
                          width: 20,
                          height: 20,
                          isCircle: true,
                        )
                      else
                        IconButton(
                          onPressed: _toggleVisibility,
                          icon: _isBalanceVisible
                              ? EyeOffIcon(
                            size: 20,
                            color: colorScheme.shadow,
                          )
                              : EyeIcon(
                            size: 20,
                            color: colorScheme.shadow,
                          ),
                          iconSize: 20,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                    ],
                  ),
                ],
              ),
              RubiBankLogo(
                size: 32,
                color: colorScheme.onSurface.withOpacity(0.2),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Second row with card details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.isLoading)
                    _buildShimmerPlaceholder(width: 120, height: 16)
                  else
                    Text(
                      '**** ${cardNumber!.substring(cardNumber.length - 4)}',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.shadow,
                        fontSize: 14,
                        letterSpacing: 4.0,
                        fontFamily: 'sans-serif',
                      ),
                    ),
                  const SizedBox(height: 4),
                  if (widget.isLoading)
                    _buildShimmerPlaceholder(width: 100, height: 19)
                  else
                    Text(
                      cardHolderName,
                      style: textTheme.bodyLarge?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'serif',
                      ),
                    ),
                ],
              ),
              if (widget.isLoading)
                _buildShimmerPlaceholder(width: 40, height: 14)
              else
                Text(
                  '08/28',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.shadow,
                    fontSize: 14,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerPlaceholder({
    required double width,
    required double height,
    bool isCircle = false,
  }) {
    final ThemeData theme = Theme.of(context);
    return Shimmer.fromColors(
      baseColor: theme.colorScheme.shadow.withOpacity(0.2),
      highlightColor: theme.colorScheme.shadow.withOpacity(0.4),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: theme.colorScheme.shadow.withOpacity(0.3),
          borderRadius: isCircle
              ? BorderRadius.circular(height / 2)
              : BorderRadius.circular(4),
        ),
      ),
    );
  }
}