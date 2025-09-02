import 'package:flutter/material.dart';
import 'package:rubi_bank_api_sdk/rubi_bank_api_sdk.dart' as sdk;
import 'package:rubi_bank_app/core/utils/decimal_precision.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/common/widgets/card_rubi_logo.dart';
import '../../../../core/common/widgets/eye_icon.dart';
import '../../../../core/common/widgets/eye_off_icon.dart';

class BalanceCard extends StatefulWidget {
  final sdk.Account account;
  // You can pass an account object here if you want to integrate with actual data,
  // similar to your Flutter example. For now, it's optional.
  final bool isLoading; // Added isLoading prop for shimmer effect

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

    final money = widget.account.balance!.issuedBalance;
    final currency = money.currencyCode;
    final balance = money.value.toDecimal().toCurrencyString();
    final cardNumber = widget.account.address!.rubiHandle;
    final cardHolderName = widget.account.displayName;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      padding: const EdgeInsets.all(28), // p-7 in Tailwind is 28px
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Balance',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                  const SizedBox(height: 4), // mt-1 approx
                  Row(
                    children: [
                      if (widget.isLoading)
                        _buildShimmerPlaceholder(width: 150, height: 32)
                      else
                        Text(
                          _isBalanceVisible ? balance : '\$ ••••',
                          style: theme.textTheme.headlineSmall,
                        ),
                      const SizedBox(width: 12), // gap-3 approx
                      if (widget.isLoading)
                        _buildShimmerPlaceholder(
                          width: 24,
                          height: 24,
                          isCircle: true,
                        )
                      else
                        InkWell(
                          onTap: _toggleVisibility,
                          customBorder: const CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(
                              4.0,
                            ), // Smaller hit area
                            child: _isBalanceVisible
                                ? EyeOffIcon(
                                    size: 24,
                                    color: theme.textTheme.bodyMedium!.color!
                                        .withOpacity(0.6),
                                  )
                                : EyeIcon(
                                    size: 24,
                                    color: theme.textTheme.bodyMedium!.color!
                                        .withOpacity(0.6),
                                  ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              CardRubiLogo(color: theme.textTheme.bodyMedium!.color),
            ],
          ),
          const SizedBox(
            height: 32,
          ), // gap-8 approx, vertically separated sections
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.isLoading)
                _buildShimmerPlaceholder(width: 120, height: 16)
              else
                Text(
                  '**** **** **** ${cardNumber!.substring(cardNumber.length - 4)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    letterSpacing: 2
                  ),
                ),
              const SizedBox(height: 8), // space-y-1 approx
              if (widget.isLoading)
                _buildShimmerPlaceholder(width: 100, height: 19)
              else
                Text(
                  'RubiBank Platinum',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
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
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.2),
      highlightColor: Colors.white.withOpacity(0.4),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: isCircle
              ? BorderRadius.circular(height / 2)
              : BorderRadius.circular(4),
        ),
      ),
    );
  }
}
