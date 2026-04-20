import '../../domain/models/discovery_item.dart';

class DiscoveryItemDto {
  final String id;
  final String externalId;
  final String marketHashName;
  final String appId;
  final String iconUrl;
  final String status;
  final double? marketPriceAmount;
  final String? marketPriceCurrency;
  final DateTime lastSeenAt;
  final DateTime createdAt;

  const DiscoveryItemDto({
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

  factory DiscoveryItemDto.fromJson(Map<String, dynamic> json) {
    return DiscoveryItemDto(
      id: (json['id'] ?? json['Id'] ?? '') as String,
      externalId: (json['externalId'] ?? json['ExternalId'] ?? '') as String,
      marketHashName:
          (json['marketHashName'] ?? json['MarketHashName'] ?? '') as String,
      appId: (json['appId'] ?? json['AppId'] ?? '') as String,
      iconUrl: (json['iconUrl'] ?? json['IconUrl'] ?? '') as String,
      status: (json['status'] ?? json['Status'] ?? 'PendingApproval') as String,
      marketPriceAmount: (json['marketPriceAmount'] ?? json['MarketPriceAmount'])
          as double?,
      marketPriceCurrency:
          (json['marketPriceCurrency'] ?? json['MarketPriceCurrency'])
              as String?,
      lastSeenAt: DateTime.parse(
          (json['lastSeenAt'] ?? json['LastSeenAt'] ?? DateTime.now().toIso8601String())
              as String),
      createdAt: DateTime.parse(
          (json['createdAt'] ?? json['CreatedAt'] ?? DateTime.now().toIso8601String())
              as String),
    );
  }

  DiscoveryItem toDomain() {
    return DiscoveryItem(
      id: id,
      externalId: externalId,
      marketHashName: marketHashName,
      appId: appId,
      iconUrl: iconUrl,
      status: _parseStatus(status),
      marketPriceAmount: marketPriceAmount,
      marketPriceCurrency: marketPriceCurrency,
      lastSeenAt: lastSeenAt,
      createdAt: createdAt,
    );
  }

  DiscoveryItemStatus _parseStatus(String s) {
    switch (s) {
      case 'Approved':
        return DiscoveryItemStatus.approved;
      case 'Rejected':
        return DiscoveryItemStatus.rejected;
      case 'Available':
        return DiscoveryItemStatus.available;
      case 'PendingApproval':
      default:
        return DiscoveryItemStatus.pending;
    }
  }
}
