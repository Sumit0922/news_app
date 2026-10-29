import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_tokens.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../widgets/app_cached_image.dart';
import '../../../widgets/responsive_body.dart';
import '../../../widgets/state_panel.dart';
import '../domain/article.dart';
import 'bookmark_view_model.dart';
import 'widgets/bookmark_button.dart';

class BookmarksScreen extends ConsumerStatefulWidget {
  const BookmarksScreen({super.key});

  @override
  ConsumerState<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends ConsumerState<BookmarksScreen> {
  final _listKey = GlobalKey<AnimatedListState>();

  late final List<SavedArticle> _items;

  @override
  void initState() {
    super.initState();

    _items = List<SavedArticle>.of(ref.read(bookmarkProvider).articles);
  }

  Duration get _duration {
    return MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 220);
  }

  void _removeAt(int index) {
    final removed = _items.removeAt(index);

    _listKey.currentState?.removeItem(index, (context, animation) {
      return IgnorePointer(child: _animatedRow(removed, animation));
    }, duration: _duration);
  }

  void _synchronize(List<SavedArticle> next) {
    if (!mounted) return;

    final nextIds = next.map((item) => item.article.id).toSet();

    // Remove from the end so earlier indices remain valid.
    for (var index = _items.length - 1; index >= 0; index--) {
      if (!nextIds.contains(_items[index].article.id)) {
        _removeAt(index);
      }
    }

    for (var index = 0; index < next.length; index++) {
      final incoming = next[index];

      if (index < _items.length &&
          _items[index].article.id == incoming.article.id) {
        _items[index] = incoming;
        continue;
      }

      final previousIndex = _items.indexWhere(
        (item) => item.article.id == incoming.article.id,
      );

      if (previousIndex >= 0) {
        _removeAt(previousIndex);
      }

      _items.insert(index, incoming);

      _listKey.currentState?.insertItem(index, duration: _duration);
    }

    setState(() {});
  }

  Widget _animatedRow(SavedArticle saved, Animation<double> animation) {
    final curved = animation.drive(CurveTween(curve: Curves.easeOutCubic));

    return SizeTransition(
      sizeFactor: curved,
      alignment: Alignment.topCenter,
      child: FadeTransition(
        opacity: curved,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _SavedStoryCard(key: ValueKey(saved.article.id), saved: saved),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<List<SavedArticle>>(
      bookmarkProvider.select((state) => state.articles),
      (previous, next) => _synchronize(next),
    );

    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final textScale = MediaQuery.textScalerOf(context).scale(12) / 12;

    final bottomSpace =
        MediaQuery.paddingOf(context).bottom +
        110 +
        (textScale > 1 ? (textScale - 1) * 32 : 0);

    return ResponsiveBody(
      maxWidth: AppLayout.feedMaxWidth,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.savedTitle,
                        style: theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppStrings.savedSubtitle,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: colors.primary.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Text(
                    '${_items.length}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                AnimatedList(
                  key: _listKey,
                  initialItemCount: _items.length,
                  padding: EdgeInsets.fromLTRB(16, 0, 16, bottomSpace),
                  itemBuilder: (context, index, animation) {
                    return _animatedRow(_items[index], animation);
                  },
                ),

                if (_items.isEmpty)
                  Positioned.fill(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: bottomSpace),
                      child: const StatePanel(
                        icon: Icons.bookmarks_outlined,
                        title: AppStrings.noSaved,
                        message: AppStrings.noSavedBody,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SavedStoryCard extends StatelessWidget {
  const _SavedStoryCard({super.key, required this.saved});

  final SavedArticle saved;

  @override
  Widget build(BuildContext context) {
    final article = saved.article;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final dark = theme.brightness == Brightness.dark;

    return Material(
      color: colors.surfaceContainerLow,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colors.primary.withValues(alpha: dark ? 0.25 : 0.15),
        ),
      ),
      child: InkWell(
        onTap: () {
          context.push('/article/${article.id}', extra: article);
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 76,
                height: 76,
                child: AppCachedImage(
                  url: article.imageUrl,
                  bytes: saved.thumbnail,
                  aspectRatio: 1,
                  borderRadius: 11,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.source,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        height: 1.35,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      article.publishedAt.readableDate,
                      style: theme.textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 2),
              BookmarkButton(article: article),
            ],
          ),
        ),
      ),
    );
  }
}
