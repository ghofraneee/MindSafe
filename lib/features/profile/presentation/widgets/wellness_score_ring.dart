import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'package:mindsafe/core/constants/app_colors.dart';

class WellnessScoreRing extends StatelessWidget {
  const WellnessScoreRing({
    super.key,
    required this.score,
    this.size = 140,
    this.strokeWidth = 10,
  });

  final int score;
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final percent = (score.clamp(0, 100)) / 100;
    final color = _scoreColor(score);

    return CircularPercentIndicator(
      radius: size / 2,
      lineWidth: strokeWidth,
      percent: percent,
      animation: true,
      animationDuration: 1200,
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: color,
      backgroundColor: color.withValues(alpha: 0.15),
      center: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$score%',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
          ),
          Text(
            'Wellness',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                ),
          ),
        ],
      ),
    );
  }

  Color _scoreColor(int value) {
    if (value >= 80) return AppColors.moodAmazing;
    if (value >= 60) return AppColors.primary;
    if (value >= 40) return AppColors.warning;
    return AppColors.moodSad;
  }
}
