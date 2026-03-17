import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsState.initial()) {
    on<ToggleTheme>(_onToggleTheme);
    on<ChangeLanguage>(_onChangeLanguage);
  }

  void _onToggleTheme(ToggleTheme event, Emitter<SettingsState> emit) {
    final newThemeMode = state.themeMode == ThemeMode.light 
        ? ThemeMode.dark 
        : ThemeMode.light;
    emit(state.copyWith(themeMode: newThemeMode));
  }

  void _onChangeLanguage(ChangeLanguage event, Emitter<SettingsState> emit) {
    emit(state.copyWith(locale: event.locale));
  }
}
