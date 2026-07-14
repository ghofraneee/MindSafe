import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mindsafe/features/analytics/presentation/providers/analytics_provider.dart';
import 'package:mindsafe/features/authentication/presentation/providers/auth_provider.dart';
import 'package:mindsafe/features/profile/domain/entities/achievement.dart';

final achievementsProvider = Provider<List<Achievement>>((ref) {
  final user = ref.watch(currentUserProvider);
  final stats = ref.watch(moodStatsProvider);

  if (user == null) return [];

  return [
    Achievement(
      id: 'first_mood',
      title: 'First Step',
      description: 'Log your first mood entry',
      icon: Icons.emoji_emotions_outlined,
      unlocked: stats.totalEntries >= 1,
    ),
    Achievement(
      id: 'week_streak',
      title: 'Week Warrior',
      description: 'Maintain a 7-day mood streak',
      icon: Icons.local_fire_department_rounded,
      unlocked: stats.streak >= 7,
    ),
    Achievement(
      id: 'month_tracker',
      title: 'Monthly Mindful',
      description: 'Log 30 mood entries',
      icon: Icons.calendar_month_rounded,
      unlocked: stats.totalEntries >= 30,
    ),
    Achievement(
      id: 'wellness_50',
      title: 'Halfway There',
      description: 'Reach 50% wellness score',
      icon: Icons.favorite_rounded,
      unlocked: user.wellnessScore >= 50,
    ),
    Achievement(
      id: 'wellness_80',
      title: 'Thriving',
      description: 'Reach 80% wellness score',
      icon: Icons.spa_rounded,
      unlocked: user.wellnessScore >= 80,
    ),
    Achievement(
      id: 'balanced_week',
      title: 'Balanced Week',
      description: 'Weekly mood average above 3.5',
      icon: Icons.balance_rounded,
      unlocked: stats.weeklyAverage >= 3.5,
    ),
  ];
});
