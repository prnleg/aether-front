import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_discovery_items_use_case.dart';
import '../../../domain/usecases/sync_steam_inventory_use_case.dart';
import '../../../domain/usecases/approve_discovery_item_use_case.dart';
import '../../../domain/usecases/reject_discovery_item_use_case.dart';
import 'discovery_event.dart';
import 'discovery_state.dart';

class DiscoveryBloc extends Bloc<DiscoveryEvent, DiscoveryState> {
  final GetDiscoveryItemsUseCase _getItems;
  final SyncSteamInventoryUseCase _sync;
  final ApproveDiscoveryItemUseCase _approve;
  final RejectDiscoveryItemUseCase _reject;

  DiscoveryBloc({
    required GetDiscoveryItemsUseCase getItems,
    required SyncSteamInventoryUseCase sync,
    required ApproveDiscoveryItemUseCase approve,
    required RejectDiscoveryItemUseCase reject,
  })  : _getItems = getItems,
        _sync = sync,
        _approve = approve,
        _reject = reject,
        super(const DiscoveryState()) {
    on<LoadDiscoveryItems>(_onLoad);
    on<RefreshDiscoveryItems>(_onRefresh);
    on<FilterDiscoveryItems>(_onFilter);
    on<SyncSteamInventory>(_onSync);
    on<ApproveDiscoveryItem>(_onApprove);
    on<RejectDiscoveryItem>(_onReject);
    on<BulkRejectBelowPrice>(_onBulkReject);
  }

  Future<void> _onLoad(
    LoadDiscoveryItems event,
    Emitter<DiscoveryState> emit,
  ) async {
    emit(state.copyWith(status: DiscoveryStatus.loading, activeFilter: event.status));
    try {
      final items = await _getItems.execute(status: event.status);
      emit(state.copyWith(status: DiscoveryStatus.success, items: items));
    } catch (e) {
      debugPrint('DiscoveryBloc._onLoad: $e');
      emit(state.copyWith(status: DiscoveryStatus.failure, error: e.toString()));
    }
  }

  Future<void> _onRefresh(
    RefreshDiscoveryItems event,
    Emitter<DiscoveryState> emit,
  ) async {
    emit(state.copyWith(status: DiscoveryStatus.loading));
    try {
      final items = await _getItems.execute(status: state.activeFilter);
      emit(state.copyWith(status: DiscoveryStatus.success, items: items));
    } catch (e) {
      debugPrint('DiscoveryBloc._onRefresh: $e');
      emit(state.copyWith(status: DiscoveryStatus.failure, error: e.toString()));
    }
  }

  Future<void> _onFilter(
    FilterDiscoveryItems event,
    Emitter<DiscoveryState> emit,
  ) async {
    emit(state.copyWith(
      status: DiscoveryStatus.loading,
      activeFilter: event.status,
    ));
    try {
      final items = await _getItems.execute(status: event.status);
      emit(state.copyWith(status: DiscoveryStatus.success, items: items));
    } catch (e) {
      debugPrint('DiscoveryBloc._onFilter: $e');
      emit(state.copyWith(status: DiscoveryStatus.failure, error: e.toString()));
    }
  }

  Future<void> _onSync(
    SyncSteamInventory event,
    Emitter<DiscoveryState> emit,
  ) async {
    emit(state.copyWith(isSyncing: true, clearSyncResult: true));
    try {
      final result = await _sync.execute(event.appIds);
      emit(state.copyWith(isSyncing: false, syncResult: result));
      // Reload current filter after sync to show new items.
      final items = await _getItems.execute(status: state.activeFilter);
      emit(state.copyWith(status: DiscoveryStatus.success, items: items));
    } catch (e) {
      debugPrint('DiscoveryBloc._onSync: $e');
      emit(state.copyWith(isSyncing: false, error: e.toString()));
    }
  }

  Future<void> _onApprove(
    ApproveDiscoveryItem event,
    Emitter<DiscoveryState> emit,
  ) async {
    emit(state.copyWith(approvingId: event.id));
    try {
      await _approve.execute(event.id);
      // Remove immediately for instant feedback, then reload from backend
      // to refill any paginated items that weren't loaded yet.
      final optimistic = state.items.where((i) => i.id != event.id).toList();
      emit(state.copyWith(items: optimistic, clearApprovingId: true));
      await _reloadSilently(emit);
    } catch (e) {
      debugPrint('DiscoveryBloc._onApprove: $e');
      emit(state.copyWith(clearApprovingId: true, error: e.toString()));
    }
  }

  Future<void> _onReject(
    RejectDiscoveryItem event,
    Emitter<DiscoveryState> emit,
  ) async {
    emit(state.copyWith(rejectingId: event.id));
    try {
      await _reject.execute(event.id);
      // Remove immediately for instant feedback, then reload from backend.
      final optimistic = state.items.where((i) => i.id != event.id).toList();
      emit(state.copyWith(items: optimistic, clearRejectingId: true));
      await _reloadSilently(emit);
    } catch (e) {
      debugPrint('DiscoveryBloc._onReject: $e');
      emit(state.copyWith(clearRejectingId: true, error: e.toString()));
    }
  }

  Future<void> _onBulkReject(
    BulkRejectBelowPrice event,
    Emitter<DiscoveryState> emit,
  ) async {
    final targets = state.items
        .where((i) =>
            i.marketPriceAmount != null && i.marketPriceAmount! <= event.maxPrice)
        .toList();
    if (targets.isEmpty) return;

    emit(state.copyWith(isBulkRejecting: true));
    try {
      // Fire all rejects concurrently.
      await Future.wait(targets.map((i) => _reject.execute(i.id)));
      emit(state.copyWith(isBulkRejecting: false));
      // Full reload to get fresh server data.
      final items = await _getItems.execute(status: state.activeFilter);
      emit(state.copyWith(status: DiscoveryStatus.success, items: items));
    } catch (e) {
      debugPrint('DiscoveryBloc._onBulkReject: $e');
      emit(state.copyWith(isBulkRejecting: false, error: e.toString()));
      await _reloadSilently(emit);
    }
  }

  /// Fetches fresh items without showing the full loading skeleton.
  /// Used after single approve/reject to refill paginated results silently.
  Future<void> _reloadSilently(Emitter<DiscoveryState> emit) async {
    try {
      final items = await _getItems.execute(status: state.activeFilter);
      emit(state.copyWith(status: DiscoveryStatus.success, items: items));
    } catch (e) {
      debugPrint('DiscoveryBloc._reloadSilently: $e');
      // Silent fail — current list stays visible; user can pull-to-refresh.
    }
  }
}
