import '../../domain/models/asset_model.dart';

abstract class AssetRemoteDataSource {
  Future<List<Asset>> getAssets();
  Future<void> addAsset(Asset asset);
}

class MockAssetRemoteDataSource implements AssetRemoteDataSource {
  @override
  Future<List<Asset>> getAssets() async {
    await Future.delayed(const Duration(seconds: 1));
    return []; // Return empty for now, repo will decide what to do
  }

  @override
  Future<void> addAsset(Asset asset) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
