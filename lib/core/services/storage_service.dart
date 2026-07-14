import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../constants/app_constants.dart';

abstract class SecureStore {
  Future<String?> read(String key);
  Future<void> write({required String key, required String value});
  Future<void> delete(String key);
  Future<void> deleteAll();
}

class FlutterSecureStore implements SecureStore {
  FlutterSecureStore([FlutterSecureStorage? storage])
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock_this_device,
              ),
            );

  final FlutterSecureStorage _storage;

  @override
  Future<void> delete(String key) => _storage.delete(key: key);

  @override
  Future<void> deleteAll() => _storage.deleteAll();

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write({required String key, required String value}) =>
      _storage.write(key: key, value: value);
}

/// In-memory secure storage for unit tests.
@visibleForTesting
class InMemorySecureStore implements SecureStore {
  final Map<String, String> _store = {};

  @override
  Future<void> delete(String key) async => _store.remove(key);

  @override
  Future<void> deleteAll() async => _store.clear();

  @override
  Future<String?> read(String key) async => _store[key];

  @override
  Future<void> write({required String key, required String value}) async {
    _store[key] = value;
  }
}

/// Initializes and exposes encrypted Hive boxes + secure key storage.
class StorageService {
  StorageService({FlutterSecureStorage? secureStorage})
      : _secureStore = FlutterSecureStore(secureStorage);

  @visibleForTesting
  StorageService.inMemory({SecureStore? secureStore})
      : _secureStore = secureStore ?? InMemorySecureStore(),
        _userBox = _InMemoryBox(),
        _moodBox = _InMemoryBox(),
        _journalBox = _InMemoryBox(),
        _settingsBox = _InMemoryBox(),
        _draftBox = _InMemoryBox();

  final SecureStore _secureStore;

  Box<dynamic>? _userBox;
  Box<dynamic>? _moodBox;
  Box<dynamic>? _journalBox;
  Box<dynamic>? _settingsBox;
  Box<dynamic>? _draftBox;

  Box<dynamic> get userBox => _require(_userBox, AppConstants.userBox);
  Box<dynamic> get moodBox => _require(_moodBox, AppConstants.moodBox);
  Box<dynamic> get journalBox => _require(_journalBox, AppConstants.journalBox);
  Box<dynamic> get settingsBox =>
      _require(_settingsBox, AppConstants.settingsBox);
  Box<dynamic> get draftBox => _require(_draftBox, AppConstants.draftBox);

  /// Boots Hive with AES encryption keyed from flutter_secure_storage.
  Future<void> initialize() async {
    if (_userBox is _InMemoryBox) return;
    await Hive.initFlutter();
    final key = await _resolveEncryptionKey();

    _userBox = await Hive.openBox(
      AppConstants.userBox,
      encryptionCipher: HiveAesCipher(key),
    );
    _moodBox = await Hive.openBox(
      AppConstants.moodBox,
      encryptionCipher: HiveAesCipher(key),
    );
    _journalBox = await Hive.openBox(
      AppConstants.journalBox,
      encryptionCipher: HiveAesCipher(key),
    );
    _settingsBox = await Hive.openBox(
      AppConstants.settingsBox,
      encryptionCipher: HiveAesCipher(key),
    );
    _draftBox = await Hive.openBox(
      AppConstants.draftBox,
      encryptionCipher: HiveAesCipher(key),
    );
  }

  Future<Uint8List> _resolveEncryptionKey() async {
    final existing = await _secureStore.read(AppConstants.encryptionKeyStorage);
    if (existing != null && existing.isNotEmpty) {
      return Uint8List.fromList(base64Url.decode(existing));
    }
    final key = Hive.generateSecureKey();
    await _secureStore.write(
      key: AppConstants.encryptionKeyStorage,
      value: base64UrlEncode(key),
    );
    return Uint8List.fromList(key);
  }

  Future<void> writeSecure(String key, String value) =>
      _secureStore.write(key: key, value: value);

  Future<String?> readSecure(String key) => _secureStore.read(key);

  Future<void> deleteSecure(String key) => _secureStore.delete(key);

  /// Permanently wipes encrypted local data (reset / delete account).
  Future<void> wipeAll() async {
    await _userBox?.clear();
    await _moodBox?.clear();
    await _journalBox?.clear();
    await _settingsBox?.clear();
    await _draftBox?.clear();
    await _secureStore.deleteAll();
  }

  Box<dynamic> _require(Box<dynamic>? box, String name) {
    if (box == null || !box.isOpen) {
      throw StateError('Hive box "$name" is not initialized');
    }
    return box;
  }
}

/// Password hashing helpers (salted SHA-256 for local auth simulation).
class PasswordHasher {
  PasswordHasher._();

  static String hash(String password, String salt) {
    final bytes = utf8.encode('$salt::$password');
    return sha256.convert(bytes).toString();
  }

  static String generateSalt() {
    final bytes = Hive.generateSecureKey();
    return base64UrlEncode(bytes.sublist(0, 16));
  }
}

class _InMemoryBox implements Box<dynamic> {
  final Map<dynamic, dynamic> _data = {};

  @override
  bool get isOpen => true;

  @override
  String get name => 'in_memory';

  @override
  dynamic get(dynamic key, {dynamic defaultValue}) =>
      _data.containsKey(key) ? _data[key] : defaultValue;

  @override
  Future<void> put(dynamic key, dynamic value) async {
    _data[key] = value;
  }

  @override
  Future<void> delete(dynamic key) async {
    _data.remove(key);
  }

  @override
  Future<int> clear() async {
    final count = _data.length;
    _data.clear();
    return count;
  }

  @override
  Iterable get keys => _data.keys;

  @override
  Iterable get values => _data.values;

  @override
  int get length => _data.length;

  @override
  bool get isEmpty => _data.isEmpty;

  @override
  bool get isNotEmpty => _data.isNotEmpty;

  @override
  bool containsKey(dynamic key) => _data.containsKey(key);

  @override
  Future<void> putAll(Map<dynamic, dynamic> entries) async {
    _data.addAll(entries);
  }

  @override
  Future<void> deleteAll(Iterable<dynamic> keys) async {
    for (final key in keys) {
      _data.remove(key);
    }
  }

  @override
  dynamic getAt(int index) => values.elementAt(index);

  @override
  Future<void> putAt(int index, dynamic value) async {
    final key = keys.elementAt(index);
    _data[key] = value;
  }

  @override
  Future<void> deleteAt(int index) async {
    final key = keys.elementAt(index);
    _data.remove(key);
  }

  @override
  Future<void> flush() async {}

  @override
  Future<void> close() async {}

  @override
  Future<void> compact() async {}

  @override
  Future<int> add(dynamic value) async {
    final key = _data.length;
    _data[key] = value;
    return key;
  }

  @override
  Future<Iterable<int>> addAll(Iterable values) async {
    final indices = <int>[];
    for (final value in values) {
      indices.add(await add(value));
    }
    return indices;
  }

  @override
  Map<dynamic, dynamic> toMap() => Map<dynamic, dynamic>.from(_data);

  @override
  LazyBox<dynamic>? get lazy => null;

  @override
  HiveObject? getObject(dynamic key) => null;

  @override
  Future<void> putObject(dynamic key, HiveObject value) async {
    await put(key, value);
  }

  @override
  ValueListenable<BoxEvent> listenable({List<dynamic>? keys}) {
    throw UnimplementedError('listenable not needed in tests');
  }

  @override
  Stream<BoxEvent> watch({dynamic key}) {
    throw UnimplementedError('watch not needed in tests');
  }
}
