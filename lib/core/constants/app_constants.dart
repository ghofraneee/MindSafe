/// Application-wide string and configuration constants.
class AppConstants {
  AppConstants._();

  static const String appName = 'MindSafe';
  static const String appTagline = 'Your mind. Your privacy. Your peace.';
  static const String appVersion = '1.0.0';

  /// Simulated demo user for first-time portfolio demos.
  static const String demoEmail = 'sarah@mindsafe.app';
  static const String demoPassword = 'MindSafe@2024';
  static const String demoName = 'Sarah';

  /// Inactivity timeout before app lock (minutes).
  static const int inactivityLockMinutes = 5;

  /// Auto-logout timeout (minutes).
  static const int autoLogoutMinutes = 30;

  /// Journal draft autosave debounce (milliseconds).
  static const int draftAutosaveMs = 800;

  /// Meditation timer default (seconds).
  static const int meditationDefaultSeconds = 300;

  /// Hive box names.
  static const String userBox = 'users_secure';
  static const String moodBox = 'moods_secure';
  static const String journalBox = 'journals_secure';
  static const String settingsBox = 'settings_secure';
  static const String draftBox = 'drafts_secure';

  /// Secure storage keys.
  static const String encryptionKeyStorage = 'hive_encryption_key';
  static const String sessionTokenKey = 'session_token';
  static const String rememberMeKey = 'remember_me';
  static const String biometricEnabledKey = 'biometric_enabled';
  static const String pinHashKey = 'pin_hash';
  static const String pinSaltKey = 'pin_salt';
}
