import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:mindsafe/core/constants/app_constants.dart';
import 'package:mindsafe/core/providers/core_providers.dart';
import 'package:mindsafe/features/journal/data/repositories/journal_repository_impl.dart';
import 'package:mindsafe/features/journal/domain/entities/journal_entry.dart';
import 'package:mindsafe/features/journal/domain/repositories/journal_repository.dart';
import 'package:mindsafe/features/journal/presentation/providers/journal_state.dart';
import 'package:mindsafe/features/mood/domain/entities/mood_type.dart';

final journalRepositoryProvider = Provider<JournalRepository>((ref) {  return JournalRepositoryImpl(
    storageService: ref.watch(storageServiceProvider),
  );
});

class JournalNotifier extends StateNotifier<JournalState> {  JournalNotifier(this._repository, this._uuid) : super(const JournalState()) {
    loadEntries();
    _loadDraft();
  }

  final JournalRepository _repository;
  final Uuid _uuid;
  Timer? _draftDebounce;

  Future<void> loadEntries() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final entries = await _repository.getAllEntries();
      state = state.copyWith(
        entries: entries,
        isLoading: false,
      );
      _applyFilters();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Could not load journal entries.',
      );
    }
  }

  Future<void> _loadDraft() async {
    try {
      final draft = await _repository.getDraft();
      state = state.copyWith(draft: draft);
    } catch (_) {}
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFilters();
  }

  void setMoodFilter(MoodType? mood) {
    state = state.copyWith(moodFilter: mood);
    _applyFilters();
  }

  void clearFilters() {
    state = state.copyWith(searchQuery: '', moodFilter: null);
    _applyFilters();
  }

  Future<void> _applyFilters() async {
    try {
      List<JournalEntry> result;

      if (state.searchQuery.trim().isNotEmpty) {
        result = await _repository.search(state.searchQuery);
      } else {
        result = state.entries;
      }

      if (state.moodFilter != null) {
        result = result
            .where((entry) => entry.moodTag == state.moodFilter)
            .toList();
      }

      state = state.copyWith(filteredEntries: result);
    } catch (e) {
      state = state.copyWith(filteredEntries: state.entries);
    }
  }

  /// Autosaves draft with debounce (800ms per [AppConstants.draftAutosaveMs]).
  void scheduleDraftSave({
    required String title,
    required String description,
    MoodType? moodTag,
    String? existingDraftId,
  }) {
    _draftDebounce?.cancel();
    _draftDebounce = Timer(
      const Duration(milliseconds: AppConstants.draftAutosaveMs),
      () => _saveDraft(
        title: title,
        description: description,
        moodTag: moodTag,
        existingDraftId: existingDraftId,
      ),
    );
  }

  Future<void> _saveDraft({
    required String title,
    required String description,
    MoodType? moodTag,
    String? existingDraftId,
  }) async {
    if (title.trim().isEmpty && description.trim().isEmpty) return;

    state = state.copyWith(isDraftSaving: true);
    try {
      final now = DateTime.now();
      final draft = JournalEntry(
        id: existingDraftId ?? state.draft?.id ?? _uuid.v4(),
        title: title,
        description: description,
        moodTag: moodTag,
        createdAt: state.draft?.createdAt ?? now,
        updatedAt: now,
        isDraft: true,
      );
      await _repository.saveDraft(draft);
      state = state.copyWith(draft: draft, isDraftSaving: false);
    } catch (e) {
      state = state.copyWith(isDraftSaving: false);
    }
  }

  Future<bool> saveEntry({
    String? id,
    required String title,
    required String description,
    MoodType? moodTag,
  }) async {
    _draftDebounce?.cancel();
    state = state.copyWith(isSaving: true, errorMessage: null);

    try {
      final now = DateTime.now();
      if (id != null) {
        final existing = await _repository.getEntryById(id);
        if (existing == null) {
          throw StateError('Entry not found');
        }
        await _repository.updateEntry(
          existing.copyWith(
            title: title.trim(),
            description: description.trim(),
            moodTag: moodTag,
            updatedAt: now,
            isDraft: false,
          ),
        );
      } else {
        await _repository.saveEntry(
          JournalEntry(
            id: _uuid.v4(),
            title: title.trim(),
            description: description.trim(),
            moodTag: moodTag,
            createdAt: now,
            updatedAt: now,
          ),
        );
      }

      await _repository.clearDraft();
      state = state.copyWith(draft: null, isSaving: false);
      await loadEntries();
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Could not save journal entry.',
      );
      return false;
    }
  }

  Future<bool> deleteEntry(String id) async {
    try {
      await _repository.deleteEntry(id);
      await loadEntries();
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: 'Could not delete entry.');
      return false;
    }
  }

  Future<void> discardDraft() async {
    _draftDebounce?.cancel();
    await _repository.clearDraft();
    state = state.copyWith(draft: null);
  }

  @override
  void dispose() {
    _draftDebounce?.cancel();
    super.dispose();
  }
}

final journalNotifierProvider =
    StateNotifierProvider<JournalNotifier, JournalState>((ref) {
  return JournalNotifier(
    ref.watch(journalRepositoryProvider),
    const Uuid(),
  );
});

final filteredJournalEntriesProvider = Provider<List<JournalEntry>>((ref) {
  final state = ref.watch(journalNotifierProvider);
  if (state.searchQuery.isNotEmpty || state.moodFilter != null) {
    return state.filteredEntries;
  }
  return state.entries;
});

final recentJournalEntriesProvider = Provider<List<JournalEntry>>((ref) {
  final entries = ref.watch(journalNotifierProvider).entries;
  return entries.take(3).toList();
});

final journalDraftProvider = Provider<JournalEntry?>((ref) {
  return ref.watch(journalNotifierProvider).draft;
});
