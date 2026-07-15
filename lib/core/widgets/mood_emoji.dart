import 'package:flutter/material.dart';

import 'package:mindsafe/features/mood/domain/entities/mood_type.dart';

/// Displays a mood emoji with a selectable scale animation.
class MoodEmoji extends StatefulWidget {
  const MoodEmoji({
    super.key,
    required this.mood,
    this.selected = false,
    this.size = 48,
    this.onTap,
    this.showLabel = false,
    this.animateOnSelect = true,
  });

  final MoodType mood;
  final bool selected;
  final double size;
  final VoidCallback? onTap;
  final bool showLabel;
  final bool animateOnSelect;

  @override
  State<MoodEmoji> createState() => _MoodEmojiState();
}

class _MoodEmojiState extends State<MoodEmoji>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    if (widget.selected && widget.animateOnSelect) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(MoodEmoji oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selected != oldWidget.selected) {
      if (widget.selected && widget.animateOnSelect) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final emojiSize = widget.selected ? widget.size * 1.1 : widget.size;

    final emojiWidget = AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        final scale = widget.animateOnSelect && widget.selected
            ? _scaleAnimation.value
            : widget.selected
                ? 1.1
                : 1.0;
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: Container(
        width: emojiSize + 16,
        height: emojiSize + 16,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.selected
              ? widget.mood.color.withValues(alpha: 0.2)
              : Colors.transparent,
          border: Border.all(
            color: widget.selected
                ? widget.mood.color
                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
            width: widget.selected ? 2 : 1,
          ),
          boxShadow: widget.selected
              ? [
                  BoxShadow(
                    color: widget.mood.color.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          widget.mood.emoji,
          style: TextStyle(fontSize: emojiSize),
        ),
      ),
    );

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        emojiWidget,
        if (widget.showLabel) ...[
          const SizedBox(height: 8),
          Text(
            widget.mood.label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: widget.selected
                      ? widget.mood.color
                      : Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
                  fontWeight:
                      widget.selected ? FontWeight.w600 : FontWeight.w500,
                ),
          ),
        ],
      ],
    );

    if (widget.onTap != null) {
      return GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: content,
      );
    }

    return content;
  }
}

/// A horizontal row of selectable mood emojis.
class MoodEmojiPicker extends StatelessWidget {
  const MoodEmojiPicker({
    super.key,
    required this.selectedMood,
    required this.onMoodSelected,
    this.size = 40,
    this.showLabels = true,
  });

  final MoodType? selectedMood;
  final ValueChanged<MoodType> onMoodSelected;
  final double size;
  final bool showLabels;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: MoodType.values.map((mood) {
        return MoodEmoji(
          mood: mood,
          size: size,
          selected: selectedMood == mood,
          showLabel: showLabels,
          onTap: () => onMoodSelected(mood),
        );
      }).toList(),
    );
  }
}
