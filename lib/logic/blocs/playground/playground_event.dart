import 'package:equatable/equatable.dart';

abstract class PlaygroundEvent extends Equatable {
  const PlaygroundEvent();

  @override
  List<Object> get props => [];
}

class UpdateSellSkinsPercent extends PlaygroundEvent {
  final double percent;
  const UpdateSellSkinsPercent(this.percent);

  @override
  List<Object> get props => [percent];
}

class UpdateBuyCryptoPercent extends PlaygroundEvent {
  final double percent;
  const UpdateBuyCryptoPercent(this.percent);

  @override
  List<Object> get props => [percent];
}

class SaveScenario extends PlaygroundEvent {}
