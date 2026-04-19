import '../../domain/models/asset_model.dart';
import '../../domain/repositories/asset_repository.dart';
import '../datasources/asset_remote_data_source.dart';

class AssetRepositoryImpl implements AssetRepository {
  final AssetRemoteDataSource _remoteDataSource;

  AssetRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Asset>> getAssets() => _remoteDataSource.getAssets();

  @override
  Future<void> addAsset(Asset asset) => _remoteDataSource.addAsset(asset);

  @override
  Future<void> deleteAsset(String assetId) =>
      _remoteDataSource.deleteAsset(assetId);

  @override
  Future<List<HistoryPoint>> getNetWorthHistory(List<Asset> assets) async {
    if (assets.isEmpty) return [];

    final days = assets.first.history.length;
    if (days == 0) return [];

    final now = DateTime.now();
    return List.generate(days, (i) {
      final dailySum = assets.fold<double>(
        0.0,
        (sum, asset) =>
            sum + (i < asset.history.length ? asset.history[i].value : 0.0),
      );
      return HistoryPoint(
        date: now.subtract(Duration(days: (days - 1) - i)),
        value: dailySum,
      );
    });
  }
}
