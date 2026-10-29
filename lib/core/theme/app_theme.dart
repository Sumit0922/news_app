import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_tokens.dart';

abstract final class AppTheme {
  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final dark = brightness == Brightness.dark;

    final colors = ColorScheme.fromSeed(
      seedColor: AppColors.seed,
      brightness: brightness,
      surface: dark ? AppColors.darkSurface : AppColors.lightSurface,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colors,
      scaffoldBackgroundColor: colors.surface,
      visualDensity: VisualDensity.compact,
    );

    TextStyle text(
      double size, {
      FontWeight weight = FontWeight.w400,
      double height = 1.45,
      double spacing = 0,
      bool muted = false,
    }) {
      return TextStyle(
        fontSize: size.sp,
        fontWeight: weight,
        height: height,
        letterSpacing: spacing,
        color: muted ? colors.onSurfaceVariant : colors.onSurface,
      );
    }

    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        color: colors.outlineVariant.withValues(alpha: 0.6),
      ),
    );

    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        displaySmall: text(
          AppFontSizes.hero,
          weight: FontWeight.w800,
          height: 1.15,
          spacing: -1,
        ),
        headlineMedium: text(
          AppFontSizes.heading,
          weight: FontWeight.w800,
          height: 1.25,
          spacing: -0.7,
        ),
        titleLarge: text(
          AppFontSizes.title,
          weight: FontWeight.w700,
          height: 1.35,
          spacing: -0.3,
        ),
        titleMedium: text(15, weight: FontWeight.w700, height: 1.35),
        titleSmall: text(13, weight: FontWeight.w700),
        bodyLarge: text(AppFontSizes.body, height: 1.6),
        bodyMedium: text(AppFontSizes.small, height: 1.5, muted: true),
        bodySmall: text(AppFontSizes.caption, muted: true),
        labelLarge: text(12, weight: FontWeight.w700),
        labelMedium: text(11, weight: FontWeight.w600),
        labelSmall: text(
          AppFontSizes.caption,
          weight: FontWeight.w600,
          height: 1.3,
          muted: true,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: text(18, weight: FontWeight.w800, spacing: -0.5),
        iconTheme: IconThemeData(size: 20, color: colors.onSurface),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceContainerLow,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 13,
        ),
        hintStyle: text(12, muted: true),
        labelStyle: text(12, muted: true),
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: colors.primary, width: 1.2),
        ),
        errorBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: colors.error),
        ),
        focusedErrorBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: colors.error, width: 1.2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 44),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          textStyle: text(12, weight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 44),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          textStyle: text(12, weight: FontWeight.w700),
          side: BorderSide(color: colors.primary.withValues(alpha: 0.3)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: text(12, weight: FontWeight.w700),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colors.outlineVariant.withValues(alpha: 0.45),
        thickness: 0.7,
        space: 16,
      ),
    );
  }
}
