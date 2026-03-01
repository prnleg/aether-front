import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<DashboardStarted>(_onDashboardStarted);
    on<RefreshDashboard>(_onDashboardStarted); // Re-use the same logic for now
  }

  Future<void> _onDashboardStarted(
    DashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    try {
      // Mock data fetching
      await Future.delayed(const Duration(seconds: 1));
      
      final assets = [
        {'name': 'Bitcoin Wallet', 'value': 45000.50, 'type': 'Crypto'},
        {'name': 'Steam Inventory (Skins)', 'value': 1250.75, 'type': 'Inventory'},
        {'name': 'LEGO Star Wars Set', 'value': 800.00, 'type': 'Collectible'},
        {'name': 'Vintage Rolex Submariner', 'value': 15000.00, 'type': 'Collectible'},
      ];

      final totalNetWorth = assets.fold<double>(
        0.0, 
        (sum, asset) => sum + (asset['value'] as double)
      );

      emit(DashboardLoaded(
        totalNetWorth: totalNetWorth,
        assets: assets,
      ));
    } catch (e) {
      emit(const DashboardError('Failed to load dashboard data'));
    }
  }
}
