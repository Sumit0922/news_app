import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:orbit_news/core/constants/app_tokens.dart';
import 'package:orbit_news/core/extensions/context_extensions.dart';
import 'package:orbit_news/core/utils/app_responsive.dart';
import 'package:orbit_news/widgets/app_text.dart';

import '../../domain/article.dart';
import '../bookmark_view_model.dart';
import 'article_image.dart';
import 'bookmark_button.dart';
import 'news_card_frame.dart';

class ArticleCard extends ConsumerWidget {
  const ArticleCard({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(
      bookmarkProvider.select(
        (state) => state.articles
            .where((value) => value.article.id == article.id)
            .firstOrNull,
      ),
    );

    return NewsCardFrame(
      onTap: () {
        context.push('/article/${article.id}', extra: article);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ArticleImage(
            url: article.imageUrl,
            bytes: saved?.thumbnail,
            aspectRatio: AppLayout.articleImageAspectRatio,
          ),
          Padding(
            padding: EdgeInsets.all(
              AppResponsive.space(AppSpacing.cardPadding),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  article.source,
                  variant: AppTextStyle.caption,
                  color: context.colors.primary,
                ),
                AppSpacing.sm.verticalSpace,
                AppText(
                  article.title,
                  variant: AppTextStyle.title,
                  maxLines: 2,
                ),
                if (article.summary.isNotEmpty) ...[
                  AppSpacing.sm.verticalSpace,
                  AppText(
                    article.summary,
                    variant: AppTextStyle.small,
                    maxLines: 2,
                  ),
                ],
                AppSpacing.xs.verticalSpace,
                Row(
                  children: [
                    Expanded(
                      child: AppText(
                        article.publishedAt.readableDate,
                        variant: AppTextStyle.caption,
                      ),
                    ),
                    AppSpacing.sm.horizontalSpace,
                    BookmarkButton(article: article),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
