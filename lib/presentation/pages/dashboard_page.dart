import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../logic/blocs/dashboard/dashboard_bloc.dart';
import '../../logic/blocs/dashboard/dashboard_event.dart';
import '../../logic/blocs/dashboard/dashboard_state.dart';
import '../../logic/blocs/settings/settings_bloc.dart';
import '../../logic/blocs/settings/settings_event.dart';
import '../../logic/blocs/settings/settings_state.dart';
import '../../domain/models/asset_model.dart';
import '../widgets/net_worth_graph.dart';
import '../widgets/asset_detail_modal.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(l10n.dashboard, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        actions: [
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              return IconButton(
                icon: Icon(state.themeMode == ThemeMode.light 
                    ? Icons.dark_mode_outlined 
                    : Icons.light_mode_outlined),
                onPressed: () => context.read<SettingsBloc>().add(ToggleTheme()),
              );
            },
          ),
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language),
            onSelected: (Locale locale) {
              context.read<SettingsBloc>().add(ChangeLanguage(locale));
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: Locale('en'),
                child: Text('English'),
              ),
              const PopupMenuItem(
                value: Locale('pt'),
                child: Text('Português'),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: const DashboardView(),
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DashboardLoaded) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<DashboardBloc>().add(RefreshDashboard());
            },
            child: ListView(
              padding: const EdgeInsets.all(20.0),
              children: [
                NetWorthGraph(
                  history: state.netWorthHistory,
                  totalAmount: state.totalNetWorth,
                ),
                const SizedBox(height: 30),
                _buildSectionHeader(context, l10n.portfolioStats, true),
                const SizedBox(height: 15),
                _buildStatsGrid(context, state.assets),
                const SizedBox(height: 30),
                _buildSectionHeader(context, l10n.yourAssets, false),
                const SizedBox(height: 15),
                ...state.assets.map((asset) => _buildAssetTile(context, asset, state.totalNetWorth)),
              ],
            ),
          );
        } else if (state is DashboardError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, bool isStats) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 10),
        TextButton(
          onPressed: () {
            context.go('/assets');
          },
          child: Text(l10n.seeAll),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(BuildContext context, List<Asset> assets) {
    final l10n = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 700 ? 4 : 2;
        final aspectRatio = constraints.maxWidth > 700 ? 3.0 : 2.0;

        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: aspectRatio,
          children: [
            _buildStatItem(context, l10n.totalAssets, '${assets.length}', Icons.list_alt),
            _buildStatItem(
              context,
              l10n.highestValue, 
              '\$${assets.isEmpty ? 0 : assets.map((e) => e.value).reduce((a, b) => a > b ? a : b).toStringAsFixed(0)}', 
              Icons.trending_up
            ),
            _buildStatItem(context, l10n.categories, '${assets.map((e) => e.type).toSet().length}', Icons.category),
            _buildStatItem(context, l10n.dailyProfit, '+\$450.00', Icons.attach_money),
          ],
        );
      },
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF2E3192)),
          const SizedBox(width: 8),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetTile(BuildContext context, Asset asset, double totalNetWorth) {
    final double percentage = (asset.value / totalNetWorth) * 100;
    final bool isPositive = asset.change24h >= 0;

    return InkWell(
      onTap: () => AssetDetailModal.show(context, asset),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color ?? Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light 
                    ? const Color(0xFFF5F7FA) 
                    : Colors.white10,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_getIconForType(asset.type), color: const Color(0xFF2E3192)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    asset.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${asset.typeName} • ${percentage.toStringAsFixed(1)}%',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '\$${asset.value.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
