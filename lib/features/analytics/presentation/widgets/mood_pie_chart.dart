import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:mindsafe/core/constants/app_colors.dart';
import 'package:mindsafe/features/mood/domain/entities/mood_type.dart';

class MoodPieChart extends StatefulWidget {
  const MoodPieChart({
    super.key,
    required this.distribution,
    this.size = 180,
  });

  final Map<MoodType, int> distribution;
  final double size;

  @override
  State<MoodPieChart> createState() => _MoodPieChartState();
}

class _MoodPieChartState extends State<MoodPieChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int? _touchedIndex;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.distribution.values.fold<int>(0, (s, v) => s + v);

    if (total == 0) {
      return SizedBox(
        height: widget.size,
        child: Center(
          child: Text(
            'No distribution data yet',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.5),
                ),
          ),
        ),
      );
    }

    final sections = <PieChartSectionData>[];
    var index = 0;
    for (final mood in MoodType.values) {
      final count = widget.distribution[mood] ?? 0;
      if (count == 0) {
        index++;
        continue;
      }
      final isTouched = _touchedIndex == index;
      sections.add(
        PieChartSectionData(
          value: count.toDouble() * _controller.value,
          color: mood.color,
          title: isTouched ? '${((count / total) * 100).round()}%' : '',
          radius: isTouched ? 58 : 52,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      );
      index++;
    }

    return Column(
      children: [
        SizedBox(
          height: widget.size,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 36,
                  sections: sections,
                  pieTouchData: PieTouchData(
                    touchCallback: (event, response) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            response == null ||
                            response.touchedSection == null) {
                          _touchedIndex = null;
                          return;
                        }
                        _touchedIndex =
                            response.touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: MoodType.values.map((mood) {
            final count = widget.distribution[mood] ?? 0;
            if (count == 0) return const SizedBox.shrink();
            return _LegendChip(mood: mood, count: count);
          }).toList(),
        ),
      ],
    );
  }
}

class _LegendChip extends StatelessWidget {
  const _LegendChip({required this.mood, required this.count});

  final MoodType mood;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: mood.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: mood.color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(mood.emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text(
            '${mood.label} ($count)',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryDark,
                ),
          ),
        ],
      ),
    );
  }
}
