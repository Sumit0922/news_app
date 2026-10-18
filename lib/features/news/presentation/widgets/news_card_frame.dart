import 'package:flutter/material.dart';

import 'package:orbit_news/core/constants/app_tokens.dart';
import 'package:orbit_news/core/utils/app_responsive.dart';

class NewsCardFrame extends StatelessWidget {
  const NewsCardFrame({super.key, required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      color: colors.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppResponsive.radius(AppSpacing.radius),
        ),
        side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: onTap == null ? child : InkWell(onTap: onTap, child: child),
    );
  }
}
