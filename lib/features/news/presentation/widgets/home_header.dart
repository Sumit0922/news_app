import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orbit_news/core/constants/app_strings.dart';
import 'package:orbit_news/core/constants/app_tokens.dart';
import 'package:orbit_news/core/utils/app_responsive.dart';
import 'package:orbit_news/widgets/app_text.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
    required this.onSubmitted,
    this.compact = false,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final VoidCallback onSubmitted;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppResponsive.space(AppSpacing.md),
        AppResponsive.space(AppSpacing.uz),
        AppResponsive.space(AppSpacing.md),
        AppResponsive.space(AppSpacing.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!compact) ...[
            const AppText(AppStrings.latest, variant: AppTextStyle.heading),
            AppSpacing.xs.verticalSpace,
            const AppText(AppStrings.feedSubtitle, variant: AppTextStyle.small),
            AppSpacing.sm.verticalSpace,
          ],
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, child) {
              return TextField(
                controller: controller,
                onChanged: onChanged,
                onSubmitted: (_) => onSubmitted(),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: AppStrings.search,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppResponsive.space(AppSpacing.md),
                    vertical: AppResponsive.space(AppSpacing.cardGap),
                  ),
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: value.text.isEmpty
                      ? null
                      : IconButton(
                          tooltip: AppStrings.clearSearch,
                          onPressed: onClear,
                          icon: const Icon(Icons.close_rounded),
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
