import 'package:flutter/material.dart';

abstract class SettingsRepository {
  Future<void> init();
  ThemeMode getThemeMode();
  Locale getLocale();
  String getCurrency();
  Future<void> setThemeMode(ThemeMode themeMode);
  Future<void> setLocale(Locale locale);
  Future<void> setCurrency(String currency);
  bool getBiometricsEnabled();
  Future<void> setBiometricsEnabled(bool enabled);
}
