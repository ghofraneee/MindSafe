import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mindsafe/core/providers/core_providers.dart';
import 'package:mindsafe/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:mindsafe/features/authentication/domain/entities/user_entity.dart';
import 'package:mindsafe/features/authentication/domain/failures/auth_failure.dart';
import 'package:mindsafe/features/authentication/domain/repositories/auth_repository.dart';
import 'package:mindsafe/features/authentication/presentation/providers/auth_state.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    storageService: ref.watch(storageServiceProvider),
    biometricService: ref.watch(biometricServiceProvider),
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._repository) : super(const AuthState.initial());

  final AuthRepository _repository;

  Future<void> checkSession() async {
    state = const AuthState.loading();
    try {
      final user = await _repository.getCurrentUser();
      if (user != null) {
        state = AuthState.authenticated(user: user);
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      state = AuthState.error(message: _messageFrom(e));
    }
  }

  Future<bool> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    state = const AuthState.loading();
    try {
      final user = await _repository.login(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );
      state = AuthState.authenticated(user: user);
      return true;
    } catch (e) {
      state = AuthState.error(message: _messageFrom(e));
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();
    try {
      final user = await _repository.register(
        name: name,
        email: email,
        password: password,
      );
      state = AuthState.authenticated(user: user);
      return true;
    } catch (e) {
      state = AuthState.error(message: _messageFrom(e));
      return false;
    }
  }

  Future<void> logout() async {
    state = const AuthState.loading();
    try {
      await _repository.logout();
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(message: _messageFrom(e));
    }
  }

  Future<bool> forgotPassword(String email) async {
    state = const AuthState.loading();
    try {
      await _repository.forgotPassword(email);
      final user = await _repository.getCurrentUser();
      if (user != null) {
        state = AuthState.authenticated(user: user);
      } else {
        state = const AuthState.unauthenticated();
      }
      return true;
    } catch (e) {
      state = AuthState.error(message: _messageFrom(e));
      return false;
    }
  }

  Future<bool> biometricLogin() async {
    state = const AuthState.loading();
    try {
      final user = await _repository.loginWithBiometric();
      if (user != null) {
        state = AuthState.authenticated(user: user);
        return true;
      }
      state = const AuthState.unauthenticated();
      return false;
    } catch (e) {
      state = AuthState.error(message: _messageFrom(e));
      return false;
    }
  }

  Future<bool> enableBiometric(bool enabled) async {
    try {
      await _repository.enableBiometric(enabled);
      return true;
    } catch (e) {
      state = AuthState.error(message: _messageFrom(e));
      return false;
    }
  }

  Future<bool> isBiometricEnabled() => _repository.isBiometricEnabled();

  Future<void> deleteAccount() async {
    state = const AuthState.loading();
    try {
      await _repository.deleteAccount();
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(message: _messageFrom(e));
    }
  }

  void clearError() {
    state.maybeWhen(
      error: (_) => state = const AuthState.unauthenticated(),
      orElse: () {},
    );
  }

  String _messageFrom(Object error) {
    if (error is AuthFailure) return error.message;
    return 'Something went wrong. Please try again.';
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

final currentUserProvider = Provider<UserEntity?>((ref) {
  return ref.watch(authNotifierProvider).maybeWhen(
        authenticated: (user) => user,
        orElse: () => null,
      );
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(currentUserProvider) != null;
});

final biometricEnabledProvider = FutureProvider<bool>((ref) async {
  final repository = ref.watch(authRepositoryProvider);
  return repository.isBiometricEnabled();
});
