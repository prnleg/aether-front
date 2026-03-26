import 'package:equatable/equatable.dart';
import '../../../domain/models/asset_model.dart';

enum TimeRange {
  oneWeek,
  oneMonth,
  threeMonths,
  sixMonths,
  oneYear,
  all,
}

abstract class DashboardState extends Equatable {
  const DashboardState();
  
  @override
  List<Object?> get props => [];

  // Helper getters to simplify access in the UI if needed
  double get totalNetWorth => 0.0;
  List<Asset> get assets => [];
  List<HistoryPoint> get netWorthHistory => [];
  TimeRange get timeRange => TimeRange.oneMonth;
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  @override
  final double totalNetWorth;
  @override
  final List<Asset> assets;
  @override
  final List<HistoryPoint> netWorthHistory;
  @override
  final TimeRange timeRange;

  const DashboardLoaded({
    required this.totalNetWorth,
    required this.assets,
    required this.netWorthHistory,
    this.timeRange = TimeRange.oneMonth,
  });

  DashboardLoaded copyWith({
    double? totalNetWorth,
    List<Asset>? assets,
    List<HistoryPoint>? netWorthHistory,
    TimeRange? timeRange,
  }) {
    return DashboardLoaded(
      totalNetWorth: totalNetWorth ?? this.totalNetWorth,
      assets: assets ?? this.assets,
      netWorthHistory: netWorthHistory ?? this.netWorthHistory,
      timeRange: timeRange ?? this.timeRange,
    );
  }

  @override
  List<Object?> get props => [totalNetWorth, assets, netWorthHistory, timeRange];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
