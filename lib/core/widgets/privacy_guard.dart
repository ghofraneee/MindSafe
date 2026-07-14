import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:mindsafe/core/services/privacy_service.dart';
import 'package:mindsafe/features/authentication/presentation/providers/auth_provider.dart';
import 'package:mindsafe/features/settings/presentation/providers/settings_provider.dart';
import 'package:mindsafe/features/settings/presentation/screens/pin_lock_screen.dart';

/// Wraps authenticated app content with inactivity lock and background privacy.
class PrivacyGuard extends ConsumerStatefulWidget {
  const PrivacyGuard({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  ConsumerState<PrivacyGuard> createState() => _PrivacyGuardState();
}

class _PrivacyGuardState extends ConsumerState<PrivacyGuard> {
  PrivacyService? _privacyService;
  bool _isLocked = false;
  bool _pinEnabled = false;

  @override
  void dispose() {
    _privacyService?.dispose();
    super.dispose();
  }

  void _setupPrivacyService(bool pinEnabled) {
    if (!pinEnabled) {
      _privacyService?.dispose();
      _privacyService = null;
      if (_isLocked) {
        setState(() => _isLocked = false);
      }
      return;
    }

    if (_privacyService != null) return;

    _privacyService = PrivacyService(
      onLockRequired: _handleLockRequired,
      onAutoLogout: _handleAutoLogout,
    )..start();
  }

  void _handleLockRequired() {
    if (!mounted || !_pinEnabled) return;
    setState(() => _isLocked = true);
  }

  Future<void> _handleAutoLogout() async {
    if (!mounted) return;
    await ref.read(authNotifierProvider.notifier).logout();
    if (mounted) {
      context.go('/login');
    }
  }

  void _onUnlock() {
    _privacyService?.unlock();
    setState(() => _isLocked = false);
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsNotifierProvider).valueOrNull;
    final pinEnabled = settings?.pinEnabled ?? false;

    if (pinEnabled != _pinEnabled) {
      _pinEnabled = pinEnabled;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _setupPrivacyService(pinEnabled);
      });
    }

    if (!pinEnabled) {
      return widget.child;
    }

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _privacyService?.recordActivity(),
      onPointerMove: (_) => _privacyService?.recordActivity(),
      onPointerUp: (_) => _privacyService?.recordActivity(),
      child: Stack(
        fit: StackFit.expand,
        children: [
          widget.child,
          if (_isLocked)
            Positioned.fill(
              child: Material(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: PinLockScreen(
                  mode: PinLockMode.enterPin,
                  onSuccess: _onUnlock,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
