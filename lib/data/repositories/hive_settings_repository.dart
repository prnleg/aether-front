import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/repositories/settings_repository.dart';

class HiveSettingsRepository implements SettingsRepository {
  static const String _boxName = 'settings';
  static const String _themeKey = 'themeMode';
  static const String _localeKey = 'locale';
  static const String _biometricsKey = 'biometricsEnabled';
  late Box _box;

  @override
  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  @override
  ThemeMode getThemeMode() {
    final String? themeName = _box.get(_themeKey);
    if (themeName == null) return ThemeMode.light;
    return ThemeMode.values.firstWhere(
      (e) => e.name == themeName,
      orElse: () => ThemeMode.light,
    );
  }

  @override
  Locale getLocale() {
    final String? localeCode = _box.get(_localeKey);
    if (localeCode == null) return const Locale('en');
    return Locale(localeCode);
  }

  @override
  Future<void> setThemeMode(ThemeMode themeMode) async {
    await _box.put(_themeKey, themeMode.name);
  }

  @override
  Future<void> setLocale(Locale locale) async {
    await _box.put(_localeKey, locale.languageCode);
  }

  @override
  bool getBiometricsEnabled() {
    return _box.get(_biometricsKey, defaultValue: false) as bool;
  }

  @override
  Future<void> setBiometricsEnabled(bool enabled) async {
    await _box.put(_biometricsKey, enabled);
  }
}
