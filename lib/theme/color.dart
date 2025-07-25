import 'package:flutter/material.dart';

@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color primaryGreen;
  final Color bitcoinOrange;
  final Color deepBlue;
  final Color backgroundDark;
  final Color backgroundLight;
  final Color textPrimary;
  final Color textSecondary;
  final Color cardBackground;

  const AppColorsExtension({
    required this.primaryGreen,
    required this.bitcoinOrange,
    required this.deepBlue,
    required this.backgroundDark,
    required this.backgroundLight,
    required this.textPrimary,
    required this.textSecondary,
    required this.cardBackground,
  });

  factory AppColorsExtension.light() {
    return const AppColorsExtension(
      primaryGreen: Color(0xFF009B3A),
      bitcoinOrange: Color(0xFFF7931A),
      deepBlue: Color(0xFF1E3A8A),
      backgroundDark: Colors.black,
      backgroundLight: Colors.white,
      textPrimary: Colors.black,
      textSecondary: Colors.grey,
      cardBackground: Color(0xFFF5F5F5),
    );
  }

  factory AppColorsExtension.dark() {
    return const AppColorsExtension(
      primaryGreen: Color(0xFF4CAF50),
      bitcoinOrange: Color(0xFFFFB74D),
      deepBlue: Color(0xFF3F51B5),
      backgroundDark: Colors.black,
      backgroundLight: Color(0xFF121212),
      textPrimary: Colors.white,
      textSecondary: Colors.grey,
      cardBackground: Color(0xFF1E1E1E),
    );
  }

  @override
  ThemeExtension<AppColorsExtension> copyWith({
    Color? primaryGreen,
    Color? bitcoinOrange,
    Color? deepBlue,
    Color? backgroundDark,
    Color? backgroundLight,
    Color? textPrimary,
    Color? textSecondary,
    Color? cardBackground,
  }) {
    return AppColorsExtension(
      primaryGreen: primaryGreen ?? this.primaryGreen,
      bitcoinOrange: bitcoinOrange ?? this.bitcoinOrange,
      deepBlue: deepBlue ?? this.deepBlue,
      backgroundDark: backgroundDark ?? this.backgroundDark,
      backgroundLight: backgroundLight ?? this.backgroundLight,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      cardBackground: cardBackground ?? this.cardBackground,
    );
  }

  @override
  ThemeExtension<AppColorsExtension> lerp(
    covariant ThemeExtension<AppColorsExtension>? other,
    double t,
  ) {
    if (other is! AppColorsExtension) return this;
    
    return AppColorsExtension(
      primaryGreen: Color.lerp(primaryGreen, other.primaryGreen, t)!,
      bitcoinOrange: Color.lerp(bitcoinOrange, other.bitcoinOrange, t)!,
      deepBlue: Color.lerp(deepBlue, other.deepBlue, t)!,
      backgroundDark: Color.lerp(backgroundDark, other.backgroundDark, t)!,
      backgroundLight: Color.lerp(backgroundLight, other.backgroundLight, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
    );
  }
}
