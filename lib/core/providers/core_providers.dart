import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mindsafe/core/services/biometric_service.dart';
import 'package:mindsafe/core/services/privacy_service.dart';
import 'package:mindsafe/core/services/storage_service.dart';

/// Global [StorageService] — must be overridden in [ProviderScope] after init.
final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError(
    'storageServiceProvider must be overridden after StorageService.initialize()',
  );
});

final biometricServiceProvider = Provider<BiometricService>((ref) {
  return BiometricService();
});

final privacyServiceProvider = Provider<PrivacyService>((ref) {
  return PrivacyService();
});
