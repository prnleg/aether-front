import '../../domain/models/asset_model.dart';
import '../../domain/repositories/asset_repository.dart';
import '../datasources/asset_remote_data_source.dart';

class MockAssetRepository implements AssetRepository {
  final AssetRemoteDataSource _remoteDataSource;

  MockAssetRepository(this._remoteDataSource);

  @override
  Future<List<Asset>> getAssets() => _remoteDataSource.getAssets();

  @override
  Future<void> addAsset(Asset asset) => _remoteDataSource.addAsset(asset);

  @override
  Future<List<HistoryPoint>> getNetWorthHistory(List<Asset> assets) async {
    if (assets.isEmpty) return [];

    final days = assets.first.history.length;
    final now = DateTime.now();
    final List<HistoryPoint> netWorthHistory = [];

    for (int i = 0; i < days; i++) {
      double dailySum = 0;
      for (var asset in assets) {
        if (i < asset.history.length) {
          dailySum += asset.history[i].value;
        }
      }
      netWorthHistory.add(HistoryPoint(
        date: now.subtract(Duration(days: (days - 1) - i)),
        value: dailySum,
      ));
    }
    return netWorthHistory;
  }
}
