import '../../domain/models/discovery_item.dart';
import '../../domain/models/sync_result.dart';
import '../../domain/repositories/discovery_repository.dart';
import '../datasources/discovery_remote_data_source.dart';

class DiscoveryRepositoryImpl implements DiscoveryRepository {
  final DiscoveryRemoteDataSource _dataSource;

  DiscoveryRepositoryImpl(this._dataSource);

  @override
  Future<List<DiscoveryItem>> getDiscoveryItems({
    String? status,
    int page = 1,
    int pageSize = 20,
  }) async {
    final dtos = await _dataSource.getDiscoveryItems(
      status: status,
      page: page,
      pageSize: pageSize,
    );
    return dtos.map((e) => e.toDomain()).toList();
  }

  @override
  Future<SyncResult> syncSteamInventory(List<String> appIds) async {
    final dto = await _dataSource.syncSteamInventory(appIds);
    return dto.toDomain();
  }

  @override
  Future<void> approveDiscoveryItem(String id) async {
    await _dataSource.approveDiscoveryItem(id);
  }

  @override
  Future<void> rejectDiscoveryItem(String id) async {
    await _dataSource.rejectDiscoveryItem(id);
  }
}
