import 'package:flutter/material.dart';

abstract final class AppColors {
  static const seed = Color(0xFF366953);
  static const lightSurface = Color(0xFFF8F8F3);
  static const darkSurface = Color(0xFF111A17);
  static const ink = Color(0xFF182B23);
  static const muted = Color(0xFF63756A);
  static const accent = Color(0xFFD4E7AF);
  static const white = Colors.white;
  static const transparent = Colors.transparent;
}

abstract final class AppFontSizes {
  static const caption = 12.0;
  static const small = 14.0;
  static const body = 16.0;
  static const title = 20.0;
  static const heading = 28.0;
  static const hero = 38.0;
}

abstract final class AppSpacing {
  static const uz = 0.0;
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;

  static const radius = 24.0;

  // Keep layout breakpoints in logical pixels.
  static const maxWidth = 1120.0;
  static const compactWidth = 700.0;
  static const cardPadding = 14.0;
  static const cardGap = 12.0;
}

abstract final class AppLayout {
  static const designWidth = 390.0;
  static const designHeight = 844.0;

  static const minScale = 0.90;
  static const maxScale = 1.15;
  static const feedMaxWidth = 680.0;
  static const articleImageAspectRatio = 16 / 9;
}
