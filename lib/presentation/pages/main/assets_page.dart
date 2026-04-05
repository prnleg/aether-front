import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aether/l10n/app_localizations.dart';
import '../../../logic/blocs/dashboard/dashboard_bloc.dart';
import '../../../logic/blocs/dashboard/dashboard_state.dart';
import '../../../logic/blocs/discovery/discovery_bloc.dart';
import '../../../service_locator.dart';
import '../../../domain/models/asset_model.dart';
import '../../widgets/asset_detail_modal.dart';
import '../assets/add_asset_page.dart';
import 'discovery_hub_page.dart';

class AssetsPage extends StatefulWidget {
  const AssetsPage({super.key});

  @override
  State<AssetsPage> createState() => _AssetsPageState();
}

class _AssetsPageState extends State<AssetsPage> {
  final TextEditingController _searchController = TextEditingController();
  AssetType? _selectedType;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.assets,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.explore_outlined),
            tooltip: 'Discovery Hub',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => sl<DiscoveryBloc>(),
                  child: const DiscoveryHubPage(),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DashboardLoaded) {
            final filteredAssets = state.assets.where((asset) {
              final matchesSearch =
                  asset.name.toLowerCase().contains(_searchQuery.toLowerCase());
              final matchesType =
                  _selectedType == null || asset.type == _selectedType;
              return matchesSearch && matchesType;
            }).toList();

            return Column(
              children: [
                _buildSearchAndFilter(context, l10n),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      const SizedBox(height: 10),
                      _buildAddAssetCard(context, l10n.addNewAsset),
                      const SizedBox(height: 20),
                      if (filteredAssets.isEmpty)
                        _buildEmptyState(context, l10n)
                      else
                        ...filteredAssets.map(
                            (asset) => _buildAssetListItem(context, asset)),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            );
          } else if (state is DashboardError) {
            return Center(child: Text(state.message));
          }
          return _buildEmptyState(context, l10n);
        },
      ),
    );
  }

  Widget _buildSearchAndFilter(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: InputDecoration(
              hintText: l10n.searchAssets,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
              filled: true,
              fillColor: Theme.of(context).cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(null, l10n.all),
                ...AssetType.values.map(
                    (type) => _buildFilterChip(type, _getTypeName(type, l10n))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(AssetType? type, String label) {
    final isSelected = _selectedType == type;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedType = selected ? type : null;
          });
        },
        selectedColor: const Color(0xFF2E3192).withValues(alpha: 0.2),
        checkmarkColor: const Color(0xFF2E3192),
        labelStyle: TextStyle(
          color: isSelected ? const Color(0xFF2E3192) : null,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  String _getTypeName(AssetType type, AppLocalizations l10n) {
    switch (type) {
      case AssetType.crypto:
        return 'Crypto';
      case AssetType.inventory:
        return 'Inventory';
      case AssetType.collectible:
        return 'Collectible';
      case AssetType.cash:
        return 'Cash';
      case AssetType.stock:
        return 'Stock';
    }
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off,
                size: 64, color: Colors.grey.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty || _selectedType != null
                  ? l10n.noAssetsMatch
                  : l10n.noAssetsFound,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddAssetCard(BuildContext context, String label) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddAssetPage()),
      ),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF2E3192).withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: const Color(0xFF2E3192).withValues(alpha: 0.2),
              width: 2,
              style: BorderStyle.solid),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_circle_outline, color: Color(0xFF2E3192)),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF2E3192),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetListItem(BuildContext context, Asset asset) {
    final bool isPositive = asset.change24h >= 0;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ??
            (isDarkMode ? Colors.white10 : Colors.white),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: () => AssetDetailModal.show(context, asset),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.white10 : const Color(0xFFF5F7FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child:
              Icon(_getIconForType(asset.type), color: const Color(0xFF2E3192)),
        ),
        title: Text(
          asset.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        subtitle: Text(asset.typeName),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${asset.value.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPositive ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: isPositive ? Colors.green : Colors.red,
                  size: 16,
                ),
                Text(
                  '${asset.change24h.abs().toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: isPositive ? Colors.green : Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForType(AssetType type) {
    switch (type) {
      case AssetType.crypto:
        return Icons.currency_bitcoin;
      case AssetType.inventory:
        return Icons.videogame_asset;
      case AssetType.collectible:
        return Icons.auto_awesome;
      case AssetType.stock:
        return Icons.trending_up;
      case AssetType.cash:
        return Icons.money;
    }
  }
}
