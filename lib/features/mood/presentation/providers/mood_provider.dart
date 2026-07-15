import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:mindsafe/core/providers/core_providers.dart';
import 'package:mindsafe/features/authentication/presentation/providers/auth_provider.dart';
import 'package:mindsafe/features/mood/data/repositories/mood_repository_impl.dart';
import 'package:mindsafe/features/mood/domain/entities/mood_entry.dart';
import 'package:mindsafe/features/mood/domain/entities/mood_type.dart';
import 'package:mindsafe/features/mood/domain/repositories/mood_repository.dart';
import 'package:mindsafe/features/mood/presentation/providers/mood_state.dart';

final moodRepositoryProvider = Provider<MoodRepository>((ref) {
  return MoodRepositoryImpl(
    storageService: ref.watch(storageServiceProvider),
  );
});

class MoodNotifier extends StateNotifier<MoodState> {
  MoodNotifier(this._repository, this._userId) : super(const MoodState()) {
    loadMoods();
  }

  final MoodRepository _repository;
  final String? _userId;
  final _uuid = const Uuid();

  Future<void> loadMoods() async {
    if (_userId == null) {
      state = const MoodState();
      return;
    }
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final moods = await _repository.getMoods(userId: _userId);
      state = state.copyWith(
        moods: moods,
        todayMood: _findTodayMood(moods),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Could not load moods.',
      );
    }
  }

  MoodEntry? _findTodayMood(List<MoodEntry> moods) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    for (final entry in moods) {
      final d = entry.createdAt;
      final entryDay = DateTime(d.year, d.month, d.day);
      if (entryDay == today) return entry;
    }
    return null;
  }

  Future<bool> saveMood({
    required MoodType mood,
    String? notes,
    double energyLevel = 5,
    double stressLevel = 5,
    double sleepHours = 7,
  }) async {
    if (_userId == null) return false;

    state = state.copyWith(isSaving: true, errorMessage: null);
    try {
      final existing = state.todayMood;
      final entry = MoodEntry(
        id: existing?.id ?? _uuid.v4(),
        userId: _userId,
        mood: mood,
        createdAt: existing?.createdAt ?? DateTime.now(),
        energyLevel: energyLevel,
        stressLevel: stressLevel,
        sleepHours: sleepHours,
        notes: notes,
      );
      await _repository.saveMood(entry);
      await loadMoods();
      state = state.copyWith(isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Could not save mood.',
      );
      return false;
    }
  }

  Future<bool> deleteMood(String id) async {
    if (_userId == null) return false;
    try {
      await _repository.deleteMood(id);
      await loadMoods();
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: 'Could not delete mood.');
      return false;
    }
  }

  Future<void> refresh() => loadMoods();
}

final moodNotifierProvider =
    StateNotifierProvider<MoodNotifier, MoodState>((ref) {
  final user = ref.watch(currentUserProvider);
  return MoodNotifier(
    ref.watch(moodRepositoryProvider),
    user?.id,
  );
});

final todayMoodProvider = Provider<MoodEntry?>((ref) {
  return ref.watch(moodNotifierProvider).todayMood;
});

final moodListProvider = Provider<List<MoodEntry>>((ref) {
  return ref.watch(moodNotifierProvider).moods;
});

/// Alias used by history UI — same data as [moodListProvider].
final moodHistoryProvider = moodListProvider;

final moodStreakProvider = Provider<int>((ref) {
  final moods = ref.watch(moodListProvider);
  if (moods.isEmpty) return 0;

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final daysWithEntries = <DateTime>{};
  for (final entry in moods) {
    final d = entry.createdAt;
    daysWithEntries.add(DateTime(d.year, d.month, d.day));
  }

  var streak = 0;
  var cursor = today;
  while (daysWithEntries.contains(cursor)) {
    streak++;
    cursor = cursor.subtract(const Duration(days: 1));
  }
  return streak;
});

final weeklyMoodScoreProvider = Provider<double>((ref) {
  final moods = ref.watch(moodListProvider);
  if (moods.isEmpty) return 0;

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final weekStart = today.subtract(const Duration(days: 6));

  final weekEntries = moods.where((e) => !e.createdAt.isBefore(weekStart));
  if (weekEntries.isEmpty) return 0;

  final sum = weekEntries.fold<int>(0, (s, e) => s + e.mood.score);
  return sum / weekEntries.length;
});
