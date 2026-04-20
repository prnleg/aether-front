import 'package:equatable/equatable.dart';
import '../../../domain/models/discovery_item.dart';
import '../../../domain/models/sync_result.dart';

enum DiscoveryStatus { initial, loading, success, failure }

class DiscoveryState extends Equatable {
  final DiscoveryStatus status;
  final List<DiscoveryItem> items;
  final String? activeFilter;
  final bool isSyncing;
  final bool isBulkRejecting;
  final SyncResult? syncResult;
  final String? approvingId;
  final String? rejectingId;
  final String? error;

  const DiscoveryState({
    this.status = DiscoveryStatus.initial,
    this.items = const [],
    this.activeFilter = 'PendingApproval',
    this.isSyncing = false,
    this.isBulkRejecting = false,
    this.syncResult,
    this.approvingId,
    this.rejectingId,
    this.error,
  });

  DiscoveryState copyWith({
    DiscoveryStatus? status,
    List<DiscoveryItem>? items,
    String? activeFilter,
    bool? isSyncing,
    bool? isBulkRejecting,
    SyncResult? syncResult,
    String? approvingId,
    String? rejectingId,
    String? error,
    bool clearSyncResult = false,
    bool clearApprovingId = false,
    bool clearRejectingId = false,
    bool clearError = false,
  }) {
    return DiscoveryState(
      status: status ?? this.status,
      items: items ?? this.items,
      activeFilter: activeFilter ?? this.activeFilter,
      isSyncing: isSyncing ?? this.isSyncing,
      isBulkRejecting: isBulkRejecting ?? this.isBulkRejecting,
      syncResult: clearSyncResult ? null : (syncResult ?? this.syncResult),
      approvingId: clearApprovingId ? null : (approvingId ?? this.approvingId),
      rejectingId: clearRejectingId ? null : (rejectingId ?? this.rejectingId),
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
        activeFilter,
        isSyncing,
        isBulkRejecting,
        syncResult,
        approvingId,
        rejectingId,
        error,
      ];
}
