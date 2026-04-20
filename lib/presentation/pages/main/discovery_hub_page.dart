import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aether/l10n/app_localizations.dart';
import '../../../domain/models/discovery_item.dart';
import '../../../domain/models/sync_result.dart';
import '../../../logic/blocs/discovery/discovery_bloc.dart';
import '../../../logic/blocs/discovery/discovery_event.dart';
import '../../../logic/blocs/discovery/discovery_state.dart';
import '../../widgets/skeleton_loader.dart';
import '../../widgets/discovery_item_card.dart';
import 'discovery_group_page.dart';

enum _MenuAction { rejectCheap }

class DiscoveryHubPage extends StatefulWidget {
  const DiscoveryHubPage({super.key});

  @override
  State<DiscoveryHubPage> createState() => _DiscoveryHubPageState();
}

class _DiscoveryHubPageState extends State<DiscoveryHubPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const _filters = [
    ('PendingApproval', 'pendingReview'),
    ('Available', 'available'),
    (null, 'all'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _filters.length, vsync: this);
    context.read<DiscoveryBloc>().add(const LoadDiscoveryItems());
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    final filter = _filters[_tabController.index].$1;
    context.read<DiscoveryBloc>().add(FilterDiscoveryItems(filter));
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _openGroup(BuildContext context, String appId) {
    final bloc = context.read<DiscoveryBloc>();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: DiscoveryGroupPage(
            appId: appId,
            appName: discoveryAppName(appId),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<DiscoveryBloc, DiscoveryState>(
      listenWhen: (prev, curr) =>
          curr.syncResult != prev.syncResult ||
          curr.error != prev.error ||
          (prev.isBulkRejecting && !curr.isBulkRejecting),
      listener: (context, state) {
        if (state.syncResult != null) {
          _showSyncResultSnackbar(context, state.syncResult!, l10n);
        }
        if (state.error != null && !state.isSyncing) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.actionFailed)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.discoveryHub,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          elevation: 0,
          actions: [
            BlocBuilder<DiscoveryBloc, DiscoveryState>(
              buildWhen: (p, c) =>
                  p.isBulkRejecting != c.isBulkRejecting ||
                  p.items != c.items,
              builder: (context, state) {
                if (state.isBulkRejecting) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }
                return PopupMenuButton<_MenuAction>(
                  onSelected: (action) {
                    if (action == _MenuAction.rejectCheap) {
                      _showBulkRejectDialog(context, l10n, state.items);
                    }
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: _MenuAction.rejectCheap,
                      child: Row(
                        children: [
                          const Icon(Icons.delete_sweep_outlined,
                              color: Colors.red, size: 20),
                          const SizedBox(width: 10),
                          Text(l10n.rejectCheapItems,
                              style: const TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            labelColor: const Color(0xFF2E3192),
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color(0xFF2E3192),
            tabs: [
              Tab(text: l10n.pendingReview),
              Tab(text: l10n.available),
              Tab(text: l10n.all),
            ],
          ),
        ),
        floatingActionButton: BlocBuilder<DiscoveryBloc, DiscoveryState>(
          buildWhen: (prev, curr) => curr.isSyncing != prev.isSyncing,
          builder: (context, state) {
            return FloatingActionButton.extended(
              onPressed: state.isSyncing
                  ? null
                  : () => _showSyncModal(context, l10n),
              backgroundColor: const Color(0xFF2E3192),
              foregroundColor: Colors.white,
              icon: state.isSyncing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : const Icon(Icons.sync),
              label: Text(l10n.syncInventory),
            );
          },
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<DiscoveryBloc>().add(RefreshDiscoveryItems());
          },
          child: BlocBuilder<DiscoveryBloc, DiscoveryState>(
            builder: (context, state) {
              if (state.status == DiscoveryStatus.loading) {
                return const DiscoverySkeleton();
              }
              if (state.status == DiscoveryStatus.failure) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(l10n.failedToLoadAssets),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => context
                            .read<DiscoveryBloc>()
                            .add(RefreshDiscoveryItems()),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }
              if (state.items.isEmpty) {
                return Center(child: Text(l10n.noDiscoveryItems));
              }

              // Group items by appId.
              final groups = <String, List<DiscoveryItem>>{};
              for (final item in state.items) {
                groups.putIfAbsent(item.appId, () => []).add(item);
              }
              final appIds = groups.keys.toList();

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                itemCount: appIds.length,
                itemBuilder: (context, index) {
                  final id = appIds[index];
                  return _GroupCard(
                    appId: id,
                    items: groups[id]!,
                    isDark: isDark,
                    onTap: () => _openGroup(context, id),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showSyncResultSnackbar(
    BuildContext context,
    SyncResult result,
    AppLocalizations l10n,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            l10n.syncResult(result.added, result.updated, result.skipped)),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void _showBulkRejectDialog(
    BuildContext context,
    AppLocalizations l10n,
    List<DiscoveryItem> items,
  ) {
    final controller = TextEditingController(text: '0.10');
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final threshold =
              double.tryParse(controller.text.replaceAll(',', '.')) ?? 0.0;
          final count = items
              .where((i) =>
                  i.marketPriceAmount != null &&
                  i.marketPriceAmount! <= threshold)
              .length;

          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            title: Text(l10n.rejectCheapItems),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.rejectBelowPrice,
                    style: const TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: l10n.priceThreshold,
                    prefixText: '\$ ',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                  ),
                  onChanged: (_) => setDialogState(() {}),
                ),
                const SizedBox(height: 12),
                Text(
                  count == 0
                      ? l10n.noCheapItems
                      : l10n.rejectCountConfirm(count),
                  style: TextStyle(
                    color: count == 0 ? Colors.grey : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: count == 0
                    ? null
                    : () {
                        Navigator.pop(ctx);
                        context
                            .read<DiscoveryBloc>()
                            .add(BulkRejectBelowPrice(threshold));
                      },
                child: Text(l10n.rejectCountConfirm(count)),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showSyncModal(BuildContext context, AppLocalizations l10n) {
    final customController = TextEditingController();
    String? selectedAppId = '730';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                24,
                24,
                24,
                MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.syncSteamInventory,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.syncWarning,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 20),
                  Text(l10n.selectGame,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  _AppIdTile(
                    label: l10n.cs2,
                    appId: '730',
                    selected: selectedAppId == '730',
                    onTap: () => setModalState(() => selectedAppId = '730'),
                  ),
                  const SizedBox(height: 8),
                  _AppIdTile(
                    label: l10n.dota2,
                    appId: '570',
                    selected: selectedAppId == '570',
                    onTap: () => setModalState(() => selectedAppId = '570'),
                  ),
                  const SizedBox(height: 8),
                  _AppIdTile(
                    label: l10n.customAppId,
                    appId: 'custom',
                    selected: selectedAppId == 'custom',
                    onTap: () => setModalState(() => selectedAppId = 'custom'),
                  ),
                  if (selectedAppId == 'custom') ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: customController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: l10n.enterAppId,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E3192),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        final appId = selectedAppId == 'custom'
                            ? customController.text.trim()
                            : selectedAppId!;
                        if (appId.isEmpty) return;
                        Navigator.pop(ctx);
                        context
                            .read<DiscoveryBloc>()
                            .add(SyncSteamInventory([appId]));
                      },
                      child: Text(l10n.syncInventory,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _GroupCard extends StatelessWidget {
  final String appId;
  final List<DiscoveryItem> items;
  final bool isDark;
  final VoidCallback onTap;

  const _GroupCard({
    required this.appId,
    required this.items,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final accent = discoveryAppColor(appId);
    final name = discoveryAppName(appId);
    final totalValue = items.fold<double>(
        0, (sum, i) => sum + (i.marketPriceAmount ?? 0));
    final currency = items
            .firstWhere((i) => i.marketPriceCurrency != null,
                orElse: () => items.first)
            .marketPriceCurrency ??
        '\$';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark ? Colors.white10 : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: accent.withValues(alpha: 0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.videogame_asset_rounded,
                    color: accent, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${items.length} items',
                            style: TextStyle(
                                color: accent,
                                fontSize: 11,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$currency ${totalValue.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 2),
                  const Icon(Icons.chevron_right,
                      color: Colors.grey, size: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppIdTile extends StatelessWidget {
  final String label;
  final String appId;
  final bool selected;
  final VoidCallback onTap;

  const _AppIdTile({
    required this.label,
    required this.appId,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? const Color(0xFF2E3192)
                : Colors.grey.withValues(alpha: 0.3),
            width: selected ? 2 : 1,
          ),
          color: selected
              ? const Color(0xFF2E3192).withValues(alpha: 0.08)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(label,
                  style: TextStyle(
                    fontWeight:
                        selected ? FontWeight.bold : FontWeight.normal,
                    color: selected ? const Color(0xFF2E3192) : null,
                  )),
            ),
            if (selected)
              const Icon(Icons.check_circle,
                  color: Color(0xFF2E3192), size: 18),
          ],
        ),
      ),
    );
  }
}
