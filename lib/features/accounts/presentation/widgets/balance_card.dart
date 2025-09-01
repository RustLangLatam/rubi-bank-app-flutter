import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/common/widgets/card_rubi_logo.dart';
import '../../../../core/common/widgets/eye_icon.dart';
import '../../../../core/common/widgets/eye_off_icon.dart'; // Make sure to add shimmer to your pubspec.yaml


class BalanceCard extends StatefulWidget {
  // You can pass an account object here if you want to integrate with actual data,
  // similar to your Flutter example. For now, it's optional.
  final bool isLoading; // Added isLoading prop for shimmer effect

  const BalanceCard({super.key, this.isLoading = false});

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
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Define colors based on light/dark mode
    final Color primaryDeepBlue = const Color(0xFF0A1E3C);
    final Color inputBgDark = const Color(0xFF1E293B); // Tailwind slate-800 or similar dark bg
    final Color slate300 = const Color(0xFFA6B6C8); // Approx. Tailwind slate-300
    final Color slate400 = const Color(0xFF7B8D9F); // Approx. Tailwind slate-400

    final Color cardBgColor = isDarkMode ? inputBgDark : primaryDeepBlue;
    final Color textColorLight = Colors.white;
    final Color textMutedColor = isDarkMode ? slate300 : slate300; // Adjusted for better visibility in dark
    final Color iconColor = isDarkMode ? slate400 : slate400; // Adjusted for better visibility in dark
    final Color iconHoverColor = Colors.white;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: isDarkMode ? Border.all(color: Colors.white.withOpacity(0.1), width: 1) : null,
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
                    style: TextStyle(
                      fontSize: 14,
                      color: textMutedColor,
                    ),
                  ),
                  const SizedBox(height: 4), // mt-1 approx
                  Row(
                    children: [
                      if (widget.isLoading)
                        _buildShimmerPlaceholder(width: 150, height: 32)
                      else
                        Text(
                          _isBalanceVisible ? '\$17,930.00' : '\$ ••••',
                          style: TextStyle(
                            fontSize: 32, // text-4xl
                            fontWeight: FontWeight.bold,
                            letterSpacing: -1, // tracking-tight
                            color: textColorLight,
                          ),
                        ),
                      const SizedBox(width: 12), // gap-3 approx
                      if (widget.isLoading)
                        _buildShimmerPlaceholder(width: 24, height: 24, isCircle: true)
                      else
                        InkWell(
                          onTap: _toggleVisibility,
                          customBorder: const CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0), // Smaller hit area
                            child: _isBalanceVisible
                                ? EyeOffIcon(
                              size: 24,
                              color: iconColor,
                            )
                                : EyeIcon(
                              size: 24,
                              color: iconColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              const CardRubiLogo(),
            ],
          ),
          const SizedBox(height: 32), // gap-8 approx, vertically separated sections
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.isLoading)
                _buildShimmerPlaceholder(width: 120, height: 16)
              else
                Text(
                  '**** **** **** 1234',
                  style: TextStyle(
                    fontSize: 14,
                    color: textMutedColor,
                    fontFamily: 'monospace', // font-mono
                    letterSpacing: 2, // tracking-widest
                  ),
                ),
              const SizedBox(height: 4), // space-y-1 approx
              if (widget.isLoading)
                _buildShimmerPlaceholder(width: 100, height: 19)
              else
                Text(
                  'RubiBank Platinum',
                  style: TextStyle(
                    fontSize: 16, // text-md approx
                    fontWeight: FontWeight.w600, // font-semibold
                    color: textColorLight,
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
          borderRadius: isCircle ? BorderRadius.circular(height / 2) : BorderRadius.circular(4),
        ),
      ),
    );
  }
}