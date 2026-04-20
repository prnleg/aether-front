import '../repositories/user_repository.dart';

class UpdateSteamIdUseCase {
  final UserRepository _repository;

  UpdateSteamIdUseCase(this._repository);

  Future<void> execute(String steamId) => _repository.updateSteamId(steamId);
}
