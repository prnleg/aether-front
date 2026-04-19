import 'package:flutter/material.dart';
import '../repositories/settings_repository.dart';

class GetThemeModeUseCase {
  final SettingsRepository _repository;
  const GetThemeModeUseCase(this._repository);
  ThemeMode execute() => _repository.getThemeMode();
}
