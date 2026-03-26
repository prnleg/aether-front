import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../domain/repositories/settings_repository.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository _settingsRepository;

  SettingsBloc(this._settingsRepository) : super(SettingsState.initial()) {
    on<LoadSettings>(_onLoadSettings);
    on<ToggleTheme>(_onToggleTheme);
    on<ChangeLanguage>(_onChangeLanguage);
  }

  void _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) {
    final themeMode = _settingsRepository.getThemeMode();
    final locale = _settingsRepository.getLocale();
    emit(state.copyWith(themeMode: themeMode, locale: locale));
  }

  Future<void> _onToggleTheme(ToggleTheme event, Emitter<SettingsState> emit) async {
    final newThemeMode = state.themeMode == ThemeMode.light 
        ? ThemeMode.dark 
        : ThemeMode.light;
    await _settingsRepository.setThemeMode(newThemeMode);
    emit(state.copyWith(themeMode: newThemeMode));
  }

  Future<void> _onChangeLanguage(ChangeLanguage event, Emitter<SettingsState> emit) async {
    await _settingsRepository.setLocale(event.locale);
    emit(state.copyWith(locale: event.locale));
  }
}
