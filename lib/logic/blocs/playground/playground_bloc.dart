import 'package:flutter_bloc/flutter_bloc.dart';
import 'playground_event.dart';
import 'playground_state.dart';

class PlaygroundBloc extends Bloc<PlaygroundEvent, PlaygroundState> {
  PlaygroundBloc() : super(const PlaygroundState()) {
    on<UpdateSellSkinsPercent>(_onUpdateSellSkins);
    on<UpdateBuyCryptoPercent>(_onUpdateBuyCrypto);
    on<SaveScenario>(_onSaveScenario);
  }

  void _onUpdateSellSkins(
    UpdateSellSkinsPercent event,
    Emitter<PlaygroundState> emit,
  ) {
    final roi = _calculateROI(event.percent, state.buyCryptoPercent);
    emit(state.copyWith(
        sellSkinsPercent: event.percent,
        projectedROI: roi,
        scenarioSaved: false));
  }

  void _onUpdateBuyCrypto(
    UpdateBuyCryptoPercent event,
    Emitter<PlaygroundState> emit,
  ) {
    final roi = _calculateROI(state.sellSkinsPercent, event.percent);
    emit(state.copyWith(
        buyCryptoPercent: event.percent,
        projectedROI: roi,
        scenarioSaved: false));
  }

  void _onSaveScenario(
    SaveScenario event,
    Emitter<PlaygroundState> emit,
  ) {
    emit(state.copyWith(scenarioSaved: true));
  }

  // Preserved from the original PlaygroundPage._recalculate()
  double _calculateROI(double sellSkins, double buyCrypto) {
    return 15.4 - (sellSkins * 0.1) + (buyCrypto * 0.2);
  }
}
