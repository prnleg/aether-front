import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aether/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:animations/animations.dart';
import '../../logic/blocs/dashboard/dashboard_bloc.dart';
import '../../logic/blocs/dashboard/dashboard_event.dart';
import '../../logic/blocs/dashboard/dashboard_state.dart';
import '../../logic/blocs/settings/settings_bloc.dart';
import '../../logic/blocs/settings/settings_event.dart';
import '../../logic/blocs/settings/settings_state.dart';
import '../../domain/models/asset_model.dart';
import '../widgets/net_worth_graph.dart';
import '../widgets/asset_detail_modal.dart';
import '../widgets/skeleton_loader.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(l10n.dashboard,
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        actions: [
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              return IconButton(
                icon: Icon(state.themeMode == ThemeMode.light
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined),
                onPressed: () =>
                    context.read<SettingsBloc>().add(ToggleTheme()),
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
          return const DashboardSkeleton();
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
                  timeRange: state.timeRange,
                ),
                const SizedBox(height: 15),
                _buildRangeSelector(context, state.timeRange, l10n),
                const SizedBox(height: 30),
                _buildSectionHeader(context, l10n.portfolioStats, true),
                const SizedBox(height: 15),
                _buildStatsGrid(context, state.assets),
                const SizedBox(height: 30),
                _buildSectionHeader(context, l10n.yourAssets, false),
                const SizedBox(height: 15),
                MasonryGridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.assets.length,
                  itemBuilder: (context, index) {
                    final asset = state.assets[index];
                    final bool isBigMover = asset.change24h.abs() > 5.0;

                    return OpenContainer(
                      transitionDuration: const Duration(milliseconds: 500),
                      openElevation: 0,
                      closedElevation: 0,
                      closedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      closedColor: Colors.transparent,
                      openColor: Theme.of(context).scaffoldBackgroundColor,
                      openBuilder: (context, action) =>
                          AssetDetailModal(asset: asset),
                      closedBuilder: (context, action) =>
                          _buildPulseAssetCard(context, asset, isBigMover),
                    );
                  },
                ),
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

  Widget _buildPulseAssetCard(
      BuildContext context, Asset asset, bool isBigMover) {
    final isPositive = asset.change24h >= 0;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ??
            (isDarkMode ? Colors.white10 : Colors.white),
        borderRadius: BorderRadius.circular(20),
        border: isBigMover
            ? Border.all(
                color: (isPositive ? Colors.green : Colors.red)
                    .withValues(alpha: 0.3),
                width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.white10 : const Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(_getIconForType(asset.type),
                    size: 18, color: const Color(0xFF2E3192)),
              ),
              if (isBigMover)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: (isPositive ? Colors.green : Colors.red)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Pulse',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isPositive ? Colors.green : Colors.red,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            asset.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            asset.typeName,
            style: const TextStyle(color: Colors.grey, fontSize: 11),
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '\$${asset.value.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          const SizedBox(height: 4),
          Row(
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
          const SizedBox(height: 12),
          if (asset.history.isNotEmpty)
            SizedBox(
              height: 40,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: asset.history
                          .take(10)
                          .toList()
                          .asMap()
                          .entries
                          .map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value.value);
                      }).toList(),
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
        ],
      ),
    );
  }

  Widget _buildRangeSelector(
      BuildContext context, TimeRange currentRange, AppLocalizations l10n) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: TimeRange.values.map((range) {
          final isSelected = currentRange == range;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(_getRangeLabel(range, l10n)),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  context.read<DashboardBloc>().add(ChangeTimeRange(range));
                }
              },
              selectedColor: const Color(0xFF2E3192),
              labelStyle: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isDarkMode ? Colors.white70 : Colors.black87),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getRangeLabel(TimeRange range, AppLocalizations l10n) {
    switch (range) {
      case TimeRange.oneWeek:
        return l10n.oneWeekShort;
      case TimeRange.oneMonth:
        return l10n.oneMonthShort;
      case TimeRange.threeMonths:
        return l10n.threeMonthsShort;
      case TimeRange.sixMonths:
        return l10n.sixMonthsShort;
      case TimeRange.oneYear:
        return l10n.oneYearShort;
      case TimeRange.all:
        return l10n.allShort;
    }
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
            _buildStatItem(
                context, l10n.totalAssets, '${assets.length}', Icons.list_alt),
            _buildStatItem(
                context,
                l10n.highestValue,
                '\$${assets.isEmpty ? 0 : assets.map((e) => e.value).reduce((a, b) => a > b ? a : b).toStringAsFixed(0)}',
                Icons.trending_up),
            _buildStatItem(context, l10n.categories,
                '${assets.map((e) => e.type).toSet().length}', Icons.category),
            _buildStatItem(
                context, l10n.dailyProfit, '+\$450.00', Icons.attach_money),
          ],
        );
      },
    );
  }

  Widget _buildStatItem(
      BuildContext context, String label, String value, IconData icon) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ??
            (isDarkMode ? Colors.white10 : Colors.white),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
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
                  Text(label,
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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

Widget _buildRangeSelector(
    BuildContext context, TimeRange currentRange, AppLocalizations l10n) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: TimeRange.values.map((range) {
        final isSelected = currentRange == range;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ChoiceChip(
            label: Text(_getRangeLabel(range, l10n)),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                context.read<DashboardBloc>().add(ChangeTimeRange(range));
              }
            },
            selectedColor: const Color(0xFF2E3192),
            labelStyle: TextStyle(
              color: isSelected
                  ? Colors.white
                  : (isDarkMode ? Colors.white70 : Colors.black87),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        );
      }).toList(),
    ),
  );
}

String _getRangeLabel(TimeRange range, AppLocalizations l10n) {
  switch (range) {
    case TimeRange.oneWeek:
      return l10n.oneWeekShort;
    case TimeRange.oneMonth:
      return l10n.oneMonthShort;
    case TimeRange.threeMonths:
      return l10n.threeMonthsShort;
    case TimeRange.sixMonths:
      return l10n.sixMonthsShort;
    case TimeRange.oneYear:
      return l10n.oneYearShort;
    case TimeRange.all:
      return l10n.allShort;
  }
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
          _buildStatItem(
              context, l10n.totalAssets, '${assets.length}', Icons.list_alt),
          _buildStatItem(
              context,
              l10n.highestValue,
              '\$${assets.isEmpty ? 0 : assets.map((e) => e.value).reduce((a, b) => a > b ? a : b).toStringAsFixed(0)}',
              Icons.trending_up),
          _buildStatItem(context, l10n.categories,
              '${assets.map((e) => e.type).toSet().length}', Icons.category),
          _buildStatItem(
              context, l10n.dailyProfit, '+\$450.00', Icons.attach_money),
        ],
      );
    },
  );
}

Widget _buildStatItem(
    BuildContext context, String label, String value, IconData icon) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: Theme.of(context).cardTheme.color ??
          (isDarkMode ? Colors.white10 : Colors.white),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.02),
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
                Text(label,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
