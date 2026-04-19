import '../repositories/settings_repository.dart';

class SetCurrencyUseCase {
  final SettingsRepository _repository;
  const SetCurrencyUseCase(this._repository);
  Future<void> execute(String currency) => _repository.setCurrency(currency);
}
