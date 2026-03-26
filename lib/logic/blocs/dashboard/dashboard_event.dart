import 'package:equatable/equatable.dart';
import '../../../domain/models/asset_model.dart';
import 'dashboard_state.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class DashboardStarted extends DashboardEvent {}

class RefreshDashboard extends DashboardEvent {}

class ChangeTimeRange extends DashboardEvent {
  final TimeRange timeRange;

  const ChangeTimeRange(this.timeRange);

  @override
  List<Object> get props => [timeRange];
}

class AddAsset extends DashboardEvent {
  final String name;
  final AssetType type;
  final double initialValue;

  const AddAsset({
    required this.name,
    required this.type,
    required this.initialValue,
  });

  @override
  List<Object> get props => [name, type, initialValue];
}
