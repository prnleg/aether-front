import '../repositories/settings_repository.dart';

class GetCurrencyUseCase {
  final SettingsRepository _repository;
  const GetCurrencyUseCase(this._repository);
  String execute() => _repository.getCurrency();
}
