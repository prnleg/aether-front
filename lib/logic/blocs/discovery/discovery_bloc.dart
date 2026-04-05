import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/discovery_repository.dart';
import 'discovery_event.dart';
import 'discovery_state.dart';

class DiscoveryBloc extends Bloc<DiscoveryEvent, DiscoveryState> {
  final DiscoveryRepository _repository;

  DiscoveryBloc({required DiscoveryRepository repository})
      : _repository = repository,
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
      final assets = await _repository.getMarketAssets();
      emit(state.copyWith(
        status: DiscoveryStatus.success,
        assets: assets,
        filteredAssets: assets,
      ));
    } catch (_) {
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
