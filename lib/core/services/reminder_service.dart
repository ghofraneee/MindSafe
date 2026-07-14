import 'package:flutter/foundation.dart';

/// Local mood reminder scheduler (simulated — no push server).
///
/// In production this would integrate with `flutter_local_notifications`.
/// Here we persist preferred reminder times and expose scheduling hooks
/// so Settings → Mood reminders stays fully functional in the UI layer.
class ReminderService {
  ReminderService();

  bool _enabled = false;
  TimeOfDayData _time = const TimeOfDayData(hour: 20, minute: 0);

  bool get enabled => _enabled;
  TimeOfDayData get scheduledTime => _time;

  Future<void> setEnabled(bool value) async {
    _enabled = value;
    if (kDebugMode) {
      debugPrint(
        value
            ? 'Mood reminder enabled for ${_time.format()}'
            : 'Mood reminder disabled',
      );
    }
  }

  Future<void> setTime({required int hour, required int minute}) async {
    _time = TimeOfDayData(hour: hour, minute: minute);
    if (_enabled && kDebugMode) {
      debugPrint('Mood reminder rescheduled to ${_time.format()}');
    }
  }
}

class TimeOfDayData {
  const TimeOfDayData({required this.hour, required this.minute});

  final int hour;
  final int minute;

  String format() {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
