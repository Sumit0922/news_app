import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orbit_news/core/constants/app_tokens.dart';
import 'package:orbit_news/core/utils/app_responsive.dart';
import 'package:orbit_news/widgets/app_shimmer.dart';
import 'news_card_frame.dart';

class NewsCardSkeleton extends StatelessWidget {
  const NewsCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final smallGap = AppResponsive.space(AppSpacing.sm);
    final sectionGap = AppResponsive.space(AppSpacing.cardGap);
    final contentPadding = AppResponsive.space(AppSpacing.cardPadding);

    return NewsCardFrame(
      child: AppShimmer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AspectRatio(
              aspectRatio: AppLayout.articleImageAspectRatio,
              child: ColoredBox(color: AppColors.white),
            ),
            Padding(
              padding: EdgeInsets.all(contentPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SkeletonLine(widthFactor: 0.22, height: 11.r),
                  SizedBox(height: smallGap),
                  _SkeletonLine(widthFactor: 0.94, height: 18.r),
                  SizedBox(height: smallGap),
                  _SkeletonLine(widthFactor: 0.70, height: 18.r),
                  SizedBox(height: sectionGap),
                  _SkeletonLine(widthFactor: 1, height: 11.r),
                  SizedBox(height: smallGap),
                  _SkeletonLine(widthFactor: 0.82, height: 11.r),
                  SizedBox(height: 28.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: _SkeletonLine(widthFactor: 0.35, height: 10.r),
                      ),
                      SizedBox(width: smallGap),
                      SizedBox(
                        width: 48,
                        height: 48,
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4.r),
                            child: SizedBox(
                              width: 16.r,
                              height: 22.r,
                              child: const ColoredBox(color: AppColors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewsSkeletonSliver extends StatelessWidget {
  const NewsSkeletonSliver({super.key, this.count = 3});

  final int count;

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: count,
      itemBuilder: (context, index) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const NewsCardSkeleton(),
            if (index < count - 1) AppSpacing.cardGap.verticalSpace,
          ],
        );
      },
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  const _SkeletonLine({required this.widthFactor, required this.height});

  final double widthFactor;
  final double height;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      alignment: AlignmentDirectional.centerStart,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6.r),
        child: SizedBox(
          height: height,
          child: const ColoredBox(color: AppColors.white),
        ),
      ),
    );
  }
}
