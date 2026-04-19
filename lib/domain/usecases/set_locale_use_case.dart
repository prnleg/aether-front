import 'package:flutter/material.dart';
import '../repositories/settings_repository.dart';

class SetLocaleUseCase {
  final SettingsRepository _repository;
  const SetLocaleUseCase(this._repository);
  Future<void> execute(Locale locale) => _repository.setLocale(locale);
}
