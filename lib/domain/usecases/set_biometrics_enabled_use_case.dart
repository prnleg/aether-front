import '../repositories/settings_repository.dart';

class SetBiometricsEnabledUseCase {
  final SettingsRepository _repository;
  const SetBiometricsEnabledUseCase(this._repository);
  Future<void> execute(bool enabled) => _repository.setBiometricsEnabled(enabled);
}
