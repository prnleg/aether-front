import '../models/sync_result.dart';
import '../repositories/discovery_repository.dart';

class SyncSteamInventoryUseCase {
  final DiscoveryRepository _repository;

  SyncSteamInventoryUseCase(this._repository);

  Future<SyncResult> execute(List<String> appIds) =>
      _repository.syncSteamInventory(appIds);
}
