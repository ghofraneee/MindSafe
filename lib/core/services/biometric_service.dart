import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

/// Biometric authentication (fingerprint / Face ID).
class BiometricService {
  BiometricService({LocalAuthentication? localAuth})
      : _localAuth = localAuth ?? LocalAuthentication();

  final LocalAuthentication _localAuth;

  Future<bool> get isDeviceSupported async {
    try {
      return await _localAuth.isDeviceSupported();
    } on PlatformException {
      return false;
    }
  }

  Future<bool> get canCheckBiometrics async {
    try {
      return await _localAuth.canCheckBiometrics;
    } on PlatformException {
      return false;
    }
  }

  Future<List<BiometricType>> get availableBiometrics async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } on PlatformException {
      return [];
    }
  }

  /// Prompts the OS biometric sheet. Returns true on success.
  Future<bool> authenticate({
    String reason = 'Authenticate to unlock MindSafe',
  }) async {
    try {
      final supported = await isDeviceSupported;
      final canCheck = await canCheckBiometrics;
      if (!supported && !canCheck) return false;

      return await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
          useErrorDialogs: true,
        ),
      );
    } on PlatformException {
      return false;
    }
  }
}
