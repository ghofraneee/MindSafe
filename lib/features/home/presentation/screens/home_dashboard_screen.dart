import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'package:mindsafe/core/constants/app_colors.dart';
import 'package:mindsafe/core/utils/extensions.dart';
import 'package:mindsafe/core/widgets/glass_card.dart';
import 'package:mindsafe/core/widgets/mood_emoji.dart';
import 'package:mindsafe/core/widgets/quote_card.dart';
import 'package:mindsafe/core/widgets/section_header.dart';
import 'package:mindsafe/features/authentication/presentation/providers/auth_provider.dart';
import 'package:mindsafe/features/mood/domain/entities/mood_entry.dart';
import 'package:mindsafe/features/home/presentation/widgets/quick_action_card.dart';
import 'package:mindsafe/features/home/presentation/widgets/streak_badge.dart';
import 'package:mindsafe/features/journal/presentation/providers/journal_provider.dart';
import 'package:mindsafe/features/journal/presentation/widgets/journal_card.dart';
import 'package:mindsafe/features/mood/presentation/providers/mood_provider.dart';

class HomeDashboardScreen extends ConsumerWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final todayMood = ref.watch(todayMoodProvider);
    final streak = ref.watch(moodStreakProvider);
    final weeklyScore = ref.watch(weeklyMoodScoreProvider);
    final recentEntries = ref.watch(recentJournalEntriesProvider);
    final isDark = context.isDarkMode;
    final name = user?.name ?? 'Friend';

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              ref.read(moodNotifierProvider.notifier).loadMoods(),
              ref.read(journalNotifierProvider.notifier).loadEntries(),
            ]);
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${DateTime.now().greeting},',
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                      Text(
                        name,
                        style: GoogleFonts.fraunces(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _TodayMoodCard(todayMood: todayMood),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: StreakBadge(streak: streak),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _WeeklyScoreCard(score: weeklyScore),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      const SectionHeader(title: 'Quick Actions'),
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.35,
                        children: [
                          QuickActionCard(
                            icon: Icons.sentiment_satisfied_alt_rounded,
                            label: 'Mood',
                            color: AppColors.moodGood,
                            onTap: () => context.go('/mood'),
                          ),
                          QuickActionCard(
                            icon: Icons.menu_book_rounded,
                            label: 'Journal',
                            color: AppColors.primary,
                            onTap: () => context.go('/journal'),
                          ),
                          QuickActionCard(
                            icon: Icons.air_rounded,
                            label: 'Breathe',
                            color: AppColors.accent,
                            onTap: () => context.push('/breathe'),
                          ),
                          QuickActionCard(
                            icon: Icons.self_improvement_rounded,
                            label: 'Meditate',
                            color: AppColors.secondary,
                            onTap: () => context.push('/meditate'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      SectionHeader(
                        title: 'Recent Journal',
                        actionLabel: recentEntries.isNotEmpty ? 'See all' : null,
                        onAction: recentEntries.isNotEmpty
                            ? () => context.go('/journal')
                            : null,
                      ),
                      if (recentEntries.isEmpty)
                        GlassCard(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit_note_rounded,
                                color: AppColors.primary.withValues(alpha: 0.6),
                                size: 32,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Start journaling',
                                      style: GoogleFonts.dmSans(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'Capture your thoughts and feelings.',
                                      style: GoogleFonts.dmSans(
                                        fontSize: 13,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withValues(alpha: 0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => context.push('/journal/new'),
                                icon: const Icon(Icons.add_rounded),
                              ),
                            ],
                          ),
                        )
                      else
                        ...recentEntries.map(
                          (entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: JournalCard(
                              entry: entry,
                              compact: true,
                              onTap: () => context.push('/journal/${entry.id}'),
                            ),
                          ),
                        ),
                      const SizedBox(height: 28),
                      const QuoteCard(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TodayMoodCard extends StatelessWidget {
  const _TodayMoodCard({required this.todayMood});

  final MoodEntry? todayMood;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassCard(
      gradientBorder: true,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          if (todayMood != null)
            MoodEmoji(mood: todayMood.mood, size: 40)
          else
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.1),
              ),
              child: Icon(
                Icons.add_reaction_rounded,
                color: AppColors.primary.withValues(alpha: 0.6),
                size: 28,
              ),
            ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today's Mood",
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  todayMood != null
                      ? todayMood.mood.label
                      : 'Not logged yet',
                  style: GoogleFonts.fraunces(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (todayMood != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Energy ${todayMood.energyLevel.round()} · '
                    'Stress ${todayMood.stressLevel.round()} · '
                    '${todayMood.sleepHours.toStringAsFixed(1)}h sleep',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: () => context.go('/mood'),
            icon: Icon(
              todayMood != null ? Icons.edit_rounded : Icons.add_rounded,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklyScoreCard extends StatelessWidget {
  const _WeeklyScoreCard({required this.score});

  final double score;

  @override
  Widget build(BuildContext context) {
    final percent = score / 5.0;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        children: [
          CircularPercentIndicator(
            radius: 28,
            lineWidth: 6,
            percent: percent.clamp(0.0, 1.0),
            center: Text(
              score > 0 ? score.toStringAsFixed(1) : '—',
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: AppColors.primary,
              ),
            ),
            progressColor: AppColors.primary,
            backgroundColor: AppColors.primary.withValues(alpha: 0.12),
            circularStrokeCap: CircularStrokeCap.round,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Weekly Score',
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Text(
                  'Avg mood this week',
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.55),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
