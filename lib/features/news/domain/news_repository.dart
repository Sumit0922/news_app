import 'article.dart';

abstract interface class NewsRepository {
  Future<FeedResult> fetch({required String query, required int offset});
}

abstract interface class BookmarkRepository {
  List<SavedArticle> read(String userId);
  Future<void> save(String userId, Article article);
  Future<void> remove(String userId, int articleId);
}
