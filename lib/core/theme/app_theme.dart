import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_tokens.dart';
import '../utils/app_responsive.dart';

abstract final class AppTheme {
  static ThemeData get light => _build(Brightness.light);

  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.seed,
      brightness: brightness,
      surface: isDark ? AppColors.darkSurface : AppColors.lightSurface,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
    );

    return base.copyWith(
      // Explicit font sizes are scaled individually.
      textTheme: base.textTheme.copyWith(
        displaySmall: TextStyle(
          fontSize: AppFontSizes.hero.sp,
          fontWeight: FontWeight.w800,
          height: 1.12,
          color: scheme.onSurface,
          letterSpacing: -1.4,
        ),
        headlineMedium: TextStyle(
          fontSize: AppFontSizes.heading.sp,
          fontWeight: FontWeight.w800,
          height: 1.25,
          color: scheme.onSurface,
          letterSpacing: -0.8,
        ),
        titleLarge: TextStyle(
          fontSize: AppFontSizes.title.sp,
          fontWeight: FontWeight.w700,
          height: 1.35,
          color: scheme.onSurface,
        ),
        bodyLarge: TextStyle(
          fontSize: AppFontSizes.body.sp,
          height: 1.65,
          color: scheme.onSurface,
        ),
        bodyMedium: TextStyle(
          fontSize: AppFontSizes.small.sp,
          height: 1.5,
          color: scheme.onSurfaceVariant,
        ),
        labelSmall: TextStyle(
          fontSize: AppFontSizes.caption.sp,
          fontWeight: FontWeight.w600,
          height: 1.25,
          color: scheme.onSurfaceVariant,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
        contentPadding: EdgeInsets.all(AppResponsive.space(AppSpacing.md)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppResponsive.radius(AppSpacing.md),
          ),
          borderSide: BorderSide.none,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: AppResponsive.space(AppSpacing.lg),
            vertical: AppResponsive.space(AppSpacing.md),
          ),
          textStyle: TextStyle(
            fontSize: AppFontSizes.body.sp,
            fontWeight: FontWeight.w700,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppResponsive.radius(AppSpacing.md),
            ),
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        surfaceTintColor: AppColors.transparent,
        centerTitle: false,
      ),
    );
  }
}
