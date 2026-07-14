import 'package:uuid/uuid.dart';

import 'package:mindsafe/core/constants/app_constants.dart';
import 'package:mindsafe/core/services/biometric_service.dart';
import 'package:mindsafe/core/services/storage_service.dart';
import 'package:mindsafe/features/authentication/data/models/user_model.dart';
import 'package:mindsafe/features/authentication/domain/entities/user_entity.dart';
import 'package:mindsafe/features/authentication/domain/failures/auth_failure.dart';
import 'package:mindsafe/features/authentication/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required StorageService storageService,
    required BiometricService biometricService,
    Uuid? uuid,
  })  : _storage = storageService,
        _biometric = biometricService,
        _uuid = uuid ?? const Uuid();

  final StorageService _storage;
  final BiometricService _biometric;
  final Uuid _uuid;

  static const _usersKey = 'registered_users';
  static const _emailIndexKey = 'email_index';

  String? _inMemorySessionUserId;
  bool _demoSeeded = false;

  Future<void> _ensureDemoUser() async {
    if (_demoSeeded) return;
    _demoSeeded = true;

    final users = await _loadUsers();
    if (users.isNotEmpty) return;

    final salt = PasswordHasher.generateSalt();
    final hash = PasswordHasher.hash(AppConstants.demoPassword, salt);
    final now = DateTime.now();
    final demoUser = UserModel(
      id: _uuid.v4(),
      email: AppConstants.demoEmail.toLowerCase(),
      name: AppConstants.demoName,
      passwordHash: hash,
      passwordSalt: salt,
      wellnessScore: 72,
      streak: 5,
      createdAt: now,
    );

    await _saveUser(demoUser);
  }

  Future<Map<String, UserModel>> _loadUsers() async {
    final raw = _storage.userBox.get(_usersKey);
    if (raw is! Map) return {};

    final users = <String, UserModel>{};
    raw.forEach((key, value) {
      if (value is Map) {
        users[key.toString()] =
            UserModel.fromJson(Map<String, dynamic>.from(value));
      }
    });
    return users;
  }

  Future<Map<String, String>> _loadEmailIndex() async {
    final raw = _storage.userBox.get(_emailIndexKey);
    if (raw is! Map) return {};

    return raw.map(
      (key, value) => MapEntry(key.toString(), value.toString()),
    );
  }

  Future<void> _persistUsers(Map<String, UserModel> users) async {
    final serialized = users.map(
      (key, value) => MapEntry(key, value.toJson()),
    );
    await _storage.userBox.put(_usersKey, serialized);
  }

  Future<void> _persistEmailIndex(Map<String, String> index) async {
    await _storage.userBox.put(_emailIndexKey, index);
  }

  Future<void> _saveUser(UserModel user) async {
    final users = await _loadUsers();
    final index = await _loadEmailIndex();

    users[user.id] = user;
    index[user.email.toLowerCase()] = user.id;

    await _persistUsers(users);
    await _persistEmailIndex(index);
  }

  Future<UserModel?> _findByEmail(String email) async {
    await _ensureDemoUser();
    final index = await _loadEmailIndex();
    final userId = index[email.trim().toLowerCase()];
    if (userId == null) return null;

    final users = await _loadUsers();
    return users[userId];
  }

  Future<UserModel?> _findById(String id) async {
    await _ensureDemoUser();
    final users = await _loadUsers();
    return users[id];
  }

  bool _verifyPassword(UserModel user, String password) {
    final hash = PasswordHasher.hash(password, user.passwordSalt);
    return hash == user.passwordHash;
  }

  Future<void> _persistSession(String userId, {required bool rememberMe}) async {
    _inMemorySessionUserId = userId;
    await _storage.writeSecure(
      AppConstants.rememberMeKey,
      rememberMe ? 'true' : 'false',
    );

    if (rememberMe) {
      await _storage.writeSecure(AppConstants.sessionTokenKey, userId);
    } else {
      await _storage.deleteSecure(AppConstants.sessionTokenKey);
    }
  }

  Future<void> _clearSession() async {
    _inMemorySessionUserId = null;
    await _storage.deleteSecure(AppConstants.sessionTokenKey);
    await _storage.deleteSecure(AppConstants.rememberMeKey);
  }

  Future<String?> _resolveSessionUserId() async {
    if (_inMemorySessionUserId != null) {
      return _inMemorySessionUserId;
    }

    final rememberMe =
        await _storage.readSecure(AppConstants.rememberMeKey);
    if (rememberMe != 'true') return null;

    return _storage.readSecure(AppConstants.sessionTokenKey);
  }

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    await _ensureDemoUser();

    final user = await _findByEmail(email);
    if (user == null || !_verifyPassword(user, password)) {
      throw const InvalidCredentialsFailure();
    }

    await _persistSession(user.id, rememberMe: rememberMe);
    return user.toEntity();
  }

  @override
  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await _ensureDemoUser();

    final normalizedEmail = email.trim().toLowerCase();
    final existing = await _findByEmail(normalizedEmail);
    if (existing != null) {
      throw const EmailAlreadyExistsFailure();
    }

    final salt = PasswordHasher.generateSalt();
    final hash = PasswordHasher.hash(password, salt);
    final user = UserModel(
      id: _uuid.v4(),
      email: normalizedEmail,
      name: name.trim(),
      passwordHash: hash,
      passwordSalt: salt,
      createdAt: DateTime.now(),
    );

    await _saveUser(user);
    await _persistSession(user.id, rememberMe: true);
    return user.toEntity();
  }

  @override
  Future<void> logout() async {
    await _clearSession();
  }

  @override
  Future<void> forgotPassword(String email) async {
    await _ensureDemoUser();
    final user = await _findByEmail(email);
    if (user == null) {
      throw const UserNotFoundFailure();
    }

    // Simulated reset: in production this would trigger email delivery.
    await Future<void>.delayed(const Duration(milliseconds: 600));
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final userId = await _resolveSessionUserId();
    if (userId == null) return null;

    final user = await _findById(userId);
    return user?.toEntity();
  }

  @override
  Future<bool> isAuthenticated() async {
    final user = await getCurrentUser();
    return user != null;
  }

  @override
  Future<void> enableBiometric(bool enabled) async {
    await _storage.writeSecure(
      AppConstants.biometricEnabledKey,
      enabled ? 'true' : 'false',
    );
  }

  @override
  Future<bool> isBiometricEnabled() async {
    final value = await _storage.readSecure(AppConstants.biometricEnabledKey);
    return value == 'true';
  }

  @override
  Future<UserEntity?> loginWithBiometric() async {
    final enabled = await isBiometricEnabled();
    if (!enabled) {
      throw const BiometricNotEnabledFailure();
    }

    final rememberMe =
        await _storage.readSecure(AppConstants.rememberMeKey);
    if (rememberMe != 'true') {
      throw const NoRememberedSessionFailure();
    }

    final authenticated = await _biometric.authenticate(
      reason: 'Unlock MindSafe with biometrics',
    );
    if (!authenticated) {
      throw const BiometricAuthFailure();
    }

    final user = await getCurrentUser();
    if (user == null) {
      throw const SessionExpiredFailure();
    }

    _inMemorySessionUserId = user.id;
    return user;
  }

  @override
  Future<void> deleteAccount() async {
    final userId = await _resolveSessionUserId();
    if (userId == null) return;

    final users = await _loadUsers();
    final index = await _loadEmailIndex();
    final user = users.remove(userId);

    if (user != null) {
      index.remove(user.email.toLowerCase());
    }

    await _persistUsers(users);
    await _persistEmailIndex(index);
    await _clearSession();
    await _storage.writeSecure(AppConstants.biometricEnabledKey, 'false');
  }
}
