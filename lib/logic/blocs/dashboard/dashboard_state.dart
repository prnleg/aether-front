import 'package:equatable/equatable.dart';
import '../../../domain/models/asset_model.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();
  
  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final double totalNetWorth;
  final List<Asset> assets;
  final List<HistoryPoint> netWorthHistory;

  const DashboardLoaded({
    required this.totalNetWorth,
    required this.assets,
    required this.netWorthHistory,
  });

  @override
  List<Object?> get props => [totalNetWorth, assets, netWorthHistory];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
