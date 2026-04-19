import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:aether/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../domain/models/asset_model.dart';
import '../../logic/blocs/dashboard/dashboard_state.dart';

class NetWorthGraph extends StatelessWidget {
  final List<HistoryPoint> history;
  final double totalAmount;
  final TimeRange timeRange;
  final bool showHeader;

  const NetWorthGraph({
    super.key,
    required this.history,
    required this.totalAmount,
    this.timeRange = TimeRange.oneMonth,
    this.showHeader = true,
  });

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context)!;

    const minX = 0.0;
    final maxX = (history.length - 1).toDouble();

    final values = history.map((e) => e.value).toList();
    final minValue = values.reduce((a, b) => a < b ? a : b);
    final maxValue = values.reduce((a, b) => a > b ? a : b);

    final yPadding =
        (maxValue - minValue) == 0 ? 10.0 : (maxValue - minValue) * 0.2;
    final minY = minValue - yPadding;
    final maxY = maxValue + yPadding;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showHeader) ...[
          Text(
            l10n.totalNetWorth,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '\$${totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),
          ),
          const SizedBox(height: 15),
        ],
        Expanded(
          child: LineChart(
            LineChartData(
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (touchedSpot) =>
                      Colors.white.withValues(alpha: 0.8),
                  getTooltipItems: (List<LineBarSpot> touchedSpots) {
                    return touchedSpots.map((LineBarSpot touchedSpot) {
                      final date = history[touchedSpot.x.toInt()].date;
                      final value = touchedSpot.y;
                      return LineTooltipItem(
                        '${DateFormat('dd MM').format(date)}\n\$${value.toStringAsFixed(2)}',
                        const TextStyle(
                            color: Color(0xFF2E3192),
                            fontWeight: FontWeight.bold),
                      );
                    }).toList();
                  },
                ),
                handleBuiltInTouches: true,
              ),
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              minX: minX,
              maxX: maxX,
              minY: minY,
              maxY: maxY,
              lineBarsData: [
                LineChartBarData(
                  spots: history.asMap().entries.map((entry) {
                    return FlSpot(entry.key.toDouble(), entry.value.value);
                  }).toList(),
                  isCurved: true,
                  color: Colors.white,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.3),
                        Colors.white.withValues(alpha: 0.0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('dd MMM').format(history.first.date),
              style: const TextStyle(color: Colors.white60, fontSize: 10),
            ),
            Text(
              DateFormat('dd MMM').format(history.last.date),
              style: const TextStyle(color: Colors.white60, fontSize: 10),
            ),
          ],
        ),
      ],
    );
  }
}
