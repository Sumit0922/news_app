import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../app/providers.dart';
import '../../auth/presentation/auth_view_model.dart';
import '../domain/article.dart';

part 'bookmark_view_model.freezed.dart';

@freezed
abstract class BookmarkState with _$BookmarkState {
  const factory BookmarkState({
    @Default(<SavedArticle>[]) List<SavedArticle> articles,
    @Default(<int>{}) Set<int> busyIds,
  }) = _BookmarkState;
}

final bookmarkProvider = NotifierProvider<BookmarkViewModel, BookmarkState>(
  BookmarkViewModel.new,
);

class BookmarkViewModel extends Notifier<BookmarkState> {
  String? _email;
  int _generation = 0;
  @override
  BookmarkState build() {
    _generation++;
    _email = ref.watch(authProvider.select((state) => state.email));
    final email = _email;
    return BookmarkState(
      articles: email == null
          ? []
          : ref.watch(bookmarkRepositoryProvider).read(email),
    );
  }

  Future<bool> toggle(Article article) async {
    final email = _email;
    if (email == null || state.busyIds.contains(article.id)) return false;
    final generation = _generation;
    final repository = ref.read(bookmarkRepositoryProvider);
    final isSaved = state.articles.any((item) => item.article.id == article.id);
    state = state.copyWith(busyIds: {...state.busyIds, article.id});
    try {
      if (isSaved) {
        await repository.remove(email, article.id);
      } else {
        await repository.save(email, article);
      }
      if (ref.mounted && generation == _generation) {
        state = state.copyWith(articles: repository.read(email));
      }
      return !isSaved;
    } finally {
      if (ref.mounted && generation == _generation) {
        state = state.copyWith(busyIds: {...state.busyIds}..remove(article.id));
      }
    }
  }
}
