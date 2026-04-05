import 'package:equatable/equatable.dart';
import '../../../domain/models/market_asset.dart';

enum DiscoveryStatus { initial, loading, success, failure }

class DiscoveryState extends Equatable {
  final DiscoveryStatus status;
  final List<MarketAsset> assets;
  final List<MarketAsset> filteredAssets;
  final String searchQuery;

  const DiscoveryState({
    this.status = DiscoveryStatus.initial,
    this.assets = const [],
    this.filteredAssets = const [],
    this.searchQuery = '',
  });

  DiscoveryState copyWith({
    DiscoveryStatus? status,
    List<MarketAsset>? assets,
    List<MarketAsset>? filteredAssets,
    String? searchQuery,
  }) {
    return DiscoveryState(
      status: status ?? this.status,
      assets: assets ?? this.assets,
      filteredAssets: filteredAssets ?? this.filteredAssets,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [status, assets, filteredAssets, searchQuery];
}
