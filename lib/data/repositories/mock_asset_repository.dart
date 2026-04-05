import 'package:flutter/material.dart';
import '../../domain/models/asset_model.dart';
import '../../domain/repositories/asset_repository.dart';

class MockAssetRepository implements AssetRepository {
  @override
  Future<List<Asset>> getAssets() async {
    final now = DateTime.now();

    return [
      Asset(
        id: '1',
        name: 'Bitcoin',
        value: 45000.50,
        type: AssetType.crypto,
        change24h: 2.5,
        history: _generateHistory(now, 40000, 365, 0.05),
        correlations: const [
          AssetCorrelation(name: 'Ethereum', value: 0.85),
          AssetCorrelation(name: 'S&P 500', value: 0.42),
          AssetCorrelation(name: 'Gold', value: -0.15),
        ],
        milestones: [
          AssetMilestone(date: 'Mar 15, 2026', event: 'Asset Acquisition', price: '\$36,000.40', icon: Icons.shopping_bag_outlined),
          AssetMilestone(date: 'Feb 10, 2026', event: 'All-Time High', price: '\$63,000.40', icon: Icons.trending_up),
          AssetMilestone(date: 'Jan 01, 2026', event: 'Year Start', price: '\$42,000.40', icon: Icons.calendar_today),
        ],
      ),
      Asset(
        id: '2',
        name: 'Ethereum',
        value: 2400.20,
        type: AssetType.crypto,
        change24h: -1.2,
        history: _generateHistory(now, 2500, 365, 0.04),
        correlations: const [
          AssetCorrelation(name: 'Bitcoin', value: 0.85),
          AssetCorrelation(name: 'Solana', value: 0.70),
        ],
        milestones: [
          AssetMilestone(date: 'Mar 15, 2026', event: 'Asset Acquisition', price: '\$2,000.40', icon: Icons.shopping_bag_outlined),
        ],
      ),
      Asset(
        id: '3',
        name: 'Steam Inventory',
        value: 1250.75,
        type: AssetType.inventory,
        change24h: 0.5,
        history: _generateHistory(now, 1200, 365, 0.01),
        correlations: const [
          AssetCorrelation(name: 'CS:GO Cases', value: 0.80),
        ],
        milestones: [
          AssetMilestone(date: 'Mar 15, 2026', event: 'First Item', price: '\$10.00', icon: Icons.shopping_bag_outlined),
        ],
      ),
      Asset(
        id: '4',
        name: 'LEGO Star Wars Set',
        value: 800.00,
        type: AssetType.collectible,
        change24h: 0.0,
        history: _generateHistory(now, 800, 365, 0.005),
        correlations: const [],
        milestones: const [],
      ),
      Asset(
        id: '5',
        name: 'Vintage Rolex',
        value: 15000.00,
        type: AssetType.collectible,
        change24h: 5.0,
        history: _generateHistory(now, 14000, 365, 0.02),
        correlations: const [],
        milestones: const [],
      ),
      Asset(
        id: '6',
        name: 'S&P 500 Index',
        value: 12000.00,
        type: AssetType.stock,
        change24h: 0.8,
        history: _generateHistory(now, 11500, 365, 0.015),
        correlations: const [
          AssetCorrelation(name: 'Gold', value: -0.10),
          AssetCorrelation(name: 'Bitcoin', value: 0.42),
        ],
        milestones: const [],
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
