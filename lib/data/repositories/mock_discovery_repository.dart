import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../domain/models/market_asset.dart';
import '../../domain/repositories/discovery_repository.dart';

class MockDiscoveryRepository implements DiscoveryRepository {
  final List<MarketAsset> _mockMarketAssets = [
    const MarketAsset(
      name: 'Factory New Dragon Lore',
      type: 'CS:GO Skin',
      health: 'Bullish',
      price: 12500.00,
      change: 2.4,
      icon: FontAwesomeIcons.gun,
    ),
    const MarketAsset(
      name: 'Ethereum',
      type: 'Crypto',
      health: 'Stable',
      price: 2450.50,
      change: -0.5,
      icon: FontAwesomeIcons.ethereum,
    ),
    const MarketAsset(
      name: 'Bored Ape Yacht Club #451',
      type: 'NFT',
      health: 'Volatile',
      price: 65200.00,
      change: -12.4,
      icon: Icons.auto_awesome,
    ),
    const MarketAsset(
      name: 'Tesla Inc.',
      type: 'Stock',
      health: 'Bullish',
      price: 242.10,
      change: 1.2,
      icon: Icons.trending_up,
    ),
  ];

  @override
  Future<List<MarketAsset>> getMarketAssets() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockMarketAssets;
  }
}
