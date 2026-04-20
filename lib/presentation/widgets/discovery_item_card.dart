import 'package:flutter/material.dart';
import 'package:aether/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/discovery_item.dart';
import '../../logic/blocs/discovery/discovery_bloc.dart';
import '../../logic/blocs/discovery/discovery_event.dart';

class DiscoveryItemCard extends StatelessWidget {
  final DiscoveryItem item;
  final bool isDark;
  final bool isApproving;
  final bool isRejecting;

  const DiscoveryItemCard({
    super.key,
    required this.item,
    required this.isDark,
    required this.isApproving,
    required this.isRejecting,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bloc = context.read<DiscoveryBloc>();
    final isBusy = isApproving || isRejecting;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          DiscoveryItemIcon(iconUrl: item.iconUrl),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.marketHashName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                if (item.marketPriceAmount != null)
                  Text(
                    '${item.marketPriceCurrency ?? '\$'} ${item.marketPriceAmount!.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          if (isBusy)
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else ...[
            _ActionButton(
              icon: Icons.close,
              color: Colors.red,
              label: l10n.reject,
              onPressed: () => bloc.add(RejectDiscoveryItem(item.id)),
            ),
            const SizedBox(width: 8),
            _ActionButton(
              icon: Icons.check,
              color: Colors.green,
              label: l10n.approve,
              onPressed: () => bloc.add(ApproveDiscoveryItem(item.id)),
            ),
          ],
        ],
      ),
    );
  }
}

class DiscoveryItemIcon extends StatelessWidget {
  final String iconUrl;

  const DiscoveryItemIcon({super.key, required this.iconUrl});

  @override
  Widget build(BuildContext context) {
    if (iconUrl.isEmpty) return const _FallbackIcon();
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        iconUrl,
        width: 52,
        height: 52,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const _FallbackIcon(),
      ),
    );
  }
}

class _FallbackIcon extends StatelessWidget {
  const _FallbackIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFF2E3192).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(Icons.inventory_2_outlined,
          color: Color(0xFF2E3192), size: 24),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }
}

/// Maps Steam appId to a human-readable game name.
String discoveryAppName(String appId) {
  switch (appId) {
    case '730':
      return 'CS2 (Counter-Strike 2)';
    case '570':
      return 'Dota 2';
    case '440':
      return 'Team Fortress 2';
    case '252490':
      return 'Rust';
    default:
      return 'App $appId';
  }
}

/// Maps Steam appId to a color accent.
Color discoveryAppColor(String appId) {
  switch (appId) {
    case '730':
      return const Color(0xFFE8A000); // CS2 gold
    case '570':
      return const Color(0xFF8B1A1A); // Dota red
    case '440':
      return const Color(0xFF8B4513); // TF2 brown
    default:
      return const Color(0xFF2E3192);
  }
}
