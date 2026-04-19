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
  double get dailyProfit => 0.0;
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
  final double dailyProfit;
  @override
  final List<Asset> assets;
  @override
  final List<HistoryPoint> netWorthHistory;
  @override
  final TimeRange timeRange;
  final String? operationError;

  const DashboardLoaded({
    required this.totalNetWorth,
    required this.dailyProfit,
    required this.assets,
    required this.netWorthHistory,
    this.timeRange = TimeRange.oneMonth,
    this.operationError,
  });

  DashboardLoaded copyWith({
    double? totalNetWorth,
    double? dailyProfit,
    List<Asset>? assets,
    List<HistoryPoint>? netWorthHistory,
    TimeRange? timeRange,
    String? operationError,
  }) {
    return DashboardLoaded(
      totalNetWorth: totalNetWorth ?? this.totalNetWorth,
      dailyProfit: dailyProfit ?? this.dailyProfit,
      assets: assets ?? this.assets,
      netWorthHistory: netWorthHistory ?? this.netWorthHistory,
      timeRange: timeRange ?? this.timeRange,
      operationError: operationError,
    );
  }

  @override
  List<Object?> get props => [totalNetWorth, dailyProfit, assets, netWorthHistory, timeRange, operationError];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
