import 'package:mindsafe/core/services/storage_service.dart';
import 'package:mindsafe/features/mood/data/models/mood_entry_model.dart';
import 'package:mindsafe/features/mood/domain/entities/mood_entry.dart';
import 'package:mindsafe/features/mood/domain/repositories/mood_repository.dart';

class MoodRepositoryImpl implements MoodRepository {
  MoodRepositoryImpl({required StorageService storageService})
      : _storage = storageService;

  final StorageService _storage;
  static const _entriesKey = 'mood_entries';

  Future<List<MoodEntryModel>> _loadAll() async {
    final raw = _storage.moodBox.get(_entriesKey);
    if (raw is! List) return [];

    return raw
        .whereType<Map>()
        .map((e) => MoodEntryModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> _persist(List<MoodEntryModel> entries) async {
    await _storage.moodBox.put(
      _entriesKey,
      entries.map((e) => e.toJson()).toList(),
    );
  }

  @override
  Future<List<MoodEntry>> getMoods({String? userId}) async {
    final entries = await _loadAll();
    final filtered = userId == null
        ? entries
        : entries.where((e) => e.userId == userId);
    return filtered.map((e) => e.toEntity()).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<MoodEntry> saveMood(MoodEntry entry) async {
    final entries = await _loadAll();
    final model = MoodEntryModel.fromEntity(entry);
    final index = entries.indexWhere((e) => e.id == entry.id);
    if (index >= 0) {
      entries[index] = model;
    } else {
      entries.add(model);
    }
    await _persist(entries);
    return entry;
  }

  @override
  Future<void> deleteMood(String id) async {
    final entries = await _loadAll();
    entries.removeWhere((e) => e.id == id);
    await _persist(entries);
  }

  @override
  Future<void> clearMoods({String? userId}) async {
    if (userId == null) {
      await _storage.moodBox.delete(_entriesKey);
      return;
    }
    final entries = await _loadAll();
    entries.removeWhere((e) => e.userId == userId);
    await _persist(entries);
  }
}
