import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_tokens.dart';
import '../../../widgets/responsive_body.dart';
import '../../../widgets/state_panel.dart';
import '../domain/news_category.dart';
import 'feed_view_model.dart';
import 'widgets/article_sliver.dart';
import 'widgets/news_card_skeleton.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _scroll = ScrollController();
  final _search = TextEditingController();
  final _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    _search.text = ref.read(feedProvider).query;
    _scroll.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scroll.hasClients || _scroll.position.extentAfter > 350) {
      return;
    }

    final state = ref.read(feedProvider);

    if (state.pageError == null) {
      unawaited(ref.read(feedProvider.notifier).loadMore());
    }
  }

  void _scrollToTop() {
    if (_scroll.hasClients && _scroll.offset != 0) {
      _scroll.jumpTo(0);
    }
  }

  void _changeSearch(String value) {
    ref.read(feedProvider.notifier).search(value);
    _scrollToTop();
  }

  void _submitSearch() {
    final vm = ref.read(feedProvider.notifier);

    vm.search(_search.text);

    // Runs the pending search immediately instead of waiting
    // for the typing debounce.
    unawaited(vm.refresh(force: false));

    _searchFocus.unfocus();
  }

  void _clearSearch() {
    _searchFocus.unfocus();
    _search.clear();
    ref.read(feedProvider.notifier).clearSearch();
    _scrollToTop();

    // Clearing the query should not dismiss the keyboard.
    _searchFocus.requestFocus();
  }

  void _selectCategory(NewsCategory category) {

    _searchFocus.unfocus();
    if (category == ref.read(feedProvider).category) return;

    // The view model retains the current query and applies
    // the newly selected category.
    ref.read(feedProvider.notifier).selectCategory(category);
    _scrollToTop();

    // Do not unfocus the search field here.
  }

  @override
  void dispose() {
    _scroll
      ..removeListener(_onScroll)
      ..dispose();

    _search.dispose();
    _searchFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(feedProvider);
    final vm = ref.read(feedProvider.notifier);

    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    final showSkeleton = state.loading || state.refreshing;

    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;

    final textScale = MediaQuery.textScalerOf(context).scale(12) / 12;

    final bottomSpace = keyboardOpen
        ? 20.0
        : MediaQuery.paddingOf(context).bottom +
              110 +
              (textScale > 1 ? (textScale - 1) * 32 : 0);

    return ResponsiveBody(
      maxWidth: AppLayout.feedMaxWidth,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = keyboardOpen || constraints.maxHeight < 420;

          return Column(
            children: [
              ColoredBox(
                color: colors.surface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Always retain this slot in the tree.
                    // Only its contents and height change.
                    AnimatedSize(
                      duration: reduceMotion
                          ? Duration.zero
                          : const Duration(milliseconds: 180),
                      curve: Curves.easeOutCubic,
                      alignment: Alignment.topLeft,
                      child: compact
                          ? const SizedBox(width: double.infinity, height: 4)
                          : Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'THE DAILY BRIEF',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: colors.primary,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    AppStrings.latest,
                                    style: theme.textTheme.headlineMedium,
                                  ),
                                ],
                              ),
                            ),
                    ),

                    // This field keeps the same parent, position,
                    // controller, key, and FocusNode during resizing.
                    Padding(
                      key: const ValueKey('discover-search-slot'),
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _search,
                        builder: (context, value, child) {
                          return TextField(
                            key: const ValueKey('discover-search-field'),
                            controller: _search,
                            focusNode: _searchFocus,
                            autofocus: false,
                            autocorrect: false,
                            enableSuggestions: true,
                            textInputAction: TextInputAction.search,
                            onChanged: _changeSearch,
                            onSubmitted: (_) => _submitSearch(),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colors.onSurface,
                            ),
                            onTapOutside: (_) {
                              _searchFocus.unfocus();
                            },
                            decoration: InputDecoration(
                              hintText:
                                  'Search ${state.category.label.toLowerCase()} news',
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                size: 19,
                                color: colors.primary,
                              ),
                              suffixIcon: value.text.isEmpty
                                  ? null
                                  : IconButton(
                                      tooltip: AppStrings.clearSearch,
                                      onPressed: _clearSearch,
                                      icon: const Icon(
                                        Icons.close_rounded,
                                        size: 17,
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                    ),

                    _CategoryBar(
                      selected: state.category,
                      onSelected: _selectCategory,
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 5, 16, 9),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              state.query.isEmpty
                                  ? '${state.category.label} stories'
                                  : '${state.category.label} results',
                              style: theme.textTheme.titleSmall,
                            ),
                          ),
                          if (!showSkeleton && state.articles.isNotEmpty)
                            Text(
                              '${state.articles.length} loaded',
                              style: theme.textTheme.labelSmall,
                            ),
                        ],
                      ),
                    ),

                    Divider(
                      height: 1,
                      thickness: 0.7,
                      color: colors.outlineVariant.withValues(alpha: 0.45),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => vm.refresh(),
                  color: colors.primary,
                  backgroundColor: colors.surface,
                  displacement: 28,
                  strokeWidth: 2.2,
                  child: CustomScrollView(
                    controller: _scroll,
                    physics: const AlwaysScrollableScrollPhysics(),

                    // Keep typing stable while results update.
                    // The keyboard closes through the Search action,
                    // system Back button, or navigation.
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.manual,

                    slivers: [
                      if (!showSkeleton &&
                          (state.offline ||
                              state.cacheWriteFailed ||
                              (state.error != null &&
                                  state.articles.isNotEmpty)))
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: colors.primary.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: colors.primary.withValues(alpha: 0.12),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info_outline_rounded,
                                    size: 16,
                                    color: colors.primary,
                                  ),
                                  const SizedBox(width: 7),
                                  Expanded(
                                    child: Text(
                                      state.error ??
                                          (state.offline
                                              ? AppStrings.cacheNotice
                                              : AppStrings.persistenceNotice),
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                      if (showSkeleton)
                        const SliverPadding(
                          padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
                          sliver: NewsSkeletonSliver(count: 2),
                        )
                      else if (state.articles.isEmpty)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: bottomSpace),
                            child: StatePanel(
                              icon: state.error == null
                                  ? Icons.manage_search_rounded
                                  : Icons.cloud_off_rounded,
                              title: state.error == null
                                  ? 'No stories found'
                                  : 'Let’s reconnect',
                              message: state.error ?? AppStrings.noResultsBody,
                              action: state.error == null
                                  ? 'Refresh stories'
                                  : AppStrings.retry,
                              onAction: () => vm.refresh(),
                              secondaryAction: state.query.isEmpty
                                  ? null
                                  : 'Clear search',
                              onSecondaryAction: state.query.isEmpty
                                  ? null
                                  : _clearSearch,
                            ),
                          ),
                        )
                      else ...[
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                          sliver: ArticleSliver(articles: state.articles),
                        ),

                        if (state.loadingMore)
                          const SliverPadding(
                            padding: EdgeInsets.fromLTRB(16, 10, 16, 0),
                            sliver: NewsSkeletonSliver(count: 1),
                          )
                        else if (state.pageError != null)
                          SliverToBoxAdapter(
                            child: StatePanel(
                              icon: Icons.wifi_off_rounded,
                              title: 'More stories are waiting',
                              message: state.pageError!,
                              action: AppStrings.retry,
                              onAction: vm.loadMore,
                            ),
                          )
                        else if (state.hasMore)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Center(
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    unawaited(vm.loadMore());
                                  },
                                  icon: const Icon(
                                    Icons.expand_more_rounded,
                                    size: 18,
                                  ),
                                  label: const Text(AppStrings.loadMore),
                                ),
                              ),
                            ),
                          )
                        else
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(18),
                              child: Text(
                                state.offline
                                    ? 'Your saved briefing'
                                    : AppStrings.endOfFeed,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.labelSmall,
                              ),
                            ),
                          ),
                      ],

                      if (showSkeleton || state.articles.isNotEmpty)
                        SliverToBoxAdapter(
                          child: SizedBox(height: bottomSpace),
                        ),
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

class _CategoryBar extends StatelessWidget {
  const _CategoryBar({required this.selected, required this.onSelected});

  final NewsCategory selected;
  final ValueChanged<NewsCategory> onSelected;

  IconData _icon(NewsCategory category) {
    return switch (category) {
      NewsCategory.business => Icons.business_center_outlined,
      NewsCategory.technology => Icons.memory_rounded,
      NewsCategory.general => Icons.public_rounded,
      NewsCategory.science => Icons.science_outlined,
      NewsCategory.health => Icons.favorite_border_rounded,
      NewsCategory.sports => Icons.sports_soccer_rounded,
      NewsCategory.entertainment => Icons.movie_outlined,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final dark = theme.brightness == Brightness.dark;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          for (final category in NewsCategory.values)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 7),
              child: Semantics(
                button: true,
                selected: selected == category,
                label: '${category.label} news',
                onTap: () => onSelected(category),
                excludeSemantics: true,
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () => onSelected(category),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: AnimatedContainer(
                        duration: reduceMotion
                            ? Duration.zero
                            : const Duration(milliseconds: 160),
                        curve: Curves.easeOutCubic,
                        constraints: const BoxConstraints(minHeight: 40),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: selected == category
                              ? colors.primary
                              : colors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selected == category
                                ? colors.primary
                                : colors.primary.withValues(
                                    alpha: dark ? 0.25 : 0.16,
                                  ),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _icon(category),
                              size: 15,
                              color: selected == category
                                  ? colors.onPrimary
                                  : colors.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              category.label,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: selected == category
                                    ? colors.onPrimary
                                    : colors.onSurfaceVariant,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
