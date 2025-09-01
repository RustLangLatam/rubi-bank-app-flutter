import 'package:flutter/material.dart';

import '../../../../core/common/widgets/card_rubi_logo.dart';
import '../../../../core/common/widgets/eye_icon.dart';
import '../../../../core/common/widgets/eye_off_icon.dart';


class BalanceCardWidget extends StatefulWidget {
  const BalanceCardWidget({super.key});

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
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0A1E3C), // Primary deep blue
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
          // Header with balance and logo
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
                      Text(
                        _isBalanceVisible ? '\$17,930.00' : '\$ ••••',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
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
                        tooltip: _isBalanceVisible
                            ? 'Hide balance'
                            : 'Show balance',
                      ),
                    ],
                  ),
                ],
              ),
              const CardRubiLogo(),
            ],
          ),
          const SizedBox(height: 32),
          // Card details
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '**** **** **** 1234',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                  fontFamily: 'Monospace',
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'RubiBank Platinum',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}