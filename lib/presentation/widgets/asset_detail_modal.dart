import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aether/l10n/app_localizations.dart';
import '../../domain/models/asset_model.dart';
import '../../logic/blocs/dashboard/dashboard_bloc.dart';
import '../../logic/blocs/dashboard/dashboard_event.dart';
import '../utils/asset_type_labels.dart';
import 'dart:math' as math;
import 'dart:ui';

class AssetDetailModal extends StatelessWidget {
  final Asset asset;
  final double? totalNetWorth;
  final bool isFromOpenContainer;

  const AssetDetailModal({
    super.key,
    required this.asset,
    this.totalNetWorth,
    this.isFromOpenContainer = true,
  });

  static Future<void> show(BuildContext context, Asset asset, {double? totalNetWorth}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AssetDetailModal(
        asset: asset, 
        totalNetWorth: totalNetWorth,
        isFromOpenContainer: false
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPositive = asset.change24h >= 0;
    final content = Column(
      children: [
        if (!isFromOpenContainer) _buildHandle(),
        if (isFromOpenContainer)
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            children: [
              _buildHeader(context, isPositive),
              const SizedBox(height: 30),
              _buildGraph(context, isPositive),
              const SizedBox(height: 30),
              if (totalNetWorth != null) ...[
                _buildPortfolioWeighting(context),
                const SizedBox(height: 30),
              ],
              _buildDeepDiveGrid(context),
              const SizedBox(height: 30),
              _buildHistoricalTimeline(context),
              const SizedBox(height: 30),
              _buildActionButtons(context),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ],
    );

    if (isFromOpenContainer) {
      return Scaffold(
        body: SafeArea(child: content),
      );
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.8),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: content,
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 12),
        width: 40,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isPositive) {
    return Column(
      children: [
        Hero(
          tag: 'asset_icon_${asset.id}',
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color ?? Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                )
              ],
            ),
            child: Icon(_getIconForType(asset.type),
                size: 40, color: const Color(0xFF2E3192)),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          asset.name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          assetTypeLabel(asset.type, AppLocalizations.of(context)!),
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 20),
        Text(
          '\$${asset.value.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isPositive ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: isPositive ? Colors.green : Colors.red,
            ),
            Text(
              '${asset.change24h.abs().toStringAsFixed(2)}% (24h)',
              style: TextStyle(
                color: isPositive ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGraph(BuildContext context, bool isPositive) {
    if (asset.history.isEmpty) return const SizedBox.shrink();

    final values = asset.history.map((e) => e.value).toList();
    final minValue = values.reduce((a, b) => a < b ? a : b);
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final yPadding = (maxValue - minValue) * 0.15;

    return Container(
      height: 200,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
          )
        ],
      ),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          minY: minValue - yPadding,
          maxY: maxValue + yPadding,
          lineBarsData: [
            LineChartBarData(
              spots: asset.history.asMap().entries.map((entry) {
                return FlSpot(entry.key.toDouble(), entry.value.value);
              }).toList(),
              isCurved: true,
              color: isPositive ? Colors.green : Colors.red,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    (isPositive ? Colors.green : Colors.red)
                        .withValues(alpha: 0.2),
                    (isPositive ? Colors.green : Colors.red)
                        .withValues(alpha: 0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPortfolioWeighting(BuildContext context) {
    final weight = (asset.value / (totalNetWorth ?? 1)) * 100;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? (isDarkMode ? Colors.white10 : Colors.white),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
          )
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            height: 100,
            width: 100,
            child: PieChart(
              PieChartData(
                sectionsSpace: 0,
                centerSpaceRadius: 35,
                sections: [
                  PieChartSectionData(
                    color: const Color(0xFF2E3192),
                    value: weight,
                    title: '',
                    radius: 12,
                  ),
                  PieChartSectionData(
                    color: Colors.grey.withValues(alpha: 0.1),
                    value: 100 - weight,
                    title: '',
                    radius: 10,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.portfolioWeight,
                  style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  '${weight.toStringAsFixed(1)}%',
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  weight > 50 ? l10n.highConcentrationRisk : (weight > 20 ? l10n.exposureModerate : l10n.diversified),
                  style: TextStyle(
                    fontSize: 12, 
                    color: weight > 50 ? Colors.red : (weight > 20 ? Colors.orange : Colors.green),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeepDiveGrid(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.deepDiveAnalysis,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: _buildVolatilityGauge(context),
            ),
            const SizedBox(width: 15),
            Expanded(
              flex: 1,
              child: _buildCorrelationList(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVolatilityGauge(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    // Mock volatility value
    final double volatility = 0.65; // 0.0 to 1.0

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ??
            (isDarkMode ? Colors.white10 : Colors.white),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(l10n.volatilityIndex,
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 10),
          SizedBox(
            height: 80,
            width: 80,
            child: CustomPaint(
              painter: GaugePainter(
                value: volatility,
                color: volatility > 0.7
                    ? Colors.red
                    : (volatility > 0.4 ? Colors.orange : Colors.green),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            volatility > 0.7 ? l10n.high : (volatility > 0.4 ? l10n.medium : l10n.low),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildCorrelationList(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final correlations = asset.correlations;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ??
            (isDarkMode ? Colors.white10 : Colors.white),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.correlations,
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 10),
          if (correlations.isEmpty)
            Text(l10n.noCorrelations,
                style: const TextStyle(fontSize: 11, color: Colors.grey))
          else
            ...correlations.map((corr) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(corr.name,
                          style: const TextStyle(fontSize: 11)),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: corr.value > 0
                              ? Colors.green.withValues(alpha: 0.1)
                              : Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          corr.value.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: corr.value > 0
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
        ],
      ),
    );
  }

  Widget _buildHistoricalTimeline(BuildContext context) {
    final milestones = asset.milestones;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.historicalJourney,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        if (milestones.isEmpty)
          Text(l10n.noMilestones, style: const TextStyle(color: Colors.grey, fontSize: 13))
        else
          ...milestones.asMap().entries.map((entry) {
            final index = entry.key;
            final milestone = entry.value;
            final isLast = index == milestones.length - 1;

            return IntrinsicHeight(
              child: Row(
                children: [
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E3192).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(milestone.icon,
                            size: 16, color: const Color(0xFF2E3192)),
                      ),
                      if (!isLast)
                        Expanded(
                          child: Container(
                            width: 2,
                            color: Colors.grey[300],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(milestone.date,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey)),
                          Text(milestone.event,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text('Price: ${milestone.price}',
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.blueGrey)),
                          if (milestone.event == 'All-Time High')
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                l10n.sellHypothetical('+\$${(asset.value * 0.4).toStringAsFixed(2)}'),
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.orange,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              HapticFeedback.lightImpact();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E3192),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            child: Text(l10n.editAsset,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 15),
        Container(
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () => _confirmDelete(context),
          ),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context) {
    HapticFeedback.lightImpact();
    showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remove asset'),
        content: Text('Remove "${asset.name}" from your portfolio?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true && context.mounted) {
        context.read<DashboardBloc>().add(DeleteAsset(asset.id));
        Navigator.of(context).pop(); // close the detail modal
      }
    });
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

class GaugePainter extends CustomPainter {
  final double value; // 0.0 to 1.0
  final Color color;

  GaugePainter({required this.value, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const startAngle = math.pi * 0.8;
    const sweepAngle = math.pi * 1.4;

    final backgroundPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle,
        sweepAngle, false, backgroundPaint);

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle,
        sweepAngle * value, false, progressPaint);

    // Draw needle
    final needleAngle = startAngle + (sweepAngle * value);
    final needlePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(needleAngle);
    final path = Path()
      ..moveTo(0, -4)
      ..lineTo(radius - 10, 0)
      ..lineTo(0, 4)
      ..close();
    canvas.drawPath(path, needlePaint);
    canvas.drawCircle(Offset.zero, 5, needlePaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
