import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:aether/l10n/app_localizations.dart';
import '../../../domain/models/market_asset.dart';
import '../../../logic/blocs/discovery/discovery_bloc.dart';
import '../../../logic/blocs/discovery/discovery_event.dart';
import '../../../logic/blocs/discovery/discovery_state.dart';
import '../../widgets/skeleton_loader.dart';
import '../../utils/market_asset_icons.dart';

class DiscoveryHubPage extends StatefulWidget {
  const DiscoveryHubPage({super.key});

  @override
  State<DiscoveryHubPage> createState() => _DiscoveryHubPageState();
}

class _DiscoveryHubPageState extends State<DiscoveryHubPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<DiscoveryBloc>().add(FetchDiscoveryAssets());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.discoveryHub, style: const TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => context.read<DiscoveryBloc>().add(SearchDiscoveryAssets(val)),
              decoration: InputDecoration(
                hintText: l10n.searchDiscovery,
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: isDark ? Colors.white10 : Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<DiscoveryBloc, DiscoveryState>(
              builder: (context, state) {
                if (state.status == DiscoveryStatus.loading) {
                  return const DiscoverySkeleton();
                } else if (state.status == DiscoveryStatus.failure) {
                  return Center(child: Text(l10n.failedToLoadAssets));
                } else if (state.status == DiscoveryStatus.success) {
                  final filteredAssets = state.filteredAssets;
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: filteredAssets.length,
                    itemBuilder: (context, index) {
                      final asset = filteredAssets[index];
                      return _buildMarketAssetCard(asset, isDark, l10n);
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketAssetCard(MarketAsset asset, bool isDark, AppLocalizations l10n) {
    final isPositive = asset.change >= 0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFF2E3192).withValues(alpha: 0.1),
                child: Icon(marketAssetIcon(asset.type), color: const Color(0xFF2E3192), size: 18),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(asset.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(_getTranslatedType(asset.type, l10n), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('\$${asset.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    '${isPositive ? '+' : ''}${asset.change}%',
                    style: TextStyle(color: isPositive ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildHealthIndicator(asset.health, l10n),
              SizedBox(
                height: 30,
                width: 100,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: const [
                          FlSpot(0, 3),
                          FlSpot(1, 4),
                          FlSpot(2, 3.5),
                          FlSpot(3, 5),
                          FlSpot(4, 4),
                        ],
                        isCurved: true,
                        color: isPositive ? Colors.green : Colors.red,
                        barWidth: 2,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E3192),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(l10n.add, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHealthIndicator(String health, AppLocalizations l10n) {
    Color color;
    String label;
    switch (health) {
      case 'Bullish': 
        color = Colors.green;
        label = l10n.bullish;
        break;
      case 'Stable': 
        color = Colors.blue;
        label = l10n.stable;
        break;
      case 'Volatile': 
        color = Colors.orange;
        label = l10n.volatile;
        break;
      default: 
        color = Colors.grey;
        label = health;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  String _getTranslatedType(String type, AppLocalizations l10n) {
    switch (type) {
      case 'CS:GO Skin':
        return l10n.csgoSkin;
      case 'Crypto':
        return l10n.crypto;
      case 'NFT':
        return l10n.nft;
      case 'Stock':
        return l10n.stock;
      default:
        return type;
    }
  }
}
