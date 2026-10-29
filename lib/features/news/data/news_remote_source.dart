import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:html/parser.dart' as html;
import 'package:xml/xml.dart';

import '../../../core/constants/app_config.dart';
import '../../../core/errors/app_failure.dart';
import '../domain/article.dart';
import '../domain/news_category.dart';

class NewsRemoteSource {
  NewsRemoteSource(this.dio);

  final Dio dio;

  final Map<String, _FeedSnapshot> _snapshots = {};
  final Map<String, Future<List<Article>>> _pending = {};
  final Map<String, DateTime> _blockedHosts = {};

  String _key(String query, NewsCategory category) {
    return jsonEncode([category.name, query.trim().toLowerCase()]);
  }

  Future<ArticlePage> fetch({
    required String query,
    required int offset,
    NewsCategory category = NewsCategory.business,
    bool forceRefresh = false,
  }) async {
    if (offset < 0) {
      throw ArgumentError.value(offset, 'offset');
    }

    final key = _key(query, category);
    final snapshot = _snapshots[key];

    if (offset > 0) {
      if (snapshot == null) {
        throw const AppFailure(FailureKind.server);
      }

      return _page(snapshot.articles, offset);
    }

    if (snapshot != null) {
      final age = DateTime.now().difference(snapshot.loadedAt);

      final reusable =
          age < AppDurations.minimumRefresh ||
          (!forceRefresh && age < AppDurations.feedCache);

      if (reusable) {
        _log('Using memory cache: ${category.name}');
        return _page(snapshot.articles, 0);
      }
    }

    // Multiple widgets asking for the same feed share one request.
    final existing = _pending[key];

    if (existing != null) {
      return _page(await existing, 0);
    }

    final request = _download(query: query, category: category);

    _pending[key] = request;

    try {
      final articles = await request;

      _snapshots.remove(key);
      _snapshots[key] = _FeedSnapshot(
        articles: List<Article>.unmodifiable(articles),
        loadedAt: DateTime.now(),
      );

      while (_snapshots.length > ApiConstants.maxCachedQueries) {
        _snapshots.remove(_snapshots.keys.first);
      }

      return _page(articles, 0);
    } finally {
      _pending.remove(key);
    }
  }

  Future<List<Article>> _download({
    required String query,
    required NewsCategory category,
  }) async {
    final uri = _feedUri(query, category);
    final blockedUntil = _blockedHosts[uri.host];

    if (blockedUntil != null && DateTime.now().isBefore(blockedUntil)) {
      throw const AppFailure(FailureKind.rateLimit);
    }

    try {
      _log(
        'Loading ${category.name}; '
        'search=${query.trim().isNotEmpty}',
      );

      final response = await dio.get<String>(
        uri.toString(),
        options: Options(
          responseType: ResponseType.plain,
          headers: const {
            'Accept': 'application/rss+xml, application/xml, text/xml, */*',
          },
        ),
      );

      final body = response.data?.trim() ?? '';

      if (body.isEmpty) {
        throw const AppFailure(FailureKind.invalidResponse);
      }

      // XML and HTML parsing run away from the mobile UI isolate.
      final articles = await compute(_parseRss, <String, String>{
        'xml': body,
        'search': query.trim().isNotEmpty ? 'true' : 'false',
      });

      _log(
        'HTTP ${response.statusCode}; '
        '${articles.length} stories loaded',
      );

      return articles;
    } on AppFailure {
      rethrow;
    } on DioException catch (error) {
      if (error.response?.statusCode == 429) {
        final retryAfter = int.tryParse(
          error.response?.headers.value('retry-after') ?? '',
        );

        _blockedHosts[uri.host] = DateTime.now().add(
          Duration(seconds: (retryAfter ?? 60).clamp(5, 3600).toInt()),
        );
      }

      _log(
        'Request failed: ${error.type.name}; '
        'HTTP ${error.response?.statusCode}',
      );

      throw mapDioFailure(error);
    } catch (error) {
      _log('Feed parsing failed: ${error.runtimeType}');
      throw const AppFailure(FailureKind.invalidResponse);
    }
  }

  Uri _feedUri(String query, NewsCategory category) {
    final text = query.trim();

    if (text.isNotEmpty) {
      // Google News RSS search is an unofficial public endpoint.
      // Uri builds and escapes the query parameters safely.
      final categoryTerm = switch (category) {
        NewsCategory.business => 'business',
        NewsCategory.technology => 'technology',
        NewsCategory.general => '',
        NewsCategory.science => 'science',
        NewsCategory.health => 'health',
        NewsCategory.sports => 'sports',
        NewsCategory.entertainment => 'entertainment',
      };

      final search = [
        if (categoryTerm.isNotEmpty) categoryTerm,
        text,
      ].join(' ');

      return Uri.https('news.google.com', '/rss/search', {
        'q': search,
        'hl': 'en-IN',
        'gl': 'IN',
        'ceid': 'IN:en',
      });
    }

    final path = switch (category) {
      NewsCategory.business => '/news/business/rss.xml',
      NewsCategory.technology => '/news/technology/rss.xml',
      NewsCategory.general => '/news/rss.xml',
      NewsCategory.science => '/news/science_and_environment/rss.xml',
      NewsCategory.health => '/news/health/rss.xml',
      NewsCategory.sports => '/sport/rss.xml',
      NewsCategory.entertainment => '/news/entertainment_and_arts/rss.xml',
    };

    return Uri.https('feeds.bbci.co.uk', path);
  }

  ArticlePage _page(List<Article> articles, int offset) {
    if (offset >= articles.length) {
      return ArticlePage(
        articles: const [],
        hasMore: false,
        nextOffset: offset,
      );
    }

    final end = (offset + ApiConstants.pageSize)
        .clamp(0, articles.length)
        .toInt();

    return ArticlePage(
      articles: articles.sublist(offset, end),
      hasMore: end < articles.length,
      nextOffset: end,
    );
  }
}

class _FeedSnapshot {
  const _FeedSnapshot({required this.articles, required this.loadedAt});

  final List<Article> articles;
  final DateTime loadedAt;
}

// Top-level callback required by compute().
List<Article> _parseRss(Map<String, String> input) {
  final document = XmlDocument.parse(input['xml'] ?? '');
  final channel = document.rootElement.getElement('channel');

  if (document.rootElement.name.local != 'rss' || channel == null) {
    throw const AppFailure(FailureKind.invalidResponse);
  }

  final isSearch = input['search'] == 'true';
  final unique = <String, Article>{};
  final items = channel.findElements('item').toList();

  for (final item in items) {
    final url = item.getElement('link')?.innerText.trim() ?? '';
    final uri = Uri.tryParse(url);

    if (uri == null ||
        uri.host.isEmpty ||
        !['http', 'https'].contains(uri.scheme)) {
      continue;
    }

    var title = _plainText(item.getElement('title')?.innerText ?? '');

    if (title.isEmpty) continue;

    final dateText = item.getElement('pubDate')?.innerText.trim() ?? '';

    DateTime? publishedAt = DateTime.tryParse(dateText);

    if (publishedAt == null) {
      try {
        publishedAt = HttpDate.parse(dateText);
      } catch (_) {
        continue;
      }
    }

    final sourceText = _plainText(item.getElement('source')?.innerText ?? '');

    final source = sourceText.isNotEmpty
        ? sourceText
        : isSearch
        ? uri.host
        : 'BBC News';

    final suffix = ' - $source';

    if (isSearch && title.endsWith(suffix)) {
      title = title.substring(0, title.length - suffix.length);
    }

    var imageUrl = '';

    for (final element in item.descendants.whereType<XmlElement>()) {
      if (element.name.local == 'thumbnail' ||
          element.name.local == 'content') {
        final candidate = element.getAttribute('url') ?? '';

        if (_isHttpUrl(candidate)) {
          imageUrl = candidate;
          break;
        }
      }
    }

    if (imageUrl.isEmpty) {
      final enclosure = item.getElement('enclosure');

      if ((enclosure?.getAttribute('type') ?? '').startsWith('image/')) {
        final candidate = enclosure?.getAttribute('url') ?? '';

        if (_isHttpUrl(candidate)) {
          imageUrl = candidate;
        }
      }
    }

    // Google search descriptions can contain related-story lists.
    // Do not misrepresent those lists as article summaries.
    final summary = isSearch
        ? ''
        : _plainText(item.getElement('description')?.innerText ?? '');

    unique[url] = Article(
      id: _articleId(url),
      title: title,
      url: url,
      imageUrl: imageUrl,
      source: source,
      summary: summary,
      publishedAt: publishedAt.toUtc(),
    );
  }

  if (items.isNotEmpty && unique.isEmpty) {
    throw const AppFailure(FailureKind.invalidResponse);
  }

  return unique.values.toList(growable: false)
    ..sort((first, second) => second.publishedAt.compareTo(first.publishedAt));
}

String _plainText(String value) {
  return (html.parse(value).body?.text ?? '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

bool _isHttpUrl(String value) {
  final uri = Uri.tryParse(value);

  return uri != null &&
      uri.host.isNotEmpty &&
      ['http', 'https'].contains(uri.scheme);
}

int _articleId(String url) {
  const modulus = 281474976710655;
  var hash = 7;

  for (final codeUnit in url.codeUnits) {
    hash = (hash * 31 + codeUnit) % modulus;
  }

  return hash == 0 ? 1 : hash;
}

AppFailure mapDioFailure(DioException error) {
  if (error.response?.statusCode == 429) {
    return const AppFailure(FailureKind.rateLimit);
  }

  return AppFailure(switch (error.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.sendTimeout => FailureKind.timeout,

    DioExceptionType.connectionError ||
    DioExceptionType.badCertificate => FailureKind.network,

    DioExceptionType.badResponse => FailureKind.server,

    _ => FailureKind.unknown,
  });
}

void _log(String message) {
  if (kDebugMode) {
    debugPrint('[OrbitFeed] $message');
  }
}
