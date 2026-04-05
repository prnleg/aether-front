import 'package:flutter/widgets.dart';

class MarketAsset {
  final String name;
  final String type;
  final String health;
  final double price;
  final double change;
  final IconData icon;

  const MarketAsset({
    required this.name,
    required this.type,
    required this.health,
    required this.price,
    required this.change,
    required this.icon,
  });
}
