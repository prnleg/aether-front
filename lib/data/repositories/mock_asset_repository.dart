import '../../domain/models/asset_model.dart';
import '../../domain/repositories/asset_repository.dart';

class MockAssetRepository implements AssetRepository {
  @override
  Future<List<Asset>> getAssets() async {
    await Future.delayed(const Duration(milliseconds: 800));
    final now = DateTime.now();

    return [
      Asset(
        id: '1',
        name: 'Bitcoin',
        value: 45000.50,
        type: AssetType.crypto,
        change24h: 2.5,
        history: _generateHistory(now, 40000, 365, 0.05),
      ),
      Asset(
        id: '2',
        name: 'Ethereum',
        value: 2400.20,
        type: AssetType.crypto,
        change24h: -1.2,
        history: _generateHistory(now, 2500, 365, 0.04),
      ),
      Asset(
        id: '3',
        name: 'Steam Inventory',
        value: 1250.75,
        type: AssetType.inventory,
        change24h: 0.5,
        history: _generateHistory(now, 1200, 365, 0.01),
      ),
      Asset(
        id: '4',
        name: 'LEGO Star Wars Set',
        value: 800.00,
        type: AssetType.collectible,
        change24h: 0.0,
        history: _generateHistory(now, 800, 365, 0.005),
      ),
      Asset(
        id: '5',
        name: 'Vintage Rolex',
        value: 15000.00,
        type: AssetType.collectible,
        change24h: 5.0,
        history: _generateHistory(now, 14000, 365, 0.02),
      ),
      Asset(
        id: '6',
        name: 'S&P 500 Index',
        value: 12000.00,
        type: AssetType.stock,
        change24h: 0.8,
        history: _generateHistory(now, 11500, 365, 0.015),
      ),
    ];
  }

  @override
  Future<void> addAsset(Asset asset) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

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

  List<HistoryPoint> _generateHistory(
      DateTime now, double startValue, int days, double volatility) {
    final List<HistoryPoint> history = [];
    double currentValue = startValue;
    for (int i = days; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      // More realistic random walk
      final randomFactor = (i % 7) / 7.0 - 0.5; // range -0.5 to 0.5
      currentValue = currentValue * (1 + (volatility * randomFactor));
      history.add(HistoryPoint(date: date, value: currentValue));
    }
    return history;
  }
}
