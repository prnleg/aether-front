import '../models/discovery_item.dart';
import '../models/sync_result.dart';

abstract class DiscoveryRepository {
  Future<List<DiscoveryItem>> getDiscoveryItems({
    String? status,
    int page = 1,
    int pageSize = 20,
  });

  Future<SyncResult> syncSteamInventory(List<String> appIds);

  Future<void> approveDiscoveryItem(String id);

  Future<void> rejectDiscoveryItem(String id);
}
