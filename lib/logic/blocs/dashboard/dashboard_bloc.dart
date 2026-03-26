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
    on<ChangeTimeRange>(_onChangeTimeRange);
    on<AddAsset>(_onAddAsset);
  }

  Future<void> _onDashboardStarted(
    DashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    try {
      final assets = await _assetRepository.getAssets();
      final fullHistory = await _assetRepository.getNetWorthHistory(assets);

      final totalNetWorth = assets.fold<double>(
          0.0, (sum, asset) => sum + asset.value);

      final timeRange = state is DashboardLoaded 
          ? (state as DashboardLoaded).timeRange 
          : TimeRange.oneMonth;

      emit(DashboardLoaded(
        totalNetWorth: totalNetWorth,
        assets: assets,
        netWorthHistory: _getFilteredHistory(fullHistory, timeRange),
        timeRange: timeRange,
      ));
    } catch (e) {
      emit(const DashboardError('Failed to load dashboard data'));
    }
  }

  void _onChangeTimeRange(
    ChangeTimeRange event,
    Emitter<DashboardState> emit,
  ) async {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      
      // In a real app, we might fetch from repo again or repository might have cached it
      // For mock, we'll re-calculate from assets to get full history then filter
      final fullHistory = await _assetRepository.getNetWorthHistory(currentState.assets);
      
      emit(currentState.copyWith(
        timeRange: event.timeRange,
        netWorthHistory: _getFilteredHistory(fullHistory, event.timeRange),
      ));
    }
  }

  List<HistoryPoint> _getFilteredHistory(List<HistoryPoint> fullHistory, TimeRange range) {
    if (fullHistory.isEmpty) return [];
    
    int days;
    switch (range) {
      case TimeRange.oneWeek:
        days = 7;
        break;
      case TimeRange.oneMonth:
        days = 30;
        break;
      case TimeRange.threeMonths:
        days = 90;
        break;
      case TimeRange.sixMonths:
        days = 180;
        break;
      case TimeRange.oneYear:
        days = 365;
        break;
      case TimeRange.all:
        return fullHistory;
    }
    
    if (fullHistory.length <= days) return fullHistory;
    return fullHistory.sublist(fullHistory.length - days);
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
      
      final fullHistory = await _assetRepository.getNetWorthHistory(updatedAssets);

      emit(currentState.copyWith(
        totalNetWorth: newTotalNetWorth,
        assets: updatedAssets,
        netWorthHistory: _getFilteredHistory(fullHistory, currentState.timeRange),
      ));
    }
  }
}
