import '../models/asset_model.dart';
import '../repositories/asset_repository.dart';

class GetAssetsUseCase {
  final AssetRepository _repository;
  const GetAssetsUseCase(this._repository);
  Future<List<Asset>> execute() => _repository.getAssets();
}
