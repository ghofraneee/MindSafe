import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mindsafe/core/constants/app_colors.dart';
import 'package:mindsafe/core/widgets/empty_state.dart';
import 'package:mindsafe/features/journal/presentation/providers/journal_provider.dart';
import 'package:mindsafe/features/journal/presentation/widgets/journal_card.dart';
import 'package:mindsafe/features/mood/domain/entities/mood_type.dart';

class JournalListScreen extends ConsumerWidget {
  const JournalListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journalState = ref.watch(journalNotifierProvider);
    final entries = ref.watch(filteredJournalEntriesProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/journal/new'),
        icon: const Icon(Icons.edit_rounded),
        label: const Text('New entry'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: TextField(
              onChanged: (value) =>
                  ref.read(journalNotifierProvider.notifier).setSearchQuery(value),
              decoration: InputDecoration(
                hintText: 'Search entries...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: journalState.searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () => ref
                            .read(journalNotifierProvider.notifier)
                            .setSearchQuery(''),
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _MoodFilterChip(
                  label: 'All',
                  selected: journalState.moodFilter == null,
                  onSelected: () => ref
                      .read(journalNotifierProvider.notifier)
                      .setMoodFilter(null),
                ),
                ...MoodType.values.map(
                  (mood) => _MoodFilterChip(
                    label: '${mood.emoji} ${mood.label}',
                    selected: journalState.moodFilter == mood,
                    color: mood.color,
                    onSelected: () => ref
                        .read(journalNotifierProvider.notifier)
                        .setMoodFilter(mood),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          if (journalState.isDraftSaving)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Saving draft...',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: journalState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : entries.isEmpty
                    ? EmptyState(
                        icon: Icons.menu_book_rounded,
                        title: journalState.searchQuery.isNotEmpty ||
                                journalState.moodFilter != null
                            ? 'No matching entries'
                            : 'Your journal is empty',
                        subtitle: journalState.searchQuery.isNotEmpty ||
                                journalState.moodFilter != null
                            ? 'Try adjusting your search or filters.'
                            : 'Capture your thoughts and feelings.',
                        actionLabel: 'Write first entry',
                        onAction: () => context.push('/journal/new'),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                        itemCount: entries.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final entry = entries[index];
                          return JournalCard(
                            entry: entry,
                            onTap: () => context.push('/journal/${entry.id}'),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _MoodFilterChip extends StatelessWidget {
  const _MoodFilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
    this.color,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final accent = color ?? AppColors.primary;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onSelected(),
        selectedColor: accent.withValues(alpha: 0.15),
        checkmarkColor: accent,
        labelStyle: GoogleFonts.dmSans(
          fontSize: 13,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          color: selected ? accent : null,
        ),
        side: BorderSide(
          color: selected ? accent : Theme.of(context).colorScheme.outline,
        ),
      ),
    );
  }
}
