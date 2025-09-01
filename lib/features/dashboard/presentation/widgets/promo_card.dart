// promo_card.dart
import 'package:flutter/material.dart';
import 'custom_icons.dart';
import 'types.dart';

class PromoCard extends StatelessWidget {
  final Promotion promotion;

  const PromoCard({super.key, required this.promotion});

  Widget _getIcon(PromotionIcon icon, Color color) {
    switch (icon) {
      case PromotionIcon.card:
        return CardIcon(color: color, size: 24);
      case PromotionIcon.loan:
        return LoanIcon(color: color, size: 24);
      case PromotionIcon.gold:
        return Icon(Icons.monetization_on, color: color, size: 24);
      case PromotionIcon.emerald:
        return Icon(Icons.diamond, color: color, size: 24);
      case PromotionIcon.crypto:
        return Icon(Icons.currency_bitcoin, color: color, size: 24);
      default:
        return Icon(Icons.card_giftcard, color: color, size: 24);
    }
  }

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _parseColor(promotion.bgColor);
    final textColor = _parseColor(promotion.textColor);

    return Container(
      width: double.infinity,
      height: 128,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _getIcon(promotion.icon, textColor),
                  const SizedBox(width: 12),
                  Text(
                    promotion.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                promotion.description,
                style: TextStyle(
                  fontSize: 14,
                  color: textColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              // Handle learn more action
            },
            child: Text(
              'Learn More →',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: textColor.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}