// types.dart
class Product {
  final int id;
  final String name;
  final String category;
  final String shortDescription;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.shortDescription,
    required this.image,
  });
}

enum PromotionIcon { card, loan, gold, emerald, crypto }

class Promotion {
  final int id;
  final PromotionIcon icon;
  final String title;
  final String description;
  final String bgColor;
  final String textColor;

  Promotion({
    required this.id,
    required this.icon,
    required this.title,
    required this.description,
    required this.bgColor,
    required this.textColor,
  });
}

class TrustedAccount {
  final int id;
  final String name;
  final String avatarInitials;
  final String type;
  final String identifier;

  TrustedAccount({
    required this.id,
    required this.name,
    required this.avatarInitials,
    required this.type,
    required this.identifier,
  });
}

class ChatMessage {
  final String role;
  final String text;

  ChatMessage({
    required this.role,
    required this.text,
  });
}