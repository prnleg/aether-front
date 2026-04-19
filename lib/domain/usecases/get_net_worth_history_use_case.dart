import '../models/asset_model.dart';
import '../repositories/asset_repository.dart';

class GetNetWorthHistoryUseCase {
  final AssetRepository _repository;
  const GetNetWorthHistoryUseCase(this._repository);
  Future<List<HistoryPoint>> execute(List<Asset> assets) =>
      _repository.getNetWorthHistory(assets);
}
