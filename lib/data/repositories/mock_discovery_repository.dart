// Kept for reference only — no longer registered in service_locator.dart.
// Implements the DiscoveryRepository interface with empty stubs.
import '../../domain/models/discovery_item.dart';
import '../../domain/models/sync_result.dart';
import '../../domain/repositories/discovery_repository.dart';

class MockDiscoveryRepository implements DiscoveryRepository {
  @override
  Future<List<DiscoveryItem>> getDiscoveryItems({
    String? status,
    int page = 1,
    int pageSize = 20,
  }) async =>
      [];

  @override
  Future<SyncResult> syncSteamInventory(List<String> appIds) async =>
      const SyncResult(added: 0, updated: 0, skipped: 0);

  @override
  Future<void> approveDiscoveryItem(String id) async {}

  @override
  Future<void> rejectDiscoveryItem(String id) async {}
}
