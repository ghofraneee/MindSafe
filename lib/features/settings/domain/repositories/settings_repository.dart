import 'package:mindsafe/features/settings/domain/entities/app_settings.dart';

abstract class SettingsRepository {
  Future<AppSettings> getSettings();

  Future<void> saveSettings(AppSettings settings);

  Future<bool> hasPin();

  Future<void> setPin(String pin);

  Future<bool> verifyPin(String pin);

  Future<void> clearPin();

  Future<String> exportData();

  Future<void> resetApp();
}
