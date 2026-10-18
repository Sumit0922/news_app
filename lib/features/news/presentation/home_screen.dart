import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orbit_news/core/constants/app_strings.dart';
import 'package:orbit_news/core/constants/app_tokens.dart';
import 'package:orbit_news/core/extensions/context_extensions.dart';
import 'package:orbit_news/core/utils/app_responsive.dart';
import 'package:orbit_news/widgets/app_text.dart';
import 'package:orbit_news/widgets/responsive_body.dart';
import 'package:orbit_news/widgets/state_panel.dart';
import 'feed_view_model.dart';
import 'widgets/article_sliver.dart';
import 'widgets/home_header.dart';
import 'widgets/news_card_skeleton.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _scroll = ScrollController();
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();

    _scroll.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scroll.hasClients || _scroll.position.extentAfter > 480) {
      return;
    }

    final state = ref.read(feedProvider);

    if (state.pageError == null) {
      unawaited(ref.read(feedProvider.notifier).loadMore());
    }
  }

  void _changeSearch(String value) {
    if (_scroll.hasClients) {
      _scroll.jumpTo(0);
    }

    ref.read(feedProvider.notifier).search(value);
  }

  void _clearSearch() {
    _search.clear();
    _changeSearch('');

    unawaited(ref.read(feedProvider.notifier).refresh());
  }

  @override
  void dispose() {
    _scroll.dispose();
    _search.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(feedProvider);
    final vm = ref.read(feedProvider.notifier);

    final gutter = AppResponsive.space(AppSpacing.md);
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final active = TickerMode.valuesOf(context).enabled;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && active) {
        _onScroll();
      }
    });

    return ResponsiveBody(
      maxWidth: AppLayout.feedMaxWidth,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compactHeader =
              constraints.maxHeight < 300 ||
              MediaQuery.viewInsetsOf(context).bottom > 0;

          return Column(
            children: [
              HomeHeader(
                controller: _search,
                compact: compactHeader,
                onChanged: _changeSearch,
                onClear: _clearSearch,
                onSubmitted: () {
                  unawaited(vm.refresh());
                },
              ),
              Divider(
                height: 1,
                color: context.colors.outlineVariant.withValues(alpha: 0.4),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: vm.refresh,
                  color: context.colors.primary,
                  backgroundColor: context.colors.surface,
                  child: CustomScrollView(
                    controller: _scroll,
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      if (state.offline ||
                          state.cacheWriteFailed ||
                          (state.error != null && state.articles.isNotEmpty))
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              gutter,
                              AppResponsive.space(AppSpacing.sm),
                              gutter,
                              0,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  state.offline
                                      ? Icons.cloud_off_rounded
                                      : Icons.info_outline_rounded,
                                  color: context.colors.primary,
                                  size: AppResponsive.icon(20),
                                ),
                                AppSpacing.sm.horizontalSpace,
                                Expanded(
                                  child: AppText(
                                    state.error ??
                                        (state.offline
                                            ? AppStrings.cacheNotice
                                            : AppStrings.persistenceNotice),
                                    variant: AppTextStyle.small,
                                  ),
                                ),
                                IconButton(
                                  tooltip: AppStrings.refresh,
                                  onPressed: vm.refresh,
                                  icon: const Icon(Icons.refresh_rounded),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (state.loading || state.refreshing)
                        SliverPadding(
                          padding: EdgeInsets.fromLTRB(
                            gutter,
                            AppResponsive.space(AppSpacing.cardGap),
                            gutter,
                            bottomInset + AppResponsive.space(AppSpacing.md),
                          ),
                          sliver: const NewsSkeletonSliver(),
                        )
                      else if (state.articles.isEmpty)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: StatePanel(
                            icon: state.error == null
                                ? Icons.travel_explore_rounded
                                : Icons.cloud_off_rounded,
                            title: state.error == null
                                ? AppStrings.noResults
                                : AppStrings.latest,
                            message: state.error ?? AppStrings.noResultsBody,
                            action: AppStrings.retry,
                            onAction: vm.refresh,
                          ),
                        )
                      else ...[
                        SliverPadding(
                          padding: EdgeInsets.fromLTRB(
                            gutter,
                            AppResponsive.space(AppSpacing.cardGap),
                            gutter,
                            0,
                          ),
                          sliver: ArticleSliver(articles: state.articles),
                        ),
                        if (state.loadingMore)
                          SliverPadding(
                            padding: EdgeInsets.fromLTRB(
                              gutter,
                              AppResponsive.space(AppSpacing.cardGap),
                              gutter,
                              0,
                            ),
                            sliver: const NewsSkeletonSliver(count: 2),
                          )
                        else if (state.pageError != null)
                          SliverToBoxAdapter(
                            child: StatePanel(
                              icon: Icons.wifi_off_rounded,
                              title: AppStrings.latest,
                              message: state.pageError!,
                              action: AppStrings.retry,
                              onAction: vm.loadMore,
                            ),
                          )
                        else if (state.hasMore)
                          SliverToBoxAdapter(
                            child: Center(
                              child: TextButton(
                                onPressed: vm.loadMore,
                                child: const Text(AppStrings.loadMore),
                              ),
                            ),
                          )
                        else
                          const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.all(AppSpacing.md),
                              child: AppText(
                                AppStrings.endOfFeed,
                                variant: AppTextStyle.caption,
                                align: TextAlign.center,
                              ),
                            ),
                          ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: bottomInset),
                            child: AppSpacing.md.verticalSpace,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
