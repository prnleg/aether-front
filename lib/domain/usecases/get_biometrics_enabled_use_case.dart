import '../repositories/settings_repository.dart';

class GetBiometricsEnabledUseCase {
  final SettingsRepository _repository;
  const GetBiometricsEnabledUseCase(this._repository);
  bool execute() => _repository.getBiometricsEnabled();
}
