import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:mindsafe/core/constants/app_constants.dart';
import 'package:mindsafe/core/services/storage_service.dart';
import 'package:mindsafe/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:mindsafe/features/authentication/domain/failures/auth_failure.dart';

import '../../mocks/mock_services.dart';

void main() {
  late FakeStorageService storage;
  late MockBiometricService biometric;
  late AuthRepositoryImpl repository;

  setUp(() {
    storage = FakeStorageService();
    biometric = MockBiometricService();
    repository = AuthRepositoryImpl(
      storageService: storage,
      biometricService: biometric,
    );
  });

  group('AuthRepositoryImpl', () {
    test('seeds demo user and logs in successfully', () async {
      final user = await repository.login(
        email: AppConstants.demoEmail,
        password: AppConstants.demoPassword,
        rememberMe: true,
      );

      expect(user.email, AppConstants.demoEmail.toLowerCase());
      expect(user.name, AppConstants.demoName);
      expect(await repository.isAuthenticated(), isTrue);
    });

    test('login fails with invalid credentials', () async {
      await repository.login(
        email: AppConstants.demoEmail,
        password: AppConstants.demoPassword,
      );

      expect(
        () => repository.login(
          email: AppConstants.demoEmail,
          password: 'wrong-password',
        ),
        throwsA(isA<InvalidCredentialsFailure>()),
      );
    });

    test('register creates a new user and session', () async {
      final user = await repository.register(
        name: 'Alex',
        email: 'alex@example.com',
        password: 'SecurePass123!',
      );

      expect(user.email, 'alex@example.com');
      expect(user.name, 'Alex');
      expect(await repository.getCurrentUser(), isNotNull);
    });

    test('register fails when email already exists', () async {
      await repository.register(
        name: 'Alex',
        email: 'alex@example.com',
        password: 'SecurePass123!',
      );

      expect(
        () => repository.register(
          name: 'Alex 2',
          email: 'alex@example.com',
          password: 'AnotherPass123!',
        ),
        throwsA(isA<EmailAlreadyExistsFailure>()),
      );
    });

    test('logout clears the session', () async {
      await repository.login(
        email: AppConstants.demoEmail,
        password: AppConstants.demoPassword,
        rememberMe: true,
      );

      await repository.logout();

      expect(await repository.getCurrentUser(), isNull);
      expect(await repository.isAuthenticated(), isFalse);
    });

    test('demo user is seeded only once', () async {
      final first = await repository.login(
        email: AppConstants.demoEmail,
        password: AppConstants.demoPassword,
      );
      final second = await repository.login(
        email: AppConstants.demoEmail,
        password: AppConstants.demoPassword,
      );

      expect(first.id, second.id);
    });
  });
}
