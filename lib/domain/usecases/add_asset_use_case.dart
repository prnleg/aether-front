import '../models/asset_model.dart';
import '../repositories/asset_repository.dart';

class AddAssetUseCase {
  final AssetRepository _repository;
  const AddAssetUseCase(this._repository);
  Future<void> execute(Asset asset) => _repository.addAsset(asset);
}
