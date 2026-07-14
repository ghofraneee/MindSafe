import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:mindsafe/core/utils/theme_mode_converter.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

/// Persisted app preferences and privacy toggles.
@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    @ThemeModeConverter() @Default(ThemeMode.system) ThemeMode themeMode,
    @Default(true) bool notificationsEnabled,
    @Default('en') String language,
    @Default(false) bool pinEnabled,
    @Default(false) bool biometricEnabled,
    @Default(true) bool hideScreenshots,
    @Default(true) bool moodReminders,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);
}
