import 'package:flutter/material.dart';
import 'package:aether/l10n/app_localizations.dart';

class PlaygroundPage extends StatefulWidget {
  const PlaygroundPage({super.key});

  @override
  State<PlaygroundPage> createState() => _PlaygroundPageState();
}

class _PlaygroundPageState extends State<PlaygroundPage> {
  double _sellCSGOSkins = 0.0;
  double _buyCrypto = 0.0;
  double _projectedROI = 15.4;

  void _recalculate() {
    // Mock simulation logic
    setState(() {
      _projectedROI = 15.4 - (_sellCSGOSkins * 0.1) + (_buyCrypto * 0.2);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.playground,
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.whatIfSimulator,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.simulatorDesc,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            _buildSimulationCard(context, isDark, l10n),
            const SizedBox(height: 32),
            Text(
              l10n.scenarioParameters,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildSlider(
              l10n.sellSkins,
              _sellCSGOSkins,
              (val) {
                setState(() => _sellCSGOSkins = val);
                _recalculate();
              },
              Colors.red,
            ),
            const SizedBox(height: 24),
            _buildSlider(
              l10n.buyCrypto,
              _buyCrypto,
              (val) {
                setState(() => _buyCrypto = val);
                _recalculate();
              },
              Colors.green,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(l10n.simulationSaved)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E3192),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(l10n.saveScenario,
                    style:
                        const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimulationCard(BuildContext context, bool isDark, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF2E3192).withValues(alpha: isDark ? 0.4 : 0.8),
            const Color(0xFF1BFFFF).withValues(alpha: isDark ? 0.2 : 0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E3192).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            l10n.projectedROI,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            '${_projectedROI >= 0 ? '+' : ''}${_projectedROI.toStringAsFixed(1)}%',
            style: TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.estimatedImpact,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider(
      String label, double value, ValueChanged<double> onChanged, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text('${value.toInt()}%',
                style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: color,
            thumbColor: color,
            inactiveTrackColor: color.withValues(alpha: 0.2),
            trackHeight: 8.0,
          ),
          child: Slider(
            value: value,
            min: 0,
            max: 100,
            divisions: 20,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
