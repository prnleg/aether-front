import 'package:equatable/equatable.dart';

enum DiscoveryItemStatus { pending, approved, rejected, available }

class DiscoveryItem extends Equatable {
  final String id;
  final String externalId;
  final String marketHashName;
  final String appId;
  final String iconUrl;
  final DiscoveryItemStatus status;
  final double? marketPriceAmount;
  final String? marketPriceCurrency;
  final DateTime lastSeenAt;
  final DateTime createdAt;

  const DiscoveryItem({
    required this.id,
    required this.externalId,
    required this.marketHashName,
    required this.appId,
    required this.iconUrl,
    required this.status,
    this.marketPriceAmount,
    this.marketPriceCurrency,
    required this.lastSeenAt,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        externalId,
        marketHashName,
        appId,
        iconUrl,
        status,
        marketPriceAmount,
        marketPriceCurrency,
        lastSeenAt,
        createdAt,
      ];
}
