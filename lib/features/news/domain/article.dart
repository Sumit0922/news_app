import 'dart:typed_data';

class Article {
  const Article({
    required this.id,
    required this.title,
    required this.url,
    required this.imageUrl,
    required this.source,
    required this.summary,
    required this.publishedAt,
  });
  final int id;
  final String title;
  final String url;
  final String imageUrl;
  final String source;
  final String summary;
  final DateTime publishedAt;
}

class ArticlePage {
  ArticlePage({
    required List<Article> articles,
    required this.hasMore,
    required this.nextOffset,
  }) : articles = List.unmodifiable(articles);
  final List<Article> articles;
  final bool hasMore;
  final int nextOffset;
}

class FeedResult {
  const FeedResult(
    this.page, {
    this.fromCache = false,
    this.cacheWriteFailed = false,
  });
  final ArticlePage page;
  final bool fromCache;
  final bool cacheWriteFailed;
}

class SavedArticle {
  const SavedArticle({
    required this.article,
    required this.savedAt,
    this.thumbnail,
  });
  final Article article;
  final DateTime savedAt;
  final Uint8List? thumbnail;
}
