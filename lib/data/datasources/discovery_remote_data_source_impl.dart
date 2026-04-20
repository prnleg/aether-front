import '../../core/network/api_client.dart';
import '../models/discovery_item_dto.dart';
import '../models/sync_result_dto.dart';
import 'discovery_remote_data_source.dart';

class DiscoveryRemoteDataSourceImpl implements DiscoveryRemoteDataSource {
  final ApiClient _api;

  DiscoveryRemoteDataSourceImpl(this._api);

  @override
  Future<List<DiscoveryItemDto>> getDiscoveryItems({
    String? status,
    int page = 1,
    int pageSize = 20,
  }) async {
    final query = <String, dynamic>{
      'page': page,
      'pageSize': pageSize,
    };
    if (status != null) query['status'] = status;

    final response = await _api.get('/api/discovery', queryParameters: query);
    final data = response.data;
    final list = data is List ? data : (data['items'] ?? data['data'] ?? []) as List;
    return list
        .map((e) => DiscoveryItemDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<SyncResultDto> syncSteamInventory(List<String> appIds) async {
    final response = await _api.postWithTimeout(
      '/api/discovery/sync',
      data: {'appIds': appIds},
      receiveTimeout: const Duration(seconds: 120),
    );
    return SyncResultDto.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> approveDiscoveryItem(String id) async {
    await _api.post('/api/discovery/$id/approve');
  }

  @override
  Future<void> rejectDiscoveryItem(String id) async {
    await _api.post('/api/discovery/$id/reject');
  }
}
