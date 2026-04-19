import 'package:equatable/equatable.dart';
import '../../../domain/models/asset_model.dart';
import 'dashboard_state.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class DashboardStarted extends DashboardEvent {}

class RefreshDashboard extends DashboardEvent {}

class ChangeTimeRange extends DashboardEvent {
  final TimeRange timeRange;

  const ChangeTimeRange(this.timeRange);

  @override
  List<Object> get props => [timeRange];
}

class AddAsset extends DashboardEvent {
  final String name;
  final AssetType type;
  final double initialValue;
  final String currency;

  // Crypto
  final String? symbol;
  final double? quantity;

  // Steam
  final String? marketHashName;

  // Physical
  final String? category;
  final String? brand;
  final String? condition;

  const AddAsset({
    required this.name,
    required this.type,
    required this.initialValue,
    this.currency = 'USD',
    this.symbol,
    this.quantity,
    this.marketHashName,
    this.category,
    this.brand,
    this.condition,
  });

  @override
  List<Object?> get props => [
        name, type, initialValue, currency,
        symbol, quantity, marketHashName,
        category, brand, condition,
      ];
}

class DeleteAsset extends DashboardEvent {
  final String assetId;
  const DeleteAsset(this.assetId);

  @override
  List<Object?> get props => [assetId];
}
