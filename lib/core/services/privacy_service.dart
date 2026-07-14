import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../constants/app_constants.dart';

/// Privacy helpers: inactivity lock, screenshot blocking, session timeout.
class PrivacyService with WidgetsBindingObserver {
  PrivacyService({
    this.onLockRequired,
    this.onAutoLogout,
    this.inactivityMinutes = AppConstants.inactivityLockMinutes,
    this.autoLogoutMinutes = AppConstants.autoLogoutMinutes,
  });

  final VoidCallback? onLockRequired;
  final VoidCallback? onAutoLogout;
  final int inactivityMinutes;
  final int autoLogoutMinutes;

  Timer? _inactivityTimer;
  Timer? _logoutTimer;
  bool _isLocked = false;
  bool _screenshotBlocked = true;

  bool get isLocked => _isLocked;

  void start() {
    WidgetsBinding.instance.addObserver(this);
    _resetTimers();
    if (_screenshotBlocked) {
      unawaited(blockScreenshots(true));
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _inactivityTimer?.cancel();
    _logoutTimer?.cancel();
  }

  /// Call on any user interaction to reset inactivity countdown.
  void recordActivity() {
    if (_isLocked) return;
    _resetTimers();
  }

  void unlock() {
    _isLocked = false;
    _resetTimers();
  }

  void lock() {
    _isLocked = true;
    onLockRequired?.call();
  }

  void _resetTimers() {
    _inactivityTimer?.cancel();
    _logoutTimer?.cancel();

    _inactivityTimer = Timer(
      Duration(minutes: inactivityMinutes),
      () {
        _isLocked = true;
        onLockRequired?.call();
      },
    );

    _logoutTimer = Timer(
      Duration(minutes: autoLogoutMinutes),
      () => onAutoLogout?.call(),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      // Lock when app goes to background for privacy.
      _isLocked = true;
      onLockRequired?.call();
    }
  }

  /// FLAG_SECURE on Android to discourage screenshots/recents previews.
  Future<void> blockScreenshots(bool enabled) async {
    _screenshotBlocked = enabled;
    if (kIsWeb) return;
    try {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      // Uses method channel only when plugin available; soft-fail otherwise.
      const channel = MethodChannel('mindsafe/privacy');
      await channel.invokeMethod('setSecureFlag', {'enabled': enabled});
    } on MissingPluginException {
      // Platform channel optional in debug / desktop.
    } on PlatformException {
      // Ignore — platform may not support FLAG_SECURE.
    }
  }
}
