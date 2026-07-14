import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:mindsafe/core/constants/app_colors.dart';

/// [BuildContext] convenience extensions.
extension BuildContextX on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => theme.colorScheme;

  TextTheme get textTheme => theme.textTheme;

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get screenSize => mediaQuery.size;

  double get screenWidth => screenSize.width;

  double get screenHeight => screenSize.height;

  bool get isDarkMode => theme.brightness == Brightness.dark;

  void showSnack(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    Color? backgroundColor,
    bool isError = false,
  }) {
    final messenger = ScaffoldMessenger.of(this);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
        backgroundColor: backgroundColor ??
            (isError ? AppColors.error : AppColors.primary),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

/// [DateTime] formatting and greeting helpers.
extension DateTimeX on DateTime {
  String get greeting {
    final hour = this.hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  String get formattedShort => DateFormat('MMM d').format(this);

  String get formattedLong => DateFormat('EEEE, MMMM d, yyyy').format(this);

  String get formattedTime => DateFormat('h:mm a').format(this);

  int get dayOfYear {
    final startOfYear = DateTime(year);
    return difference(startOfYear).inDays + 1;
  }
}

/// [String] text manipulation helpers.
extension StringX on String {
  String get capitalize {
    if (isEmpty) {
      return this;
    }
    if (length == 1) {
      return toUpperCase();
    }
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String get capitalizeWords {
    if (isEmpty) {
      return this;
    }
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  String get trimmedOrEmpty => trim();
}
