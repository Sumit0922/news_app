import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orbit_news/widgets/orbit_loader.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/errors/failure_message.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../domain/article.dart';
import '../bookmark_view_model.dart';

class BookmarkButton extends ConsumerWidget {
  const BookmarkButton({super.key, required this.article});
  final Article article;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(
      bookmarkProvider.select(
        (state) =>
            state.articles.any((saved) => saved.article.id == article.id),
      ),
    );
    final busy = ref.watch(
      bookmarkProvider.select((state) => state.busyIds.contains(article.id)),
    );
    return IconButton(
      tooltip: busy
          ? AppStrings.saving
          : saved
          ? AppStrings.remove
          : AppStrings.save,
      isSelected: saved,
      onPressed: busy
          ? null
          : () async {
              try {
                final nowSaved = await ref
                    .read(bookmarkProvider.notifier)
                    .toggle(article);
                if (context.mounted)
                  context.showMessage(
                    nowSaved ? AppStrings.saved : AppStrings.removed,
                  );
              } catch (error) {
                if (context.mounted) context.showMessage(failureMessage(error));
              }
            },
      icon: busy
          ? const OrbitLoader(size: 24)
          : const Icon(Icons.bookmark_border_rounded),
      selectedIcon: const Icon(Icons.bookmark_rounded),
    );
  }
}
