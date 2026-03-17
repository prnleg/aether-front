import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';
import '../../data/models/asset_model.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
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
      // Mock data fetching
      await Future.delayed(const Duration(milliseconds: 800));
      
      final now = DateTime.now();
      
      // Helper to generate mock history
      List<HistoryPoint> generateHistory(double startValue, int days, double volatility) {
        final List<HistoryPoint> history = [];
        double currentValue = startValue;
        for (int i = days; i >= 0; i--) {
          final date = now.subtract(Duration(days: i));
          // Simple random walk
          currentValue = currentValue * (1 + (volatility * (0.5 - (1.0 * (i % 7) / 7))));
          history.add(HistoryPoint(date: date, value: currentValue));
        }
        return history;
      }

      final assets = [
        Asset(
          id: '1',
          name: 'Bitcoin',
          value: 45000.50,
          type: AssetType.crypto,
          change24h: 2.5,
          history: generateHistory(40000, 30, 0.05),
        ),
        Asset(
          id: '2',
          name: 'Ethereum',
          value: 2400.20,
          type: AssetType.crypto,
          change24h: -1.2,
          history: generateHistory(2500, 30, 0.04),
        ),
        Asset(
          id: '3',
          name: 'Steam Inventory',
          value: 1250.75,
          type: AssetType.inventory,
          change24h: 0.5,
          history: generateHistory(1200, 30, 0.01),
        ),
        Asset(
          id: '4',
          name: 'LEGO Star Wars Set',
          value: 800.00,
          type: AssetType.collectible,
          change24h: 0.0,
          history: generateHistory(800, 30, 0.005),
        ),
        Asset(
          id: '5',
          name: 'Vintage Rolex',
          value: 15000.00,
          type: AssetType.collectible,
          change24h: 5.0,
          history: generateHistory(14000, 30, 0.02),
        ),
        Asset(
          id: '6',
          name: 'S&P 500 Index',
          value: 12000.00,
          type: AssetType.stock,
          change24h: 0.8,
          history: generateHistory(11500, 30, 0.015),
        ),
      ];

      final totalNetWorth = assets.fold<double>(
        0.0, 
        (sum, asset) => sum + asset.value
      );

      // Generate net worth history based on summed asset histories
      final List<HistoryPoint> netWorthHistory = [];
      for (int i = 0; i <= 30; i++) {
        double dailySum = 0;
        for (var asset in assets) {
          if (i < asset.history.length) {
            dailySum += asset.history[i].value;
          }
        }
        netWorthHistory.add(HistoryPoint(
          date: now.subtract(Duration(days: 30 - i)),
          value: dailySum,
        ));
      }

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

      final updatedAssets = List<Asset>.from(currentState.assets)..add(newAsset);
      final newTotalNetWorth = updatedAssets.fold<double>(0, (sum, item) => sum + item.value);

      emit(DashboardLoaded(
        totalNetWorth: newTotalNetWorth,
        assets: updatedAssets,
        netWorthHistory: currentState.netWorthHistory, // Ideally recalculate this too
      ));
    }
  }
}
