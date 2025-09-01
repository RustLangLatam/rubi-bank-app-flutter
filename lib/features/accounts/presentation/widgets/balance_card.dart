import 'package:flutter/material.dart';
import 'package:rubi_bank_api_sdk/rubi_bank_api_sdk.dart' as sdk;
import 'package:rubi_bank_app/core/utils/decimal_precision.dart';

import '../../../../core/common/widgets/card_rubi_logo.dart';
import '../../../../core/common/widgets/eye_icon.dart';
import '../../../../core/common/widgets/eye_off_icon.dart';

import 'package:shimmer/shimmer.dart';

class BalanceCardWidget extends StatefulWidget {
  final sdk.Account? account;

  const BalanceCardWidget({
    super.key,
    required this.account,
  });

  @override
  State<BalanceCardWidget> createState() => _BalanceCardWidgetState();
}

class _BalanceCardWidgetState extends State<BalanceCardWidget> {
  bool _isBalanceVisible = true;

  void _toggleVisibility() {
    setState(() {
      _isBalanceVisible = !_isBalanceVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = widget.account == null;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0A1E3C),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
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
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _buildBalanceDisplay(isLoading),
                      const SizedBox(width: 12),
                      _buildVisibilityToggle(isLoading),
                    ],
                  ),
                ],
              ),
              const CardRubiLogo(),
            ],
          ),
          const SizedBox(height: 32),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCardNumberDisplay(isLoading),
              const SizedBox(height: 4),
              _buildCardHolderDisplay(isLoading),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceDisplay(bool isLoading) {
    if (isLoading) {
      return Shimmer.fromColors(
        baseColor: Colors.white.withOpacity(0.2),
        highlightColor: Colors.white.withOpacity(0.4),
        child: Container(
          width: 150,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      );
    }

    final balance = widget.account!.balance?.issuedBalance;
    final currency = widget.account!.currency;

    return Text(
      _isBalanceVisible
          ? '$currency${balance?.value.toDecimal()}'
          : '\$ ••••',
      style: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildVisibilityToggle(bool isLoading) {
    if (isLoading) {
      return Shimmer.fromColors(
        baseColor: Colors.white.withOpacity(0.2),
        highlightColor: Colors.white.withOpacity(0.4),
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
        ),
      );
    }

    return IconButton(
      onPressed: _toggleVisibility,
      icon: _isBalanceVisible
          ? EyeOffIcon(
        size: 24,
        color: Colors.white.withOpacity(0.6),
      )
          : EyeIcon(
        size: 24,
        color: Colors.white.withOpacity(0.6),
      ),
      splashRadius: 20,
      tooltip: _isBalanceVisible ? 'Hide balance' : 'Show balance',
    );
  }

  Widget _buildCardNumberDisplay(bool isLoading) {
    if (isLoading) {
      return Shimmer.fromColors(
        baseColor: Colors.white.withOpacity(0.2),
        highlightColor: Colors.white.withOpacity(0.4),
        child: Container(
          width: 120,
          height: 16,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      );
    }

    final cardNumber = widget.account!.address?.rubiHandle?.substring(
      widget.account!.address!.rubiHandle!.length - 4,
    );

    return Text(
      '**** **** **** $cardNumber',
      style: TextStyle(
        fontSize: 14,
        color: Colors.white.withOpacity(0.7),
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildCardHolderDisplay(bool isLoading) {
    if (isLoading) {
      return Shimmer.fromColors(
        baseColor: Colors.white.withOpacity(0.2),
        highlightColor: Colors.white.withOpacity(0.4),
        child: Container(
          width: 100,
          height: 19,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      );
    }

    final cardHolderName = widget.account!.displayName;

    return Text(
      cardHolderName,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }
}
