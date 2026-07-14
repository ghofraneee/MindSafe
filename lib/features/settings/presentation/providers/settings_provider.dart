import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mindsafe/core/providers/core_providers.dart';
import 'package:mindsafe/core/services/reminder_service.dart';
import 'package:mindsafe/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:mindsafe/features/settings/domain/entities/app_settings.dart';
import 'package:mindsafe/features/settings/domain/repositories/settings_repository.dart';

final reminderServiceProvider = Provider<ReminderService>((ref) {
  return ReminderService();
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl(
    storageService: ref.watch(storageServiceProvider),
    privacyService: ref.watch(privacyServiceProvider),
  );
});

class SettingsNotifier extends StateNotifier<AsyncValue<AppSettings>> {
  SettingsNotifier(this._repository, this._reminders)
      : super(const AsyncValue.loading()) {
    _load();
  }

  final SettingsRepository _repository;
  final ReminderService _reminders;

  Future<void> _load() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_repository.getSettings);
    final settings = state.valueOrNull;
    if (settings != null) {
      await _reminders.setEnabled(settings.moodReminders);
    }
  }

  Future<void> update(AppSettings settings) async {
    final previous = state.valueOrNull ?? const AppSettings();
    state = AsyncValue.data(settings);
    try {
      await _repository.saveSettings(settings);
      await _reminders.setEnabled(settings.moodReminders);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      state = AsyncValue.data(previous);
    }
  }

  Future<void> toggleDarkMode(bool isDark) async {
    final current = state.valueOrNull ?? const AppSettings();
    await update(
      current.copyWith(
        themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      ),
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final current = state.valueOrNull ?? const AppSettings();
    await update(current.copyWith(themeMode: mode));
  }

  Future<String> exportData() => _repository.exportData();

  Future<void> resetApp() async {
    await _repository.resetApp();
    state = const AsyncValue.data(AppSettings());
  }

  Future<bool> setPin(String pin) async {
    await _repository.setPin(pin);
    final current = state.valueOrNull ?? const AppSettings();
    await update(current.copyWith(pinEnabled: true));
    return true;
  }

  Future<bool> verifyPin(String pin) => _repository.verifyPin(pin);

  Future<void> clearPin() async {
    await _repository.clearPin();
    final current = state.valueOrNull ?? const AppSettings();
    await update(current.copyWith(pinEnabled: false));
  }

  Future<bool> hasPin() => _repository.hasPin();
}

final settingsNotifierProvider =
    StateNotifierProvider<SettingsNotifier, AsyncValue<AppSettings>>((ref) {
  return SettingsNotifier(
    ref.watch(settingsRepositoryProvider),
    ref.watch(reminderServiceProvider),
  );
});

final themeModeProvider = Provider<ThemeMode>((ref) {
  final settings = ref.watch(settingsNotifierProvider).valueOrNull;
  return settings?.themeMode ?? ThemeMode.system;
});
