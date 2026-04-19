import 'package:equatable/equatable.dart';

class MarketAsset extends Equatable {
  final String name;
  final String type;
  final String health;
  final double price;
  final double change;

  const MarketAsset({
    required this.name,
    required this.type,
    required this.health,
    required this.price,
    required this.change,
  });

  @override
  List<Object?> get props => [name, type, health, price, change];
}
