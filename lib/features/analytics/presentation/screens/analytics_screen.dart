import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mindsafe/core/constants/app_colors.dart';
import 'package:mindsafe/core/widgets/glass_card.dart';
import 'package:mindsafe/core/widgets/section_header.dart';
import 'package:mindsafe/features/analytics/presentation/providers/analytics_provider.dart';
import 'package:mindsafe/features/analytics/presentation/widgets/mood_pie_chart.dart';
import 'package:mindsafe/features/analytics/presentation/widgets/mood_trend_chart.dart';
import 'package:mindsafe/features/analytics/presentation/widgets/stats_grid.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(analyticsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(analyticsProvider);
        },
        color: AppColors.primary,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            Text(
              'Your mood insights',
              style: GoogleFonts.fraunces(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Track patterns and celebrate progress',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6),
                  ),
            ),
            const SizedBox(height: 24),
            StatsGrid(
              weeklyAverage: stats.weeklyAverage,
              monthlyAverage: stats.monthlyAverage,
              streak: stats.streak,
              totalEntries: stats.totalEntries,
            ),
            const SizedBox(height: 24),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(
                    title: 'Mood Trend',
                    subtitle: 'Last 14 days',
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 8),
                  MoodTrendChart(points: stats.trendPoints),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _ReportCard(
                    title: 'Weekly',
                    average: stats.weeklyAverage,
                    icon: Icons.trending_up_rounded,
                    gradient: AppColors.primaryGradient,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ReportCard(
                    title: 'Monthly',
                    average: stats.monthlyAverage,
                    icon: Icons.auto_graph_rounded,
                    gradient: const LinearGradient(
                      colors: [AppColors.secondary, Color(0xFF3A4F7A)],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GlassCard(
              child: Column(
                children: [
                  const SectionHeader(
                    title: 'Mood Distribution',
                    subtitle: 'All-time breakdown',
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 8),
                  MoodPieChart(distribution: stats.distribution),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _StreakBanner(streak: stats.streak),
          ],
        ),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({
    required this.title,
    required this.average,
    required this.icon,
    required this.gradient,
  });

  final String title;
  final double average;
  final IconData icon;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.9), size: 28),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.dmSans(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            average > 0 ? average.toStringAsFixed(1) : '—',
            style: GoogleFonts.fraunces(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'avg score',
            style: GoogleFonts.dmSans(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _StreakBanner extends StatelessWidget {
  const _StreakBanner({required this.streak});

  final int streak;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_fire_department_rounded,
              color: AppColors.warning,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$streak Day Streak',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  streak > 0
                      ? 'Keep logging daily to maintain your streak!'
                      : 'Log a mood today to start your streak',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
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
