import 'dart:convert';

import 'package:hive/hive.dart';

import '../../../core/constants/app_config.dart';
import '../domain/article.dart';
import '../domain/news_category.dart';
import 'article_dto.dart';

class NewsLocalSource {
  const NewsLocalSource(this.box);

  final Box<dynamic> box;

  String _key(String query, NewsCategory category) {
    return jsonEncode([
      ApiConstants.cacheNamespace,
      category.name,
      query.trim().toLowerCase(),
    ]);
  }

  ArticlePage? read(
    String query, {
    NewsCategory category = NewsCategory.business,
  }) {
    try {
      final value = box.get(_key(query, category));

      if (value is! String) return null;

      final decoded = jsonDecode(value);

      if (decoded is! Map || decoded['articles'] is! List) {
        return null;
      }

      final articles = (decoded['articles'] as List)
          .map(
            (row) =>
                ArticleDto.fromJson(Map<String, dynamic>.from(row as Map))
                    .toDomain(),
          )
          .toList(growable: false);

      // Only the first visible page is persisted as a feed preview.
      // Favorites are stored separately and are unaffected.
      return ArticlePage(
        articles: articles,
        hasMore: false,
        nextOffset: articles.length,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> write(
    String query,
    ArticlePage page, {
    NewsCategory category = NewsCategory.business,
  }) async {
    final key = _key(query, category);

    if (!box.containsKey(key)) {
      while (box.length >= ApiConstants.maxCachedQueries) {
        await box.delete(box.keys.first);
      }
    }

    await box.put(
      key,
      jsonEncode({
        'articles': page.articles
            .map((article) => ArticleDto.fromDomain(article).toJson())
            .toList(growable: false),
        'saved_at': DateTime.now().toUtc().toIso8601String(),
      }),
    );
  }
}
