import '../models/discovery_item.dart';
import '../repositories/discovery_repository.dart';

class GetDiscoveryItemsUseCase {
  final DiscoveryRepository _repository;

  GetDiscoveryItemsUseCase(this._repository);

  Future<List<DiscoveryItem>> execute({
    String? status,
    int page = 1,
    int pageSize = 20,
  }) =>
      _repository.getDiscoveryItems(status: status, page: page, pageSize: pageSize);
}
