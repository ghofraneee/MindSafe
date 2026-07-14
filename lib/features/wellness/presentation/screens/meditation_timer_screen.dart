import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'package:mindsafe/core/constants/app_colors.dart';
import 'package:mindsafe/core/constants/app_constants.dart';
import 'package:mindsafe/features/wellness/presentation/providers/wellness_provider.dart';

class MeditationTimerScreen extends ConsumerStatefulWidget {
  const MeditationTimerScreen({super.key});

  @override
  ConsumerState<MeditationTimerScreen> createState() =>
      _MeditationTimerScreenState();
}

class _MeditationTimerScreenState extends ConsumerState<MeditationTimerScreen> {
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    ref.read(meditationRunningProvider.notifier).state = true;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final remaining = ref.read(meditationRemainingProvider);
      if (remaining <= 1) {
        _complete();
        return;
      }
      ref.read(meditationRemainingProvider.notifier).state = remaining - 1;
    });
  }

  void _pause() {
    ref.read(meditationRunningProvider.notifier).state = false;
    _timer?.cancel();
  }

  void _reset() {
    _pause();
    final total = ref.read(meditationSecondsProvider);
    ref.read(meditationRemainingProvider.notifier).state = total;
  }

  void _complete() {
    _pause();
    ref.read(meditationRemainingProvider.notifier).state = 0;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.spa_rounded, color: AppColors.primary, size: 48),
        title: const Text('Session Complete'),
        content: const Text(
          'Take a gentle breath. You did wonderfully.',
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              _reset();
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final total = ref.watch(meditationSecondsProvider);
    final remaining = ref.watch(meditationRemainingProvider);
    final isRunning = ref.watch(meditationRunningProvider);
    final progress = total > 0 ? (total - remaining) / total : 0.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Meditation')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Text(
              'Find your calm',
              style: GoogleFonts.fraunces(
                fontSize: 26,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Set a timer and breathe mindfully',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6),
                  ),
            ),
            const Spacer(),
            CircularPercentIndicator(
              radius: 130,
              lineWidth: 12,
              percent: progress.clamp(0.0, 1.0),
              animation: true,
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: AppColors.primary,
              backgroundColor: AppColors.primary.withValues(alpha: 0.12),
              center: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatTime(remaining),
                    style: GoogleFonts.fraunces(
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    isRunning ? 'In session' : 'Ready',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _DurationChip(
                  label: '3 min',
                  seconds: 180,
                  selected: total == 180,
                  onTap: () {
                    if (isRunning) return;
                    ref.read(meditationSecondsProvider.notifier).state = 180;
                    ref.read(meditationRemainingProvider.notifier).state = 180;
                  },
                ),
                const SizedBox(width: 8),
                _DurationChip(
                  label: '5 min',
                  seconds: AppConstants.meditationDefaultSeconds,
                  selected: total == AppConstants.meditationDefaultSeconds,
                  onTap: () {
                    if (isRunning) return;
                    ref.read(meditationSecondsProvider.notifier).state =
                        AppConstants.meditationDefaultSeconds;
                    ref.read(meditationRemainingProvider.notifier).state =
                        AppConstants.meditationDefaultSeconds;
                  },
                ),
                const SizedBox(width: 8),
                _DurationChip(
                  label: '10 min',
                  seconds: 600,
                  selected: total == 600,
                  onTap: () {
                    if (isRunning) return;
                    ref.read(meditationSecondsProvider.notifier).state = 600;
                    ref.read(meditationRemainingProvider.notifier).state = 600;
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _reset,
                    icon: const Icon(Icons.restart_alt_rounded),
                    label: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: FilledButton.icon(
                    onPressed: isRunning ? _pause : _start,
                    icon: Icon(
                      isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    ),
                    label: Text(isRunning ? 'Pause' : 'Start'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _DurationChip extends StatelessWidget {
  const _DurationChip({
    required this.label,
    required this.seconds,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int seconds;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.primary.withValues(alpha: 0.15),
      checkmarkColor: AppColors.primary,
    );
  }
}
