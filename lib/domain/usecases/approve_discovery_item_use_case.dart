import '../repositories/discovery_repository.dart';

class ApproveDiscoveryItemUseCase {
  final DiscoveryRepository _repository;

  ApproveDiscoveryItemUseCase(this._repository);

  Future<void> execute(String id) => _repository.approveDiscoveryItem(id);
}
