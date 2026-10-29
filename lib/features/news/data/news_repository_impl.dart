import '../../../core/errors/app_failure.dart';
import '../domain/article.dart';
import '../domain/news_category.dart';
import '../domain/news_repository.dart';
import 'news_local_source.dart';
import 'news_remote_source.dart';

class NewsRepositoryImpl implements NewsRepository {
  const NewsRepositoryImpl({required this.remote, required this.local});

  final NewsRemoteSource remote;
  final NewsLocalSource local;

  @override
  FeedResult? readCached({
    required String query,
    NewsCategory category = NewsCategory.business,
  }) {
    final page = local.read(query, category: category);

    if (page == null) return null;

    return FeedResult(page, fromCache: true);
  }

  @override
  Future<FeedResult> fetch({
    required String query,
    required int offset,
    NewsCategory category = NewsCategory.business,
    bool forceRefresh = false,
  }) async {
    late final ArticlePage page;

    try {
      page = await remote.fetch(
        query: query,
        offset: offset,
        category: category,
        forceRefresh: forceRefresh,
      );
    } on AppFailure {
      if (offset == 0) {
        final cached = readCached(query: query, category: category);

        if (cached != null) {
          return cached;
        }
      }

      rethrow;
    }

    if (offset == 0) {
      try {
        await local.write(query, page, category: category);
      } catch (_) {
        return FeedResult(page, cacheWriteFailed: true);
      }
    }

    return FeedResult(page);
  }
}
