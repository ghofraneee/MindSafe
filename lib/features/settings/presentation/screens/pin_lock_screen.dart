import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mindsafe/core/constants/app_colors.dart';
import 'package:mindsafe/features/settings/presentation/providers/settings_provider.dart';

enum PinLockMode { setPin, confirmPin, enterPin }

class PinLockScreen extends ConsumerStatefulWidget {
  const PinLockScreen({
    super.key,
    this.mode = PinLockMode.enterPin,
    this.onSuccess,
  });

  final PinLockMode mode;
  final VoidCallback? onSuccess;

  @override
  ConsumerState<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends ConsumerState<PinLockScreen> {
  String _pin = '';
  String? _firstPin;
  PinLockMode _currentMode = PinLockMode.enterPin;
  String? _errorMessage;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _currentMode = widget.mode;
    _initMode();
  }

  Future<void> _initMode() async {
    if (widget.mode != PinLockMode.enterPin) return;
    final hasPin = await ref.read(settingsNotifierProvider.notifier).hasPin();
    if (!hasPin && mounted) {
      setState(() => _currentMode = PinLockMode.setPin);
    }
  }

  void _onDigit(String digit) {
    if (_pin.length >= 4) return;
    HapticFeedback.lightImpact();
    setState(() {
      _pin += digit;
      _errorMessage = null;
    });
    if (_pin.length == 4) {
      _submitPin();
    }
  }

  void _onBackspace() {
    if (_pin.isEmpty) return;
    HapticFeedback.selectionClick();
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  Future<void> _submitPin() async {
    setState(() => _loading = true);
    final notifier = ref.read(settingsNotifierProvider.notifier);

    try {
      if (_currentMode == PinLockMode.setPin) {
        setState(() {
          _firstPin = _pin;
          _pin = '';
          _currentMode = PinLockMode.confirmPin;
          _loading = false;
        });
        return;
      }

      if (_currentMode == PinLockMode.confirmPin) {
        if (_pin != _firstPin) {
          setState(() {
            _errorMessage = 'PINs do not match. Try again.';
            _pin = '';
            _firstPin = null;
            _currentMode = PinLockMode.setPin;
            _loading = false;
          });
          return;
        }
        await notifier.setPin(_pin);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('PIN set successfully')),
          );
          widget.onSuccess?.call();
          context.pop(true);
        }
        return;
      }

      final valid = await notifier.verifyPin(_pin);
      if (!valid) {
        setState(() {
          _errorMessage = 'Incorrect PIN';
          _pin = '';
          _loading = false;
        });
        return;
      }
      widget.onSuccess?.call();
      if (mounted) context.pop(true);
    } catch (_) {
      setState(() {
        _errorMessage = 'Something went wrong';
        _pin = '';
        _loading = false;
      });
    }
  }

  String get _title => switch (_currentMode) {
        PinLockMode.setPin => 'Create PIN',
        PinLockMode.confirmPin => 'Confirm PIN',
        PinLockMode.enterPin => 'Enter PIN',
      };

  String get _subtitle => switch (_currentMode) {
        PinLockMode.setPin => 'Choose a 4-digit PIN to secure MindSafe',
        PinLockMode.confirmPin => 'Re-enter your PIN to confirm',
        PinLockMode.enterPin => 'Enter your 4-digit PIN to continue',
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PIN Lock'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(false),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.primaryGradient,
                ),
                child: const Icon(
                  Icons.lock_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                _title,
                style: GoogleFonts.fraunces(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _subtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
                    ),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (i) {
                  final filled = i < _pin.length;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: filled
                          ? AppColors.primary
                          : Theme.of(context)
                              .colorScheme
                              .outline
                              .withValues(alpha: 0.4),
                    ),
                  );
                }),
              ),
              if (_loading) ...[
                const SizedBox(height: 24),
                const CircularProgressIndicator(color: AppColors.primary),
              ],
              const Spacer(),
              _PinPad(
                onDigit: _onDigit,
                onBackspace: _onBackspace,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _PinPad extends StatelessWidget {
  const _PinPad({
    required this.onDigit,
    required this.onBackspace,
  });

  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;

  @override
  Widget build(BuildContext context) {
    final keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', '⌫'];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.4,
      ),
      itemCount: keys.length,
      itemBuilder: (context, index) {
        final key = keys[index];
        if (key.isEmpty) return const SizedBox.shrink();

        if (key == '⌫') {
          return _PinKey(
            label: key,
            onTap: onBackspace,
            isAction: true,
          );
        }

        return _PinKey(
          label: key,
          onTap: () => onDigit(key),
        );
      },
    );
  }
}

class _PinKey extends StatelessWidget {
  const _PinKey({
    required this.label,
    required this.onTap,
    this.isAction = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool isAction;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isAction
                ? Colors.transparent
                : AppColors.primary.withValues(alpha: 0.06),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: isAction ? 22 : 28,
              fontWeight: FontWeight.w600,
              color: isAction
                  ? AppColors.primary
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
