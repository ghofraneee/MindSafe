import 'dart:convert';

import 'package:mindsafe/core/constants/app_constants.dart';
import 'package:mindsafe/core/services/privacy_service.dart';
import 'package:mindsafe/core/services/storage_service.dart';
import 'package:mindsafe/features/settings/domain/entities/app_settings.dart';
import 'package:mindsafe/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl({
    required StorageService storageService,
    PrivacyService? privacyService,
  })  : _storage = storageService,
        _privacy = privacyService ?? PrivacyService();

  final StorageService _storage;
  final PrivacyService _privacy;
  static const _settingsKey = 'app_settings';
  static const _journalKey = 'journal_entries';

  @override
  Future<AppSettings> getSettings() async {
    final raw = _storage.settingsBox.get(_settingsKey);
    if (raw is! Map) return const AppSettings();
    return AppSettings.fromJson(Map<String, dynamic>.from(raw));
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    await _storage.settingsBox.put(_settingsKey, settings.toJson());
    await _privacy.blockScreenshots(settings.hideScreenshots);
  }

  @override
  Future<bool> hasPin() async {
    final hash = await _storage.readSecure(AppConstants.pinHashKey);
    return hash != null && hash.isNotEmpty;
  }

  @override
  Future<void> setPin(String pin) async {
    final salt = PasswordHasher.generateSalt();
    final hash = PasswordHasher.hash(pin, salt);
    await _storage.writeSecure(AppConstants.pinHashKey, hash);
    await _storage.writeSecure(AppConstants.pinSaltKey, salt);
  }

  @override
  Future<bool> verifyPin(String pin) async {
    final hash = await _storage.readSecure(AppConstants.pinHashKey);
    final salt = await _storage.readSecure(AppConstants.pinSaltKey);
    if (hash == null || salt == null) return false;
    return PasswordHasher.hash(pin, salt) == hash;
  }

  @override
  Future<void> clearPin() async {
    await _storage.deleteSecure(AppConstants.pinHashKey);
    await _storage.deleteSecure(AppConstants.pinSaltKey);
  }

  @override
  Future<String> exportData() async {
    final moods = _storage.moodBox.get('mood_entries') ?? [];
    final journals = _storage.journalBox.get(_journalKey) ?? [];
    final settings = _storage.settingsBox.get(_settingsKey) ?? {};

    final payload = {
      'exportedAt': DateTime.now().toIso8601String(),
      'appVersion': AppConstants.appVersion,
      'moods': moods,
      'journals': journals,
      'settings': settings,
    };
    return const JsonEncoder.withIndent('  ').convert(payload);
  }

  @override
  Future<void> resetApp() async {
    await _storage.wipeAll();
  }
}
