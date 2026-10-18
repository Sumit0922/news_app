import 'package:flutter/material.dart';

import '../../core/extensions/context_extensions.dart';

enum AppTextStyle { hero, heading, title, body, small, caption }

class AppText extends StatelessWidget {
  const AppText(
    this.text, {
    super.key,
    this.variant = AppTextStyle.body,
    this.maxLines,
    this.color,
    this.align,
    this.weight,
  });
  final String text;
  final AppTextStyle variant;
  final int? maxLines;
  final Color? color;
  final TextAlign? align;
  final FontWeight? weight;
  @override
  Widget build(BuildContext context) {
    final styles = context.textTheme;
    final style = switch (variant) {
      AppTextStyle.hero => styles.displaySmall,
      AppTextStyle.heading => styles.headlineMedium,
      AppTextStyle.title => styles.titleLarge,
      AppTextStyle.body => styles.bodyLarge,
      AppTextStyle.small => styles.bodyMedium,
      AppTextStyle.caption => styles.labelSmall,
    };
    return Text(
      text,
      maxLines: maxLines,
      overflow: maxLines == null ? null : TextOverflow.ellipsis,
      textAlign: align,
      style: style?.copyWith(color: color, fontWeight: weight),
    );
  }
}
