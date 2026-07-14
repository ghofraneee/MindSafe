import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mindsafe/core/constants/app_colors.dart';
import 'package:mindsafe/core/utils/extensions.dart';
import 'package:mindsafe/core/widgets/gradient_button.dart';
import 'package:mindsafe/features/journal/domain/entities/journal_entry.dart';
import 'package:mindsafe/features/journal/presentation/providers/journal_provider.dart';
import 'package:mindsafe/features/mood/domain/entities/mood_type.dart';

class JournalEditorScreen extends ConsumerStatefulWidget {
  const JournalEditorScreen({
    super.key,
    this.entryId,
  });

  final String? entryId;

  @override
  ConsumerState<JournalEditorScreen> createState() =>
      _JournalEditorScreenState();
}

class _JournalEditorScreenState extends ConsumerState<JournalEditorScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  MoodType? _selectedMood;
  JournalEntry? _existingEntry;
  bool _isLoading = true;
  String? _draftId;

  bool get _isEditing => widget.entryId != null;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_onContentChanged);
    _bodyController.addListener(_onContentChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadEntry());
  }

  Future<void> _loadEntry() async {
    if (_isEditing) {
      final repository = ref.read(journalRepositoryProvider);
      final entry = await repository.getEntryById(widget.entryId!);
      if (entry != null && mounted) {
        setState(() {
          _existingEntry = entry;
          _titleController.text = entry.title;
          _bodyController.text = entry.description;
          _selectedMood = entry.moodTag;
          _isLoading = false;
        });
        return;
      }
    } else {
      final draft = ref.read(journalDraftProvider);
      if (draft != null && mounted) {
        setState(() {
          _draftId = draft.id;
          _titleController.text = draft.title;
          _bodyController.text = draft.description;
          _selectedMood = draft.moodTag;
        });
      }
    }
    if (mounted) setState(() => _isLoading = false);
  }

  void _onContentChanged() {
    if (_isEditing) return;
    ref.read(journalNotifierProvider.notifier).scheduleDraftSave(
          title: _titleController.text,
          description: _bodyController.text,
          moodTag: _selectedMood,
          existingDraftId: _draftId,
        );
  }

  @override
  void dispose() {
    _titleController.removeListener(_onContentChanged);
    _bodyController.removeListener(_onContentChanged);
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();

    if (title.isEmpty) {
      context.showSnack('Please add a title', isError: true);
      return;
    }
    if (body.isEmpty) {
      context.showSnack('Please write something in your journal', isError: true);
      return;
    }

    final success = await ref.read(journalNotifierProvider.notifier).saveEntry(
          id: _existingEntry?.id,
          title: title,
          description: body,
          moodTag: _selectedMood,
        );

    if (!mounted) return;

    if (success) {
      context.showSnack(_isEditing ? 'Entry updated' : 'Entry saved');
      context.pop();
    } else {
      context.showSnack(
        ref.read(journalNotifierProvider).errorMessage ?? 'Failed to save',
        isError: true,
      );
    }
  }

  Future<void> _delete() async {
    if (_existingEntry == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete entry?'),
        content: const Text('This journal entry will be permanently deleted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final success = await ref
          .read(journalNotifierProvider.notifier)
          .deleteEntry(_existingEntry!.id);
      if (mounted && success) {
        context.showSnack('Entry deleted');
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final journalState = ref.watch(journalNotifierProvider);
    final isDraftSaving = journalState.isDraftSaving && !_isEditing;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit entry' : 'New entry'),
        actions: [
          if (isDraftSaving)
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          if (_isEditing)
            IconButton(
              tooltip: 'Delete',
              onPressed: _delete,
              icon: const Icon(Icons.delete_outline_rounded),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _titleController,
                    style: GoogleFonts.fraunces(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Title',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Mood tag',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _MoodTagChip(
                        label: 'None',
                        selected: _selectedMood == null,
                        onTap: () {
                          setState(() => _selectedMood = null);
                          _onContentChanged();
                        },
                      ),
                      ...MoodType.values.map(
                        (mood) => _MoodTagChip(
                          label: '${mood.emoji} ${mood.label}',
                          selected: _selectedMood == mood,
                          color: mood.color,
                          onTap: () {
                            setState(() => _selectedMood = mood);
                            _onContentChanged();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height * 0.45,
                    ),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest
                          .withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.1),
                      ),
                    ),
                    child: TextField(
                      controller: _bodyController,
                      maxLines: null,
                      minLines: 12,
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        height: 1.6,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Write your thoughts here...',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        hintStyle: GoogleFonts.dmSans(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  GradientButton(
                    label: _isEditing ? 'Update entry' : 'Save entry',
                    isLoading: journalState.isSaving,
                    icon: Icons.check_rounded,
                    onPressed: _save,
                  ),
                ],
              ),
            ),
    );
  }
}

class _MoodTagChip extends StatelessWidget {
  const _MoodTagChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.color,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final accent = color ?? AppColors.primary;

    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
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
    );
  }
}
