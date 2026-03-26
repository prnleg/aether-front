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

  const NetWorthGraph({
    super.key,
    required this.history,
    required this.totalAmount,
    this.timeRange = TimeRange.oneMonth,
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

    // Add some padding to Y axis
    final yPadding =
        (maxValue - minValue) == 0 ? 10.0 : (maxValue - minValue) * 0.2;
    final minY = minValue - yPadding;
    final maxY = maxValue + yPadding;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E3192), Color(0xFF1BFFFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E3192).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.totalNetWorth,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 5),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '\$${totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 150,
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
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('dd MM, yyyy').format(history.first.date),
                style: const TextStyle(color: Colors.white60, fontSize: 10),
              ),
              Text(
                DateFormat('dd MM, yyyy').format(history.last.date),
                style: const TextStyle(color: Colors.white60, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
