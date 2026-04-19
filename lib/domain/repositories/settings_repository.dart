import 'package:flutter/material.dart';

abstract class SettingsRepository {
  Future<void> init();
  ThemeMode getThemeMode();
  Locale getLocale();
  Future<void> setThemeMode(ThemeMode themeMode);
  Future<void> setLocale(Locale locale);
  bool getBiometricsEnabled();
  Future<void> setBiometricsEnabled(bool enabled);
}
