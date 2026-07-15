// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppSettingsImpl _$$AppSettingsImplFromJson(Map<String, dynamic> json) =>
    _$AppSettingsImpl(
      themeMode: json['themeMode'] == null
          ? ThemeMode.system
          : const ThemeModeConverter()
              .fromJson((json['themeMode'] as num).toInt()),
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      language: json['language'] as String? ?? 'en',
      pinEnabled: json['pinEnabled'] as bool? ?? false,
      biometricEnabled: json['biometricEnabled'] as bool? ?? false,
      hideScreenshots: json['hideScreenshots'] as bool? ?? true,
      moodReminders: json['moodReminders'] as bool? ?? true,
    );

Map<String, dynamic> _$$AppSettingsImplToJson(_$AppSettingsImpl instance) =>
    <String, dynamic>{
      'themeMode': const ThemeModeConverter().toJson(instance.themeMode),
      'notificationsEnabled': instance.notificationsEnabled,
      'language': instance.language,
      'pinEnabled': instance.pinEnabled,
      'biometricEnabled': instance.biometricEnabled,
      'hideScreenshots': instance.hideScreenshots,
      'moodReminders': instance.moodReminders,
    };
