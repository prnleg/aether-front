import '../../domain/models/market_asset.dart';
import '../../domain/repositories/discovery_repository.dart';

class MockDiscoveryRepository implements DiscoveryRepository {
  final List<MarketAsset> _mockMarketAssets = const [
    MarketAsset(
      name: 'Factory New Dragon Lore',
      type: 'CS:GO Skin',
      health: 'Bullish',
      price: 12500.00,
      change: 2.4,
    ),
    MarketAsset(
      name: 'Ethereum',
      type: 'Crypto',
      health: 'Stable',
      price: 2450.50,
      change: -0.5,
    ),
    MarketAsset(
      name: 'Bored Ape Yacht Club #451',
      type: 'NFT',
      health: 'Volatile',
      price: 65200.00,
      change: -12.4,
    ),
    MarketAsset(
      name: 'Tesla Inc.',
      type: 'Stock',
      health: 'Bullish',
      price: 242.10,
      change: 1.2,
    ),
  ];

  @override
  Future<List<MarketAsset>> getMarketAssets() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockMarketAssets;
  }
}
