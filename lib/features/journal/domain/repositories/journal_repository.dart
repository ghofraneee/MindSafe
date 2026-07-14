import '../entities/journal_entry.dart';
import 'package:mindsafe/features/mood/domain/entities/mood_type.dart';

abstract class JournalRepository {
  Future<void> saveEntry(JournalEntry entry);

  Future<void> updateEntry(JournalEntry entry);

  Future<void> deleteEntry(String id);

  Future<JournalEntry?> getEntryById(String id);

  Future<List<JournalEntry>> getAllEntries();

  Future<List<JournalEntry>> search(String query);

  Future<List<JournalEntry>> filterByMood(MoodType mood);

  Future<void> saveDraft(JournalEntry draft);

  Future<JournalEntry?> getDraft();

  Future<void> clearDraft();
}
