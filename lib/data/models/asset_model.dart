import 'package:equatable/equatable.dart';

enum AssetType {
  crypto,
  inventory,
  collectible,
  cash,
  stock,
}

class HistoryPoint extends Equatable {
  final DateTime date;
  final double value;

  const HistoryPoint({required this.date, required this.value});

  @override
  List<Object?> get props => [date, value];
}

class Asset extends Equatable {
  final String id;
  final String name;
  final double value;
  final AssetType type;
  final double change24h; // Percentage change in the last 24h
  final List<HistoryPoint> history;

  const Asset({
    required this.id,
    required this.name,
    required this.value,
    required this.type,
    this.change24h = 0.0,
    this.history = const [],
  });

  @override
  List<Object?> get props => [id, name, value, type, change24h, history];

  String get typeName {
    switch (type) {
      case AssetType.crypto:
        return 'Crypto';
      case AssetType.inventory:
        return 'Inventory';
      case AssetType.collectible:
        return 'Collectible';
      case AssetType.cash:
        return 'Cash';
      case AssetType.stock:
        return 'Stock';
    }
  }
}
