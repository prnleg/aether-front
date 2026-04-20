import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aether/l10n/app_localizations.dart';
import '../../../domain/models/discovery_item.dart';
import '../../../logic/blocs/discovery/discovery_bloc.dart';
import '../../../logic/blocs/discovery/discovery_event.dart';
import '../../../logic/blocs/discovery/discovery_state.dart';
import '../../widgets/discovery_item_card.dart';
import '../../widgets/skeleton_loader.dart';

class DiscoveryGroupPage extends StatelessWidget {
  final String appId;
  final String appName;

  const DiscoveryGroupPage({
    super.key,
    required this.appId,
    required this.appName,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = discoveryAppColor(appId);

    return BlocListener<DiscoveryBloc, DiscoveryState>(
      listenWhen: (prev, curr) => curr.error != prev.error,
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.actionFailed)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(appName,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          elevation: 0,
          actions: [
            BlocBuilder<DiscoveryBloc, DiscoveryState>(
              buildWhen: (p, c) =>
                  p.isBulkRejecting != c.isBulkRejecting ||
                  p.items != c.items,
              builder: (context, state) {
                final groupItems = state.items
                    .where((i) => i.appId == appId)
                    .toList();

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
                return PopupMenuButton<_GroupMenuAction>(
                  onSelected: (action) {
                    if (action == _GroupMenuAction.rejectCheap) {
                      _showBulkRejectDialog(context, l10n, groupItems);
                    }
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: _GroupMenuAction.rejectCheap,
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
        ),
        body: RefreshIndicator(
          onRefresh: () async =>
              context.read<DiscoveryBloc>().add(RefreshDiscoveryItems()),
          child: BlocBuilder<DiscoveryBloc, DiscoveryState>(
            builder: (context, state) {
              if (state.status == DiscoveryStatus.loading &&
                  state.items.isEmpty) {
                return const DiscoverySkeleton();
              }

              final groupItems = state.items
                  .where((i) => i.appId == appId)
                  .toList();

              if (groupItems.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle_outline,
                          size: 64,
                          color: Colors.green.withValues(alpha: 0.6)),
                      const SizedBox(height: 16),
                      Text(
                        l10n.noDiscoveryItems,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  _GroupSummaryBanner(
                    appId: appId,
                    items: groupItems,
                    accentColor: accentColor,
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                      itemCount: groupItems.length,
                      itemBuilder: (context, index) {
                        final item = groupItems[index];
                        return DiscoveryItemCard(
                          item: item,
                          isDark: isDark,
                          isApproving: state.approvingId == item.id,
                          isRejecting: state.rejectingId == item.id,
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showBulkRejectDialog(
    BuildContext context,
    AppLocalizations l10n,
    List<DiscoveryItem> groupItems,
  ) {
    final controller = TextEditingController(text: '0.10');
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final threshold =
              double.tryParse(controller.text.replaceAll(',', '.')) ?? 0.0;
          final count = groupItems
              .where((i) =>
                  i.marketPriceAmount != null &&
                  i.marketPriceAmount! <= threshold)
              .length;

          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                  count == 0 ? l10n.noCheapItems : l10n.rejectCountConfirm(count),
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
}

enum _GroupMenuAction { rejectCheap }

class _GroupSummaryBanner extends StatelessWidget {
  final String appId;
  final List<DiscoveryItem> items;
  final Color accentColor;

  const _GroupSummaryBanner({
    required this.appId,
    required this.items,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final totalValue = items.fold<double>(
      0,
      (sum, i) => sum + (i.marketPriceAmount ?? 0),
    );
    final currency =
        items.firstWhere((i) => i.marketPriceCurrency != null,
                orElse: () => items.first)
            .marketPriceCurrency ??
        '\$';

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.videogame_asset_rounded,
                color: accentColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${items.length} items',
                    style: TextStyle(
                        color: accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
                Text('Total: $currency ${totalValue.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
