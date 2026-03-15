import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static const String _fontFamily = 'Urbanist';

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: _fontFamily,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.primaryLight,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: AppColors.textOnPrimary,
        onSecondary: AppColors.textOnPrimary,
        onSurface: AppColors.textPrimary,
        onError: AppColors.textOnPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.mediumGrey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        showUnselectedLabels: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          textStyle: const TextStyle(
            fontFamily: _fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.border),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          textStyle: const TextStyle(
            fontFamily: _fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        hintStyle: const TextStyle(
          fontFamily: _fontFamily,
          color: AppColors.textHint,
          fontSize: 14,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primary,
        labelStyle: const TextStyle(fontFamily: _fontFamily, fontSize: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide.none,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: _fontFamily, color: AppColors.textPrimary),
        displayMedium: TextStyle(fontFamily: _fontFamily, color: AppColors.textPrimary),
        displaySmall: TextStyle(fontFamily: _fontFamily, color: AppColors.textPrimary),
        headlineLarge: TextStyle(fontFamily: _fontFamily, color: AppColors.textPrimary),
        headlineMedium: TextStyle(fontFamily: _fontFamily, color: AppColors.textPrimary),
        headlineSmall: TextStyle(fontFamily: _fontFamily, color: AppColors.textPrimary),
        titleLarge: TextStyle(fontFamily: _fontFamily, color: AppColors.textPrimary),
        titleMedium: TextStyle(fontFamily: _fontFamily, color: AppColors.textPrimary),
        titleSmall: TextStyle(fontFamily: _fontFamily, color: AppColors.textPrimary),
        bodyLarge: TextStyle(fontFamily: _fontFamily, color: AppColors.textPrimary),
        bodyMedium: TextStyle(fontFamily: _fontFamily, color: AppColors.textPrimary),
        bodySmall: TextStyle(fontFamily: _fontFamily, color: AppColors.textSecondary),
        labelLarge: TextStyle(fontFamily: _fontFamily, color: AppColors.textPrimary),
        labelSmall: TextStyle(fontFamily: _fontFamily, color: AppColors.textHint),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: _fontFamily,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.primaryLight,
        surface: AppColors.darkSurface,
        error: AppColors.error,
        onPrimary: AppColors.textOnPrimary,
        onSecondary: AppColors.textOnPrimary,
        onSurface: AppColors.darkTextPrimary,
        onError: AppColors.textOnPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.darkTextPrimary,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkBackground,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.mediumGrey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        showUnselectedLabels: true,
      ),
      elevatedButtonTheme: lightTheme.elevatedButtonTheme,
      outlinedButtonTheme: lightTheme.outlinedButtonTheme,
      inputDecorationTheme: lightTheme.inputDecorationTheme.copyWith(
        fillColor: AppColors.darkSurface,
        hintStyle: const TextStyle(
          fontFamily: _fontFamily,
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
      ),
      cardTheme: lightTheme.cardTheme.copyWith(
        color: AppColors.darkCard,
      ),
      chipTheme: lightTheme.chipTheme.copyWith(
        backgroundColor: AppColors.darkSurface,
      ),
      dividerTheme: lightTheme.dividerTheme.copyWith(
        color: AppColors.darkBorder,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: _fontFamily, color: AppColors.darkTextPrimary),
        displayMedium: TextStyle(fontFamily: _fontFamily, color: AppColors.darkTextPrimary),
        displaySmall: TextStyle(fontFamily: _fontFamily, color: AppColors.darkTextPrimary),
        headlineLarge: TextStyle(fontFamily: _fontFamily, color: AppColors.darkTextPrimary),
        headlineMedium: TextStyle(fontFamily: _fontFamily, color: AppColors.darkTextPrimary),
        headlineSmall: TextStyle(fontFamily: _fontFamily, color: AppColors.darkTextPrimary),
        titleLarge: TextStyle(fontFamily: _fontFamily, color: AppColors.darkTextPrimary),
        titleMedium: TextStyle(fontFamily: _fontFamily, color: AppColors.darkTextPrimary),
        titleSmall: TextStyle(fontFamily: _fontFamily, color: AppColors.darkTextPrimary),
        bodyLarge: TextStyle(fontFamily: _fontFamily, color: AppColors.darkTextPrimary),
        bodyMedium: TextStyle(fontFamily: _fontFamily, color: AppColors.darkTextPrimary),
        bodySmall: TextStyle(fontFamily: _fontFamily, color: AppColors.darkTextSecondary),
        labelLarge: TextStyle(fontFamily: _fontFamily, color: AppColors.darkTextPrimary),
        labelSmall: TextStyle(fontFamily: _fontFamily, color: AppColors.darkTextSecondary),
      ),
    );
  }
}
