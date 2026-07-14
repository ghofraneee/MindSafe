import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mindsafe/core/constants/app_colors.dart';
import 'package:mindsafe/core/utils/extensions.dart';
import 'package:mindsafe/core/widgets/empty_state.dart';
import 'package:mindsafe/core/widgets/glass_card.dart';
import 'package:mindsafe/core/widgets/mood_emoji.dart';
import 'package:mindsafe/features/mood/domain/entities/mood_entry.dart';
import 'package:mindsafe/features/mood/presentation/providers/mood_provider.dart';

class MoodHistoryScreen extends ConsumerWidget {
  const MoodHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moods = ref.watch(moodHistoryProvider);
    final isLoading = ref.watch(moodNotifierProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood History'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : moods.isEmpty
              ? const EmptyState(
                  icon: Icons.sentiment_neutral_rounded,
                  title: 'No mood entries yet',
                  subtitle:
                      'Start tracking your mood to see your history here.',
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: moods.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _MoodHistoryTile(entry: moods[index]);
                  },
                ),
    );
  }
}

class _MoodHistoryTile extends ConsumerWidget {
  const _MoodHistoryTile({required this.entry});

  final MoodEntry entry;

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete mood entry?'),
        content: const Text(
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final success =
          await ref.read(moodNotifierProvider.notifier).deleteMood(entry.id);
      if (context.mounted && success) {
        context.showSnack('Mood entry deleted');
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MoodEmoji(mood: entry.mood, size: 36),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      entry.mood.label,
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: entry.mood.color,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      entry.date.formattedShort,
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    _MetricChip(
                      icon: Icons.bolt_rounded,
                      label: 'Energy ${entry.energyLevel.round()}',
                      color: AppColors.accent,
                    ),
                    _MetricChip(
                      icon: Icons.psychology_alt_rounded,
                      label: 'Stress ${entry.stressLevel.round()}',
                      color: AppColors.warning,
                    ),
                    _MetricChip(
                      icon: Icons.bedtime_rounded,
                      label: '${entry.sleepHours.toStringAsFixed(1)}h sleep',
                      color: AppColors.primary,
                    ),
                  ],
                ),
                if (entry.notes != null && entry.notes!.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    entry.notes!,
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      height: 1.4,
                      color: colorScheme.onSurface.withValues(alpha: 0.75),
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            tooltip: 'Delete',
            onPressed: () => _confirmDelete(context, ref),
            icon: Icon(
              Icons.delete_outline_rounded,
              color: colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
