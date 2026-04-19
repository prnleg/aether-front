import '../../domain/models/market_asset.dart';

class MarketAssetDto {
  final String name;
  final String type;
  final String health;
  final double price;
  final double change;

  const MarketAssetDto({
    required this.name,
    required this.type,
    required this.health,
    required this.price,
    required this.change,
  });

  factory MarketAssetDto.fromJson(Map<String, dynamic> json) => MarketAssetDto(
        name: json['name'] as String,
        type: json['type'] as String,
        health: json['health'] as String,
        price: (json['price'] as num).toDouble(),
        change: (json['change'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'health': health,
        'price': price,
        'change': change,
      };

  MarketAsset toDomain() => MarketAsset(
        name: name,
        type: type,
        health: health,
        price: price,
        change: change,
      );
}
