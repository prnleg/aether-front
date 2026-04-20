import 'package:equatable/equatable.dart';

abstract class DiscoveryEvent extends Equatable {
  const DiscoveryEvent();

  @override
  List<Object?> get props => [];
}

class LoadDiscoveryItems extends DiscoveryEvent {
  final String? status;

  const LoadDiscoveryItems({this.status = 'PendingApproval'});

  @override
  List<Object?> get props => [status];
}

class RefreshDiscoveryItems extends DiscoveryEvent {}

class FilterDiscoveryItems extends DiscoveryEvent {
  final String? status;

  const FilterDiscoveryItems(this.status);

  @override
  List<Object?> get props => [status];
}

class SyncSteamInventory extends DiscoveryEvent {
  final List<String> appIds;

  const SyncSteamInventory(this.appIds);

  @override
  List<Object?> get props => [appIds];
}

class ApproveDiscoveryItem extends DiscoveryEvent {
  final String id;

  const ApproveDiscoveryItem(this.id);

  @override
  List<Object?> get props => [id];
}

class RejectDiscoveryItem extends DiscoveryEvent {
  final String id;

  const RejectDiscoveryItem(this.id);

  @override
  List<Object?> get props => [id];
}

class BulkRejectBelowPrice extends DiscoveryEvent {
  final double maxPrice;

  const BulkRejectBelowPrice(this.maxPrice);

  @override
  List<Object?> get props => [maxPrice];
}
