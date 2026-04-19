import '../repositories/asset_repository.dart';

class DeleteAssetUseCase {
  final AssetRepository _repository;
  const DeleteAssetUseCase(this._repository);

  Future<void> execute(String assetId) => _repository.deleteAsset(assetId);
}
