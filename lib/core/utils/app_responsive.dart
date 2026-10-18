import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_tokens.dart';

abstract final class AppResponsive {
  static double space(num value) {
    return value.w
        .clamp(
      value * AppLayout.minScale,
      value * AppLayout.maxScale,
    )
        .toDouble();
  }

  static double radius(num value) {
    return value.r
        .clamp(
      value * AppLayout.minScale,
      value * AppLayout.maxScale,
    )
        .toDouble();
  }

  static double icon(num value) {
    return radius(value);
  }
}