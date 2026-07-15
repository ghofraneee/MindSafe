import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import 'package:mindsafe/core/constants/app_constants.dart';
import 'package:mindsafe/core/constants/app_strings.dart';
import 'package:mindsafe/core/providers/core_providers.dart';
import 'package:mindsafe/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:mindsafe/features/authentication/presentation/providers/auth_provider.dart';
import 'package:mindsafe/features/authentication/presentation/screens/login_screen.dart';

import '../mocks/mock_services.dart';

void main() {
  late FakeStorageService storage;
  late MockBiometricService biometric;
  late AuthRepositoryImpl authRepository;

  setUp(() {
    storage = FakeStorageService();
    biometric = MockBiometricService();
    authRepository = AuthRepositoryImpl(
      storageService: storage,
      biometricService: biometric,
    );

    when(() => biometric.isDeviceSupported).thenAnswer((_) async => false);
    when(() => biometric.canCheckBiometrics).thenAnswer((_) async => false);
  });

  Widget buildApp() {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Home')),
          ),
        ),
        GoRoute(
          path: '/welcome',
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Welcome')),
          ),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Register')),
          ),
        ),
        GoRoute(
          path: '/forgot-password',
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Forgot')),
          ),
        ),
      ],
      initialLocation: '/login',
    );

    return ProviderScope(
      overrides: [
        storageServiceProvider.overrideWithValue(storage),
        biometricServiceProvider.overrideWithValue(biometric),
        authRepositoryProvider.overrideWithValue(authRepository),
      ],
      child: MaterialApp.router(routerConfig: router),
    );
  }

  testWidgets('LoginScreen shows title and demo credentials', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.loginTitle), findsOneWidget);
    expect(
      find.textContaining(AppConstants.demoEmail),
      findsOneWidget,
    );
    expect(
      find.textContaining(AppConstants.demoPassword),
      findsOneWidget,
    );
  });

  testWidgets('LoginScreen validates empty password', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, AppStrings.emailHint),
      'test@example.com',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, AppStrings.passwordHint),
      '',
    );
    await tester.tap(find.text(AppStrings.login));
    await tester.pumpAndSettle();

    expect(find.text('Password is required'), findsOneWidget);
  });

  testWidgets('LoginScreen logs in with demo credentials', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, AppStrings.emailHint),
      AppConstants.demoEmail,
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, AppStrings.passwordHint),
      AppConstants.demoPassword,
    );
    await tester.tap(find.text(AppStrings.login));
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
  });
}
