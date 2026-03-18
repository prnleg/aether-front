import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';
import '../../../domain/models/asset_model.dart';
import '../../../domain/repositories/asset_repository.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final AssetRepository _assetRepository;

  DashboardBloc(this._assetRepository) : super(DashboardInitial()) {
    on<DashboardStarted>(_onDashboardStarted);
    on<RefreshDashboard>(_onDashboardStarted);
    on<AddAsset>(_onAddAsset);
  }

  Future<void> _onDashboardStarted(
    DashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    try {
      final assets = await _assetRepository.getAssets();
      final netWorthHistory = await _assetRepository.getNetWorthHistory(assets);

      final totalNetWorth = assets.fold<double>(
          0.0, (sum, asset) => sum + asset.value);

      emit(DashboardLoaded(
        totalNetWorth: totalNetWorth,
        assets: assets,
        netWorthHistory: netWorthHistory,
      ));
    } catch (e) {
      emit(const DashboardError('Failed to load dashboard data'));
    }
  }

  Future<void> _onAddAsset(
    AddAsset event,
    Emitter<DashboardState> emit,
  ) async {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      final newAsset = Asset(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: event.name,
        value: event.initialValue,
        type: event.type,
        change24h: 0.0,
        history: [
          HistoryPoint(date: DateTime.now(), value: event.initialValue),
        ],
      );

      await _assetRepository.addAsset(newAsset);

      final updatedAssets = List<Asset>.from(currentState.assets)..add(newAsset);
      final newTotalNetWorth = updatedAssets.fold<double>(0, (sum, item) => sum + item.value);

      emit(DashboardLoaded(
        totalNetWorth: newTotalNetWorth,
        assets: updatedAssets,
        netWorthHistory: currentState.netWorthHistory,
      ));
    }
  }
}
