import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_market_assets_use_case.dart';
import 'discovery_event.dart';
import 'discovery_state.dart';

class DiscoveryBloc extends Bloc<DiscoveryEvent, DiscoveryState> {
  final GetMarketAssetsUseCase _getMarketAssets;

  DiscoveryBloc({required GetMarketAssetsUseCase getMarketAssets})
      : _getMarketAssets = getMarketAssets,
        super(const DiscoveryState()) {
    on<FetchDiscoveryAssets>(_onFetchDiscoveryAssets);
    on<SearchDiscoveryAssets>(_onSearchDiscoveryAssets);
  }

  Future<void> _onFetchDiscoveryAssets(
    FetchDiscoveryAssets event,
    Emitter<DiscoveryState> emit,
  ) async {
    emit(state.copyWith(status: DiscoveryStatus.loading));
    try {
      final assets = await _getMarketAssets.execute();
      emit(state.copyWith(
        status: DiscoveryStatus.success,
        assets: assets,
        filteredAssets: assets,
      ));
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(status: DiscoveryStatus.failure));
    }
  }

  void _onSearchDiscoveryAssets(
    SearchDiscoveryAssets event,
    Emitter<DiscoveryState> emit,
  ) {
    final filteredAssets = state.assets.where((asset) {
      return asset.name.toLowerCase().contains(event.query.toLowerCase());
    }).toList();

    emit(state.copyWith(
      searchQuery: event.query,
      filteredAssets: filteredAssets,
    ));
  }
}
