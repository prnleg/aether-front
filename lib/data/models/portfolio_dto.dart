import '../../domain/models/asset_model.dart';

/// Maps GET api/portfolio/:userId
class PortfolioDto {
  final String id;
  final String name;
  final List<PortfolioAssetDto> assets;
  final double totalValue;
  final String currency;

  const PortfolioDto({
    required this.id,
    required this.name,
    required this.assets,
    required this.totalValue,
    required this.currency,
  });

  factory PortfolioDto.fromJson(Map<String, dynamic> json) => PortfolioDto(
        id: json['id'] as String,
        name: json['name'] as String? ?? '',
        assets: (json['assets'] as List<dynamic>? ?? [])
            .map((e) => PortfolioAssetDto.fromJson(e as Map<String, dynamic>))
            .toList(),
        totalValue: (json['totalValue'] as num?)?.toDouble() ?? 0.0,
        currency: json['currency'] as String? ?? 'USD',
      );
}

/// A single asset row returned inside the portfolio response.
class PortfolioAssetDto {
  final String id;
  final String name;
  final String assetType; // "crypto" | "steam" | "physical"
  final double acquisitionPrice;
  final String acquisitionCurrency;
  final double currentFloorPrice;
  final String currentFloorCurrency;
  final String? symbol;
  final double? quantity;
  final String? marketHashName;
  final String? appId;
  final String? category;
  final String? brand;
  final String? condition;

  const PortfolioAssetDto({
    required this.id,
    required this.name,
    required this.assetType,
    required this.acquisitionPrice,
    required this.acquisitionCurrency,
    required this.currentFloorPrice,
    required this.currentFloorCurrency,
    this.symbol,
    this.quantity,
    this.marketHashName,
    this.appId,
    this.category,
    this.brand,
    this.condition,
  });

  factory PortfolioAssetDto.fromJson(Map<String, dynamic> json) =>
      PortfolioAssetDto(
        id: json['id'] as String,
        name: json['name'] as String,
        assetType: json['assetType'] as String? ?? 'physical',
        acquisitionPrice: (json['acquisitionPrice'] as num?)?.toDouble() ?? 0.0,
        acquisitionCurrency: json['acquisitionCurrency'] as String? ?? 'USD',
        currentFloorPrice: (json['currentFloorPrice'] as num?)?.toDouble() ?? 0.0,
        currentFloorCurrency: json['currentFloorCurrency'] as String? ?? 'USD',
        symbol: json['symbol'] as String?,
        quantity: (json['quantity'] as num?)?.toDouble(),
        marketHashName: json['marketHashName'] as String?,
        appId: json['appId'] as String?,
        category: json['category'] as String?,
        brand: json['brand'] as String?,
        condition: json['condition'] as String?,
      );

  Asset toDomain() {
    final type = _mapType(assetType);
    // For crypto: value = price × quantity. For others: value = floor price.
    final value = (type == AssetType.crypto && quantity != null)
        ? currentFloorPrice * quantity!
        : currentFloorPrice;

    return Asset(
      id: id,
      name: name,
      value: value,
      type: type,
      change24h: 0.0, // not provided by backend yet
      currency: currentFloorCurrency,
      symbol: symbol,
      quantity: quantity,
      marketHashName: marketHashName,
      category: category,
      brand: brand,
      condition: condition,
    );
  }

  static AssetType _mapType(String type) {
    switch (type.toLowerCase()) {
      case 'crypto':
        return AssetType.crypto;
      case 'steam':
        return AssetType.inventory;
      case 'physical':
        return AssetType.collectible;
      default:
        return AssetType.cash;
    }
  }
}
