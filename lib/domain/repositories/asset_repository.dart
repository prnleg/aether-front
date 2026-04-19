import '../models/asset_model.dart';

abstract class AssetRepository {
  Future<List<Asset>> getAssets();
  Future<void> addAsset(Asset asset);
  Future<void> deleteAsset(String assetId);
  Future<List<HistoryPoint>> getNetWorthHistory(List<Asset> assets);
}
