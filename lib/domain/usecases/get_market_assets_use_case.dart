import '../models/market_asset.dart';
import '../repositories/discovery_repository.dart';

class GetMarketAssetsUseCase {
  final DiscoveryRepository _repository;
  const GetMarketAssetsUseCase(this._repository);
  Future<List<MarketAsset>> execute() => _repository.getMarketAssets();
}
