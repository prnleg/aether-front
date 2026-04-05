import '../models/market_asset.dart';

abstract class DiscoveryRepository {
  Future<List<MarketAsset>> getMarketAssets();
}
