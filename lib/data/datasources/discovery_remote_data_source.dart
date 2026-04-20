import '../models/discovery_item_dto.dart';
import '../models/sync_result_dto.dart';

abstract class DiscoveryRemoteDataSource {
  Future<List<DiscoveryItemDto>> getDiscoveryItems({
    String? status,
    int page = 1,
    int pageSize = 20,
  });

  Future<SyncResultDto> syncSteamInventory(List<String> appIds);

  Future<void> approveDiscoveryItem(String id);

  Future<void> rejectDiscoveryItem(String id);
}
