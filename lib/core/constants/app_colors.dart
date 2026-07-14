import 'package:flutter/material.dart';

/// Brand color palette — calm teal/ocean wellness direction.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF0D7377);
  static const Color primaryLight = Color(0xFF14919B);
  static const Color primaryDark = Color(0xFF095456);
  static const Color secondary = Color(0xFF212E54);
  static const Color accent = Color(0xFF32E0C4);

  static const Color backgroundLight = Color(0xFFF5F9FA);
  static const Color backgroundDark = Color(0xFF0B1215);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF152028);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1A2830);

  static const Color moodAmazing = Color(0xFF2ECC71);
  static const Color moodGood = Color(0xFF58D68D);
  static const Color moodNeutral = Color(0xFFF4D03F);
  static const Color moodSad = Color(0xFFE67E22);
  static const Color moodVeryBad = Color(0xFFE74C3C);

  static const Color success = Color(0xFF27AE60);
  static const Color warning = Color(0xFFF39C12);
  static const Color error = Color(0xFFE74C3C);
  static const Color info = Color(0xFF3498DB);

  static const Color textPrimaryLight = Color(0xFF1A2B2D);
  static const Color textSecondaryLight = Color(0xFF5A6F72);
  static const Color textPrimaryDark = Color(0xFFE8F4F5);
  static const Color textSecondaryDark = Color(0xFF9BB0B3);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0D7377), Color(0xFF14919B), Color(0xFF32E0C4)],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0B3D40), Color(0xFF0D7377), Color(0xFF1A9B95)],
  );

  static const LinearGradient calmGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE8F6F7), Color(0xFFD4EFF1), Color(0xFFB8E4E8)],
  );

  static const LinearGradient darkCalmGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0B1215), Color(0xFF152028), Color(0xFF0D373A)],
  );
}
