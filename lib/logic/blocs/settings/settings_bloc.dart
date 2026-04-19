import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../domain/usecases/get_theme_mode_use_case.dart';
import '../../../domain/usecases/set_theme_mode_use_case.dart';
import '../../../domain/usecases/get_locale_use_case.dart';
import '../../../domain/usecases/set_locale_use_case.dart';
import '../../../domain/usecases/get_biometrics_enabled_use_case.dart';
import '../../../domain/usecases/set_biometrics_enabled_use_case.dart';
import '../../../domain/usecases/get_currency_use_case.dart';
import '../../../domain/usecases/set_currency_use_case.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetThemeModeUseCase _getThemeMode;
  final SetThemeModeUseCase _setThemeMode;
  final GetLocaleUseCase _getLocale;
  final SetLocaleUseCase _setLocale;
  final GetBiometricsEnabledUseCase _getBiometricsEnabled;
  final SetBiometricsEnabledUseCase _setBiometricsEnabled;
  final GetCurrencyUseCase _getCurrency;
  final SetCurrencyUseCase _setCurrency;

  SettingsBloc(
    this._getThemeMode,
    this._setThemeMode,
    this._getLocale,
    this._setLocale,
    this._getBiometricsEnabled,
    this._setBiometricsEnabled,
    this._getCurrency,
    this._setCurrency,
  ) : super(SettingsState.initial()) {
    on<LoadSettings>(_onLoadSettings);
    on<ToggleTheme>(_onToggleTheme);
    on<ChangeLanguage>(_onChangeLanguage);
    on<BiometricToggled>(_onBiometricToggled);
    on<ChangeCurrency>(_onChangeCurrency);
  }

  // Hive reads are synchronous after box init — void handler is intentional.
  void _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) {
    final themeMode = _getThemeMode.execute();
    final locale = _getLocale.execute();
    final biometricsEnabled = _getBiometricsEnabled.execute();
    final currency = _getCurrency.execute();
    emit(state.copyWith(
      themeMode: themeMode,
      locale: locale,
      biometricsEnabled: biometricsEnabled,
      currency: currency,
    ));
  }

  Future<void> _onToggleTheme(
      ToggleTheme event, Emitter<SettingsState> emit) async {
    final newThemeMode =
        state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await _setThemeMode.execute(newThemeMode);
    emit(state.copyWith(themeMode: newThemeMode));
  }

  Future<void> _onChangeLanguage(
      ChangeLanguage event, Emitter<SettingsState> emit) async {
    await _setLocale.execute(event.locale);
    emit(state.copyWith(locale: event.locale));
  }

  Future<void> _onBiometricToggled(
      BiometricToggled event, Emitter<SettingsState> emit) async {
    await _setBiometricsEnabled.execute(event.enabled);
    emit(state.copyWith(biometricsEnabled: event.enabled));
  }

  Future<void> _onChangeCurrency(
      ChangeCurrency event, Emitter<SettingsState> emit) async {
    await _setCurrency.execute(event.currency);
    emit(state.copyWith(currency: event.currency));
  }
}
