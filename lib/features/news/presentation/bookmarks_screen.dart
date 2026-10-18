import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orbit_news/widgets/app_text.dart';
import 'package:orbit_news/widgets/responsive_body.dart';
import 'package:orbit_news/widgets/state_panel.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_tokens.dart';
import '../../../core/utils/app_responsive.dart';
import 'bookmark_view_model.dart';
import 'widgets/article_sliver.dart';

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(bookmarkProvider.select((state) => state.articles));

    return ResponsiveBody(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only( left: AppResponsive.space(AppSpacing.lg) , bottom: AppResponsive.space(AppSpacing.lg)),
            sliver: const SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(AppStrings.savedTitle, variant: AppTextStyle.heading),
                  SizedBox(height: AppSpacing.xs),
                  AppText(
                    AppStrings.savedSubtitle,
                    variant: AppTextStyle.small,
                  ),
                ],
              ),
            ),
          ),
          if (saved.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: StatePanel(
                icon: Icons.bookmarks_outlined,
                title: AppStrings.noSaved,
                message: AppStrings.noSavedBody,
              ),
            )
          else
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: AppResponsive.space(AppSpacing.lg),
              ),
              sliver: ArticleSliver(
                articles: saved.map((value) => value.article).toList(),
              ),
            ),
          if (saved.isNotEmpty)
            SliverToBoxAdapter(
              child: SizedBox(
                height:
                    MediaQuery.paddingOf(context).bottom +
                    AppResponsive.space(24),
              ),
            ),
        ],
      ),
    );
  }
}
