import 'package:flutter/material.dart';

class AppColors {
  static const Color primary =
      Color(0xFFE64A19); // Color naranja para el restaurante
  static const Color primaryLight = Color(0xFFFFCCBC);
  static const Color primaryDark = Color(0xFFBF360C);
  static const Color background = Color(0xFFFFF3E0); // Fondo crema
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFD32F2F);
  static const Color onPrimary = Colors.white;
  static const Color onBackground = Colors.black87;
  static const Color onSurface = Colors.black87;
  static const Color onError = Colors.white;
}

class AppTypography {
  static const String fontFamily = 'Roboto';

  static const TextStyle headline1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryDark,
  );

  static const TextStyle headline2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryDark,
  );

  static const TextStyle bodyText1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    color: AppColors.onBackground,
  );
}
