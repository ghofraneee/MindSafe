import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mindsafe/core/constants/app_colors.dart';
import 'package:mindsafe/core/utils/extensions.dart';
import 'package:mindsafe/core/widgets/gradient_button.dart';
import 'package:mindsafe/core/widgets/mood_emoji.dart';
import 'package:mindsafe/features/mood/domain/entities/mood_type.dart';
import 'package:mindsafe/features/mood/presentation/providers/mood_provider.dart';
import 'package:mindsafe/features/mood/presentation/widgets/mood_slider_section.dart';

class MoodTrackerScreen extends ConsumerStatefulWidget {
  const MoodTrackerScreen({super.key});

  @override
  ConsumerState<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends ConsumerState<MoodTrackerScreen> {
  MoodType? _selectedMood;
  double _energy = 5;
  double _stress = 5;
  double _sleep = 7;
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _prefillToday());
  }

  void _prefillToday() {
    final today = ref.read(todayMoodProvider);
    if (today != null) {
      setState(() {
        _selectedMood = today.mood;
        _energy = today.energyLevel;
        _stress = today.stressLevel;
        _sleep = today.sleepHours;
        _notesController.text = today.notes ?? '';
      });
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_selectedMood == null) {
      context.showSnack('Please select how you feel today', isError: true);
      return;
    }

    final success = await ref.read(moodNotifierProvider.notifier).saveMood(
          mood: _selectedMood!,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
          energyLevel: _energy,
          stressLevel: _stress,
          sleepHours: _sleep,
        );

    if (!mounted) return;

    if (success) {
      context.showSnack('Mood saved successfully');
    } else {
      context.showSnack(
        ref.read(moodNotifierProvider).errorMessage ?? 'Failed to save mood',
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final moodState = ref.watch(moodNotifierProvider);
    final isDark = context.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Tracker'),
        actions: [
          IconButton(
            tooltip: 'History',
            onPressed: () => context.push('/mood/history'),
            icon: const Icon(Icons.history_rounded),
          ),
        ],
      ),
      body: moodState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: isDark
                          ? AppColors.darkCalmGradient
                          : AppColors.calmGradient,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'How are you feeling?',
                          style: GoogleFonts.fraunces(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateTime.now().formattedLong,
                          style: GoogleFonts.dmSans(
                            color: AppColors.textSecondaryLight,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 24),
                        MoodEmojiPicker(
                          selectedMood: _selectedMood,
                          onMoodSelected: (mood) {
                            setState(() => _selectedMood = mood);
                          },
                          size: 44,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Wellness metrics',
                    style: GoogleFonts.fraunces(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  MoodSliderSection(
                    label: 'Energy level',
                    icon: Icons.bolt_rounded,
                    value: _energy,
                    min: 1,
                    max: 10,
                    divisions: 9,
                    activeColor: AppColors.accent,
                    valueLabel: (v) => '${v.round()}/10',
                    onChanged: (v) => setState(() => _energy = v),
                  ),
                  const SizedBox(height: 12),
                  MoodSliderSection(
                    label: 'Stress level',
                    icon: Icons.psychology_alt_rounded,
                    value: _stress,
                    min: 1,
                    max: 10,
                    divisions: 9,
                    activeColor: AppColors.warning,
                    valueLabel: (v) => '${v.round()}/10',
                    onChanged: (v) => setState(() => _stress = v),
                  ),
                  const SizedBox(height: 12),
                  MoodSliderSection(
                    label: 'Sleep hours',
                    icon: Icons.bedtime_rounded,
                    value: _sleep,
                    min: 0,
                    max: 12,
                    divisions: 24,
                    activeColor: AppColors.primary,
                    valueLabel: (v) => '${v.toStringAsFixed(1)} hrs',
                    onChanged: (v) => setState(() => _sleep = v),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Notes (optional)',
                    style: GoogleFonts.fraunces(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _notesController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'What influenced your mood today?',
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 28),
                  GradientButton(
                    label: moodState.todayMood != null
                        ? 'Update today\'s mood'
                        : 'Save mood',
                    isLoading: moodState.isSaving,
                    onPressed: _save,
                    icon: Icons.check_rounded,
                  ),
                ],
              ),
            ),
    );
  }
}
