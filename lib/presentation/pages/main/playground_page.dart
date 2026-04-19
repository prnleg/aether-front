import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aether/l10n/app_localizations.dart';
import '../../../logic/blocs/playground/playground_bloc.dart';
import '../../../logic/blocs/playground/playground_event.dart';
import '../../../logic/blocs/playground/playground_state.dart';

class PlaygroundPage extends StatelessWidget {
  const PlaygroundPage({super.key});

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
      body: BlocConsumer<PlaygroundBloc, PlaygroundState>(
        listener: (context, state) {
          if (state.scenarioSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.simulationSaved)),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.whatIfSimulator,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.simulatorDesc,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 32),
                _buildSimulationCard(context, isDark, l10n, state.projectedROI),
                const SizedBox(height: 32),
                Text(
                  l10n.scenarioParameters,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildSlider(
                  context,
                  l10n.sellSkins,
                  state.sellSkinsPercent,
                  (val) => context
                      .read<PlaygroundBloc>()
                      .add(UpdateSellSkinsPercent(val)),
                  Colors.red,
                ),
                const SizedBox(height: 24),
                _buildSlider(
                  context,
                  l10n.buyCrypto,
                  state.buyCryptoPercent,
                  (val) => context
                      .read<PlaygroundBloc>()
                      .add(UpdateBuyCryptoPercent(val)),
                  Colors.green,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () =>
                        context.read<PlaygroundBloc>().add(SaveScenario()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E3192),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(l10n.saveScenario,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSimulationCard(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
    double projectedROI,
  ) {
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
            '${projectedROI >= 0 ? '+' : ''}${projectedROI.toStringAsFixed(1)}%',
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
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider(
    BuildContext context,
    String label,
    double value,
    ValueChanged<double> onChanged,
    Color color,
  ) {
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
