import 'package:flutter/material.dart';
import '../repositories/settings_repository.dart';

class GetLocaleUseCase {
  final SettingsRepository _repository;
  const GetLocaleUseCase(this._repository);
  Locale execute() => _repository.getLocale();
}
