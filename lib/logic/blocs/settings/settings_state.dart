import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SettingsState extends Equatable {
  final ThemeMode themeMode;
  final Locale locale;
  final bool biometricsEnabled;

  const SettingsState({
    required this.themeMode,
    required this.locale,
    this.biometricsEnabled = false,
  });

  factory SettingsState.initial() {
    return const SettingsState(
      themeMode: ThemeMode.light,
      locale: Locale('en'),
      biometricsEnabled: false,
    );
  }

  SettingsState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    bool? biometricsEnabled,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      biometricsEnabled: biometricsEnabled ?? this.biometricsEnabled,
    );
  }

  @override
  List<Object> get props => [themeMode, locale, biometricsEnabled];
}
