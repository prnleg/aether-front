import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SettingsState extends Equatable {
  final ThemeMode themeMode;
  final Locale locale;
  final bool biometricsEnabled;
  final String currency;

  const SettingsState({
    required this.themeMode,
    required this.locale,
    this.biometricsEnabled = false,
    this.currency = 'USD',
  });

  factory SettingsState.initial() {
    return const SettingsState(
      themeMode: ThemeMode.light,
      locale: Locale('en'),
      biometricsEnabled: false,
      currency: 'USD',
    );
  }

  SettingsState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    bool? biometricsEnabled,
    String? currency,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      biometricsEnabled: biometricsEnabled ?? this.biometricsEnabled,
      currency: currency ?? this.currency,
    );
  }

  @override
  List<Object> get props => [themeMode, locale, biometricsEnabled, currency];
}
