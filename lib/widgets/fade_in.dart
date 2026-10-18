import 'package:flutter/material.dart';

import '../../core/constants/app_config.dart';
import '../../core/extensions/context_extensions.dart';

class FadeIn extends StatelessWidget {
  const FadeIn({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    if (context.reduceMotion) return child;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: AppDurations.normal,
      child: child,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 12 * (1 - value)),
          child: child,
        ),
      ),
    );
  }
}
