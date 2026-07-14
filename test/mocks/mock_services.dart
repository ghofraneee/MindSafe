import 'package:mocktail/mocktail.dart';

import 'package:mindsafe/core/services/biometric_service.dart';
import 'package:mindsafe/core/services/storage_service.dart';

class MockStorageService extends Mock implements StorageService {}

class MockBiometricService extends Mock implements BiometricService {}

class FakeStorageService extends StorageService {
  FakeStorageService() : super.inMemory();
}
