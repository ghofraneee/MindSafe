import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mindsafe/core/constants/app_colors.dart';
import 'package:mindsafe/features/wellness/presentation/providers/wellness_provider.dart';

class BreathingExerciseScreen extends ConsumerStatefulWidget {
  const BreathingExerciseScreen({super.key});

  @override
  ConsumerState<BreathingExerciseScreen> createState() =>
      _BreathingExerciseScreenState();
}

class _BreathingExerciseScreenState
    extends ConsumerState<BreathingExerciseScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  Timer? _phaseTimer;
  int _phaseIndex = 0;

  static const _phases = [
    (BreathingPhase.inhale, 'Breathe In', 4),
    (BreathingPhase.holdIn, 'Hold', 4),
    (BreathingPhase.exhale, 'Breathe Out', 4),
    (BreathingPhase.holdOut, 'Hold', 4),
  ];

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
      lowerBound: 0.6,
      upperBound: 1.0,
    );
  }

  @override
  void dispose() {
    _phaseTimer?.cancel();
    _scaleController.dispose();
    super.dispose();
  }

  void _start() {
    ref.read(breathingActiveProvider.notifier).state = true;
    _runPhase();
  }

  void _pause() {
    ref.read(breathingActiveProvider.notifier).state = false;
    _phaseTimer?.cancel();
    _scaleController.stop();
  }

  void _runPhase() {
    if (!ref.read(breathingActiveProvider)) return;

    final (phase, label, seconds) = _phases[_phaseIndex];
    ref.read(breathingPhaseProvider.notifier).state = phase;

    _scaleController.duration = Duration(seconds: seconds);
    if (phase == BreathingPhase.inhale) {
      _scaleController.forward(from: _scaleController.value);
    } else if (phase == BreathingPhase.exhale) {
      _scaleController.reverse(from: _scaleController.value);
    }

    _phaseTimer?.cancel();
    _phaseTimer = Timer(Duration(seconds: seconds), () {
      if (!mounted || !ref.read(breathingActiveProvider)) return;
      setState(() => _phaseIndex = (_phaseIndex + 1) % _phases.length);
      _runPhase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isActive = ref.watch(breathingActiveProvider);
    final phase = ref.watch(breathingPhaseProvider);
    final label = _phases.firstWhere((p) => p.$1 == phase).$2;

    return Scaffold(
      appBar: AppBar(title: const Text('Box Breathing')),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkCalmGradient
              : AppColors.calmGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 24),
              Text(
                '4-4-4-4 Box Breathing',
                style: GoogleFonts.fraunces(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Inhale · Hold · Exhale · Hold',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
                    ),
              ),
              const Spacer(),
              AnimatedBuilder(
                animation: _scaleController,
                builder: (context, child) {
                  final size = 200 * _scaleController.value;
                  return Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.primaryGradient,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          blurRadius: 40,
                          spreadRadius: 8 * _scaleController.value,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        label,
                        style: GoogleFonts.dmSans(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(32),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: isActive ? _pause : null,
                        icon: const Icon(Icons.pause_rounded),
                        label: const Text('Pause'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: isActive ? null : _start,
                        icon: Icon(isActive ? Icons.pause : Icons.play_arrow_rounded),
                        label: Text(isActive ? 'Running' : 'Start'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
