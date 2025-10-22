import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF6C5CE7);
  static const Color primaryLight = Color(0xFF9B88FF);
  static const Color primaryDark = Color(0xFF5A4FCF);

  // Secondary Colors
  static const Color secondary = Color(0xFF00CEC9);
  static const Color secondaryLight = Color(0xFF55EFC4);
  static const Color secondaryDark = Color(0xFF00B894);

  // Accent Colors
  static const Color accent = Color(0xFFFF7675);
  static const Color accentLight = Color(0xFFFF9FF3);
  static const Color accentDark = Color(0xFFE84393);

  // Success Colors
  static const Color success = Color(0xFF00B894);
  static const Color successLight = Color(0xFF55EFC4);
  static const Color successDark = Color(0xFF00A085);

  // Warning Colors
  static const Color warning = Color(0xFFFFB74D);
  static const Color warningLight = Color(0xFFFFCC80);
  static const Color warningDark = Color(0xFFFF8A65);

  // Error Colors
  static const Color error = Color(0xFFE57373);
  static const Color errorLight = Color(0xFFFFAB91);
  static const Color errorDark = Color(0xFFE53935);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color greyLight = Color(0xFFF5F5F5);
  static const Color greyDark = Color(0xFF424242);

  // Background Colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF8F9FA);

  // Text Colors
  static const Color textPrimary = Color(0xFF212529);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textDisabled = Color(0xFFADB5BD);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, secondaryLight],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, accentLight],
  );

  // Workout Type Colors
  static const Color cardioColor = Color(0xFFE17055);
  static const Color strengthColor = Color(0xFF6C5CE7);
  static const Color yogaColor = Color(0xFF00B894);
  static const Color hiitColor = Color(0xFFE84393);
  static const Color pilatesColor = Color(0xFF74B9FF);
  static const Color crossfitColor = Color(0xFFFF7675);

  // Meal Type Colors
  static const Color breakfastColor = Color(0xFFFFB74D);
  static const Color lunchColor = Color(0xFF4CAF50);
  static const Color dinnerColor = Color(0xFF9C27B0);
  static const Color snackColor = Color(0xFFFF9800);

  // Progress Colors
  static const Color progressGood = Color(0xFF4CAF50);
  static const Color progressWarning = Color(0xFFFF9800);
  static const Color progressDanger = Color(0xFFF44336);
}
