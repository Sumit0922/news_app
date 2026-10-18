import 'dart:convert';

import 'package:hive/hive.dart';

import '../../../core/constants/app_config.dart';
import '../domain/article.dart';
import 'article_dto.dart';

class NewsLocalSource {
  const NewsLocalSource(this.box);
  final Box<dynamic> box;

  String _key(String query) => query.trim().toLowerCase();

  ArticlePage? read(String query) {
    try {
      final value = box.get(_key(query));
      if (value is! String) return null;
      final json = jsonDecode(value) as Map<String, dynamic>;
      final rows = (json['articles'] as List<dynamic>)
          .map(
            (row) =>
                ArticleDto.fromJson(Map<String, dynamic>.from(row as Map))
                    .toDomain(),
          )
          .toList();
      // A cached first page is a finite offline snapshot, never a pagination cursor.
      return ArticlePage(
        articles: rows,
        hasMore: false,
        nextOffset: rows.length,
      );
    } catch (_) {
      return null; // Corrupt cache must not prevent live news from loading.
    }
  }

  Future<void> write(String query, ArticlePage page) async {
    final key = _key(query);
    if (!box.containsKey(key) && box.length >= ApiConstants.maxCachedQueries) {
      await box.delete(box.keys.first);
    }
    await box.put(
      key,
      jsonEncode({
        'articles': page.articles
            .map((article) => ArticleDto.fromDomain(article).toJson())
            .toList(),
        'saved_at': DateTime.now().toUtc().toIso8601String(),
      }),
    );
  }
}
