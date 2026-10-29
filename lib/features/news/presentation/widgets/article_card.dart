import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_tokens.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../domain/article.dart';
import '../bookmark_view_model.dart';
import 'article_image.dart';
import 'bookmark_button.dart';

class ArticleCard extends ConsumerWidget {
  const ArticleCard({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final dark = theme.brightness == Brightness.dark;

    final saved = ref.watch(
      bookmarkProvider.select(
        (state) => state.articles
            .where((item) => item.article.id == article.id)
            .firstOrNull,
      ),
    );

    final hasImage =
        article.imageUrl.trim().isNotEmpty ||
        (saved?.thumbnail?.isNotEmpty ?? false);

    final borderColor = colors.primary.withValues(alpha: dark ? 0.28 : 0.18);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: dark ? 0.08 : 0.025),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: colors.surfaceContainerLow,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: borderColor, width: 1),
        ),
        child: InkWell(
          onTap: () {
            context.push('/article/${article.id}', extra: article);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (hasImage)
                Stack(
                  children: [
                    ArticleImage(
                      url: article.imageUrl,
                      bytes: saved?.thumbnail,
                      aspectRatio: AppLayout.articleImageAspectRatio,
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: colors.surface.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: colors.outlineVariant.withValues(alpha: 0.45),
                              ),
                            ),
                          ),
                          BookmarkButton(article: article),
                        ],
                      ),
                    ),
                  ],
                ),

              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(
                          color: colors.primary.withValues(alpha: 0.12),
                        ),
                      ),
                      child: Text(
                        article.source,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      article.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleLarge?.copyWith(
                        height: 1.35,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (article.summary.trim().isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        article.summary,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                    const SizedBox(height: 10),
                    Divider(
                      height: 1,
                      color: borderColor.withValues(alpha: dark ? 0.18 : 0.1),
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 12,
                          color: colors.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            article.publishedAt.readableDate,
                            style: theme.textTheme.labelSmall,
                          ),
                        ),
                        if (!hasImage)
                          BookmarkButton(article: article)
                        else ...[
                          Text(
                            'Read story',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_outward_rounded,
                            size: 13,
                            color: colors.primary,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
