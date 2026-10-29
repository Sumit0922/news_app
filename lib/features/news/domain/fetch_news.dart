import 'article.dart';
import 'news_category.dart';
import 'news_repository.dart';

class FetchNews {
  const FetchNews(this.repository);

  final NewsRepository repository;

  FeedResult? cached({
    String query = '',
    NewsCategory category = NewsCategory.business,
  }) {
    return repository.readCached(query: query.trim(), category: category);
  }

  Future<FeedResult> call({
    String query = '',
    int offset = 0,
    NewsCategory category = NewsCategory.business,
    bool forceRefresh = false,
  }) {
    if (offset < 0) {
      throw ArgumentError.value(offset, 'offset', 'Must be nonnegative.');
    }

    return repository.fetch(
      query: query.trim(),
      offset: offset,
      category: category,
      forceRefresh: forceRefresh,
    );
  }
}
