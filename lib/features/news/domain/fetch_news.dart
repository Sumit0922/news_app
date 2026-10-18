import 'article.dart';
import 'news_repository.dart';

class FetchNews {
  const FetchNews(this.repository);
  final NewsRepository repository;
  Future<FeedResult> call({String query = '', int offset = 0}) {
    if (offset < 0) {
      throw ArgumentError.value(offset, 'offset', 'Must be nonnegative');
    }
    return repository.fetch(query: query.trim(), offset: offset);
  }
}
