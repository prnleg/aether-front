import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class ToggleTheme extends SettingsEvent {}

class ChangeLanguage extends SettingsEvent {
  final Locale locale;

  const ChangeLanguage(this.locale);

  @override
  List<Object> get props => [locale];
}

class LoadSettings extends SettingsEvent {}

class BiometricToggled extends SettingsEvent {
  final bool enabled;
  const BiometricToggled(this.enabled);

  @override
  List<Object> get props => [enabled];
}

class ChangeCurrency extends SettingsEvent {
  final String currency;
  const ChangeCurrency(this.currency);

  @override
  List<Object> get props => [currency];
}
