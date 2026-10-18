import '../../../core/errors/app_failure.dart';
import '../domain/article.dart';
import '../domain/news_repository.dart';
import 'news_local_source.dart';
import 'news_remote_source.dart';

class NewsRepositoryImpl implements NewsRepository {
  const NewsRepositoryImpl({required this.remote, required this.local});
  final NewsRemoteSource remote;
  final NewsLocalSource local;

  @override
  Future<FeedResult> fetch({required String query, required int offset}) async {
    late final ArticlePage page;
    try {
      page = await remote.fetch(query: query, offset: offset);
    } on AppFailure catch (error) {
      if (offset == 0 &&
          {
            FailureKind.network,
            FailureKind.timeout,
            FailureKind.server,
            FailureKind.rateLimit,
          }.contains(error.kind)) {
        final cached = local.read(query);
        if (cached != null) return FeedResult(cached, fromCache: true);
      }
      rethrow;
    }
    if (offset == 0) {
      try {
        await local.write(query, page);
      } catch (_) {
        return FeedResult(page, cacheWriteFailed: true);
      }
    }
    return FeedResult(page);
  }
}
