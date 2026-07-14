import 'package:mindsafe/core/services/storage_service.dart';
import 'package:mindsafe/features/journal/data/models/journal_entry_model.dart';
import 'package:mindsafe/features/journal/domain/entities/journal_entry.dart';
import 'package:mindsafe/features/journal/domain/repositories/journal_repository.dart';
import 'package:mindsafe/features/mood/domain/entities/mood_type.dart';

class JournalRepositoryImpl implements JournalRepository {
  JournalRepositoryImpl({required StorageService storageService})
      : _storage = storageService;

  final StorageService _storage;

  static const _entriesKey = 'journal_entries';
  static const _draftKey = 'journal_draft';

  Future<Map<String, JournalEntryModel>> _loadEntries() async {
    final raw = _storage.journalBox.get(_entriesKey);
    if (raw is! Map) return {};

    final entries = <String, JournalEntryModel>{};
    raw.forEach((key, value) {
      if (value is Map) {
        entries[key.toString()] = JournalEntryModel.fromJson(
          Map<String, dynamic>.from(value),
        );
      }
    });
    return entries;
  }

  Future<void> _persistEntries(Map<String, JournalEntryModel> entries) async {
    final serialized = entries.map(
      (key, value) => MapEntry(key, value.toJson()),
    );
    await _storage.journalBox.put(_entriesKey, serialized);
  }

  List<JournalEntry> _sortNewestFirst(Iterable<JournalEntry> entries) {
    final list = entries.toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return list.where((entry) => !entry.isDraft).toList();
  }

  @override
  Future<void> saveEntry(JournalEntry entry) async {
    final entries = await _loadEntries();
    entries[entry.id] = JournalEntryModel.fromEntity(
      entry.copyWith(isDraft: false),
    );
    await _persistEntries(entries);
  }

  @override
  Future<void> updateEntry(JournalEntry entry) async {
    final entries = await _loadEntries();
    if (!entries.containsKey(entry.id)) {
      throw StateError('Journal entry "${entry.id}" not found');
    }
    entries[entry.id] = JournalEntryModel.fromEntity(
      entry.copyWith(isDraft: false),
    );
    await _persistEntries(entries);
  }

  @override
  Future<void> deleteEntry(String id) async {
    final entries = await _loadEntries();
    entries.remove(id);
    await _persistEntries(entries);
  }

  @override
  Future<JournalEntry?> getEntryById(String id) async {
    final entries = await _loadEntries();
    return entries[id]?.toEntity();
  }

  @override
  Future<List<JournalEntry>> getAllEntries() async {
    final entries = await _loadEntries();
    return _sortNewestFirst(entries.values.map((m) => m.toEntity()));
  }

  @override
  Future<List<JournalEntry>> search(String query) async {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return getAllEntries();

    final entries = await getAllEntries();
    return entries.where((entry) {
      return entry.title.toLowerCase().contains(normalized) ||
          entry.description.toLowerCase().contains(normalized);
    }).toList();
  }

  @override
  Future<List<JournalEntry>> filterByMood(MoodType mood) async {
    final entries = await getAllEntries();
    return entries.where((entry) => entry.moodTag == mood).toList();
  }

  @override
  Future<void> saveDraft(JournalEntry draft) async {
    await _storage.draftBox.put(
      _draftKey,
      JournalEntryModel.fromEntity(draft.copyWith(isDraft: true)).toJson(),
    );
  }

  @override
  Future<JournalEntry?> getDraft() async {
    final raw = _storage.draftBox.get(_draftKey);
    if (raw is! Map) return null;
    return JournalEntryModel.fromJson(
      Map<String, dynamic>.from(raw),
    ).toEntity();
  }

  @override
  Future<void> clearDraft() async {
    await _storage.draftBox.delete(_draftKey);
  }
}
