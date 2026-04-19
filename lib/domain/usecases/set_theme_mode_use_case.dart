import 'package:flutter/material.dart';
import '../repositories/settings_repository.dart';

class SetThemeModeUseCase {
  final SettingsRepository _repository;
  const SetThemeModeUseCase(this._repository);
  Future<void> execute(ThemeMode mode) => _repository.setThemeMode(mode);
}
