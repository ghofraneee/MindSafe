import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mindsafe/core/constants/app_colors.dart';
import 'package:mindsafe/features/wellness/presentation/providers/wellness_provider.dart';

class CalmingSoundsScreen extends ConsumerStatefulWidget {
  const CalmingSoundsScreen({super.key});

  @override
  ConsumerState<CalmingSoundsScreen> createState() =>
      _CalmingSoundsScreenState();
}

class _CalmingSoundsScreenState extends ConsumerState<CalmingSoundsScreen> {
  final AudioPlayer _player = AudioPlayer();
  CalmingSound? _playing;
  double _volume = 0.7;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _player.setReleaseMode(ReleaseMode.loop);
    _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _playing = null);
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _toggleSound(CalmingSound sound) async {
    if (_playing == sound) {
      await _player.pause();
      setState(() => _playing = null);
      return;
    }

    setState(() {
      _loading = true;
      _playing = sound;
    });

    try {
      await _player.setVolume(_volume);
      await _player.play(AssetSource(sound.assetPath.replaceFirst('assets/', '')));
    } catch (_) {
      if (mounted) {
        setState(() => _playing = null);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${sound.label} audio not found. Add ${sound.assetPath} to assets.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _onVolumeChanged(double value) async {
    setState(() => _volume = value);
    await _player.setVolume(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calming Sounds')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Text(
            'Relax with nature',
            style: GoogleFonts.fraunces(
              fontSize: 26,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Looping ambient sounds to help you unwind',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Volume',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.volume_down_rounded, size: 20),
                      Expanded(
                        child: Slider(
                          value: _volume,
                          onChanged: _onVolumeChanged,
                          activeColor: AppColors.primary,
                        ),
                      ),
                      const Icon(Icons.volume_up_rounded, size: 20),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...CalmingSound.values.map((sound) {
            final isPlaying = _playing == sound;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              color: isPlaying
                  ? AppColors.primary.withValues(alpha: 0.08)
                  : null,
              child: ListTile(
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(sound.icon, color: AppColors.primary),
                ),
                title: Text(
                  sound.label,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(sound.assetPath),
                trailing: _loading && isPlaying
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : IconButton(
                        icon: Icon(
                          isPlaying
                              ? Icons.pause_circle_filled_rounded
                              : Icons.play_circle_fill_rounded,
                          color: AppColors.primary,
                          size: 36,
                        ),
                        onPressed: () => _toggleSound(sound),
                      ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
