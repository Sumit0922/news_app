import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:orbit_news/widgets/app_button.dart';
import 'package:orbit_news/widgets/app_text.dart';
import 'package:orbit_news/widgets/responsive_body.dart';
import 'package:orbit_news/widgets/state_panel.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_tokens.dart';
import '../../../core/extensions/context_extensions.dart';
import '../domain/article.dart';
import 'bookmark_view_model.dart';
import 'widgets/article_image.dart';
import 'widgets/bookmark_button.dart';

class ArticleScreen extends ConsumerWidget {
  const ArticleScreen({super.key, required this.id, this.initialArticle});
  final int? id;
  final Article? initialArticle;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(
      bookmarkProvider.select(
        (state) =>
            state.articles.where((value) => value.article.id == id).firstOrNull,
      ),
    );
    final article = initialArticle ?? saved?.article;
    return Scaffold(
      appBar: AppBar(
        title: const AppText(AppStrings.appName, variant: AppTextStyle.title),
        actions: [
          if (article != null) BookmarkButton(article: article),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: article == null
          ? StatePanel(
              icon: Icons.article_outlined,
              title: AppStrings.noResults,
              message: AppStrings.storyMissing,
              action: AppStrings.backToFeed,
              onAction: () => context.go('/discover'),
            )
          : ResponsiveBody(
              maxWidth: 820,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        final thumbnail = saved?.thumbnail;

                        final ImageProvider imageProvider =
                        thumbnail != null && thumbnail.isNotEmpty
                            ? MemoryImage(thumbnail)
                            : NetworkImage(article.imageUrl);

                        showDialog<void>(
                          context: context,
                          useSafeArea: false,
                          barrierColor: Colors.black,
                          builder: (_) => _FullScreenArticleImage(
                            imageProvider: imageProvider,
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppSpacing.radius),
                        child: ArticleImage(
                          url: article.imageUrl,
                          bytes: saved?.thumbnail,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppText(
                      AppStrings.bySource(article.source),
                      variant: AppTextStyle.caption,
                      color: context.colors.primary,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppText(article.title, variant: AppTextStyle.heading),
                    const SizedBox(height: AppSpacing.md),
                    AppText(
                      article.publishedAt.readableDate,
                      variant: AppTextStyle.caption,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    const AppText(
                      AppStrings.summary,
                      variant: AppTextStyle.title,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SelectableText(
                      article.summary.isEmpty
                          ? AppStrings.noSummary
                          : article.summary,
                      style: context.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    AppButton(
                      label: AppStrings.readOriginal,
                      icon: Icons.open_in_new_rounded,
                      onPressed: () async {
                        try {
                          final uri = Uri.parse(article.url);
                          if (!['http', 'https'].contains(uri.scheme) ||
                              uri.host.isEmpty ||
                              !await launchUrl(
                                uri,
                                mode: LaunchMode.externalApplication,
                              )) {
                            throw const FormatException();
                          }
                        } catch (_) {
                          if (context.mounted) {
                            context.showMessage(AppStrings.openFailed);
                          }
                        }
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const AppText(
                      AppStrings.originalNotice,
                      variant: AppTextStyle.caption,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    const Divider(),
                    const AppText(
                      AppStrings.sourceCredit,
                      variant: AppTextStyle.caption,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),
    );
  }
}


class _FullScreenArticleImage extends StatelessWidget {
  const _FullScreenArticleImage({
    required this.imageProvider,
  });

  final ImageProvider imageProvider;

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: ExcludeSemantics(
              child: ImageFiltered(
                imageFilter: ui.ImageFilter.blur(
                  sigmaX: 8,
                  sigmaY: 8,
                  tileMode: TileMode.clamp,
                ),
                child: Image(
                  image: imageProvider,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) =>
                  const ColoredBox(color: Colors.black),
                ),
              ),
            ),
          ),
          const Positioned.fill(
            child: ColoredBox(color: Colors.black38),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: SizedBox.expand(
                  child: Image(
                    image: imageProvider,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;

                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    },
                    errorBuilder: (_, _, _) => const Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                        color: Colors.white,
                        size: 48,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: IconButton(
                  tooltip: MaterialLocalizations.of(context)
                      .closeButtonTooltip,
                  onPressed: () => Navigator.of(context).pop(),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black54,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.close_rounded),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}