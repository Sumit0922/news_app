import 'article.dart';
import 'news_category.dart';

abstract interface class NewsRepository {
  FeedResult? readCached({
    required String query,
    NewsCategory category = NewsCategory.business,
  });

  Future<FeedResult> fetch({
    required String query,
    required int offset,
    NewsCategory category = NewsCategory.business,
    bool forceRefresh = false,
  });
}

abstract interface class BookmarkRepository {
  List<SavedArticle> read(String userId);

  Future<void> save(String userId, Article article);

  Future<void> remove(String userId, int articleId);
}
