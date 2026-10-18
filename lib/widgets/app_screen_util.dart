import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orbit_news/core/constants/app_tokens.dart';

class AppScreenUtil extends StatelessWidget {
  const AppScreenUtil({super.key, required this.builder});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(AppLayout.designWidth, AppLayout.designHeight),
      minTextAdapt: true,
      splitScreenMode: true,
      fontSizeResolver: (fontSize, instance) {
        final scale = instance.scaleWidth
            .clamp(AppLayout.minScale, AppLayout.maxScale)
            .toDouble();

        return fontSize.toDouble() * scale;
      },
      builder: (context, child) {
        return builder(context);
      },
    );
  }
}
