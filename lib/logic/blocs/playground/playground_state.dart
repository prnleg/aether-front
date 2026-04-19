import 'package:equatable/equatable.dart';

class PlaygroundState extends Equatable {
  final double sellSkinsPercent;
  final double buyCryptoPercent;
  final double projectedROI;
  final bool scenarioSaved;

  const PlaygroundState({
    this.sellSkinsPercent = 0.0,
    this.buyCryptoPercent = 0.0,
    this.projectedROI = 15.4,
    this.scenarioSaved = false,
  });

  PlaygroundState copyWith({
    double? sellSkinsPercent,
    double? buyCryptoPercent,
    double? projectedROI,
    bool? scenarioSaved,
  }) {
    return PlaygroundState(
      sellSkinsPercent: sellSkinsPercent ?? this.sellSkinsPercent,
      buyCryptoPercent: buyCryptoPercent ?? this.buyCryptoPercent,
      projectedROI: projectedROI ?? this.projectedROI,
      scenarioSaved: scenarioSaved ?? this.scenarioSaved,
    );
  }

  @override
  List<Object> get props =>
      [sellSkinsPercent, buyCryptoPercent, projectedROI, scenarioSaved];
}
