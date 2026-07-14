import 'package:flutter/material.dart';

import 'package:mindsafe/core/constants/app_colors.dart';
import 'package:mindsafe/core/widgets/stat_card.dart';

class StatsGrid extends StatelessWidget {
  const StatsGrid({
    super.key,
    required this.weeklyAverage,
    required this.monthlyAverage,
    required this.streak,
    required this.totalEntries,
  });

  final double weeklyAverage;
  final double monthlyAverage;
  final int streak;
  final int totalEntries;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: [
        StatCard(
          icon: Icons.calendar_view_week_rounded,
          value: weeklyAverage > 0 ? weeklyAverage.toStringAsFixed(1) : '—',
          label: 'Weekly Avg',
          accentColor: AppColors.primary,
          compact: true,
        ),
        StatCard(
          icon: Icons.calendar_month_rounded,
          value: monthlyAverage > 0 ? monthlyAverage.toStringAsFixed(1) : '—',
          label: 'Monthly Avg',
          accentColor: AppColors.accent,
          compact: true,
        ),
        StatCard(
          icon: Icons.local_fire_department_rounded,
          value: '$streak',
          label: streak == 1 ? 'Day Streak' : 'Day Streak',
          accentColor: AppColors.warning,
          compact: true,
        ),
        StatCard(
          icon: Icons.insights_rounded,
          value: '$totalEntries',
          label: 'Total Entries',
          accentColor: AppColors.info,
          compact: true,
        ),
      ],
    );
  }
}
