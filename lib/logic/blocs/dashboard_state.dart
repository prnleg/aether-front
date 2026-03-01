import 'package:equatable/equatable.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();
  
  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final double totalNetWorth;
  final List<Map<String, dynamic>> assets;

  const DashboardLoaded({
    required this.totalNetWorth,
    required this.assets,
  });

  @override
  List<Object> get props => [totalNetWorth, assets];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object> get props => [message];
}
