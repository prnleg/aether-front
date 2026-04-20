import '../repositories/discovery_repository.dart';

class RejectDiscoveryItemUseCase {
  final DiscoveryRepository _repository;

  RejectDiscoveryItemUseCase(this._repository);

  Future<void> execute(String id) => _repository.rejectDiscoveryItem(id);
}
