import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import '../../../core/constants/app_config.dart';
import '../../../core/errors/app_failure.dart';
import '../domain/article.dart';
import '../domain/news_repository.dart';
import 'article_dto.dart';

class BookmarkRepositoryImpl implements BookmarkRepository {
  const BookmarkRepositoryImpl({required this.box, required this.imageDio});
  final Box<dynamic> box;
  final Dio imageDio;
  String _prefix(String userId) => '${Uri.encodeComponent(userId)}:';
  String _key(String userId, int id) => '${_prefix(userId)}$id';

  @override
  List<SavedArticle> read(String userId) {
    final result = <SavedArticle>[];
    for (final key in box.keys.whereType<String>().where(
      (key) => key.startsWith(_prefix(userId)),
    )) {
      try {
        final value = Map<String, dynamic>.from(box.get(key) as Map);
        final article = ArticleDto.fromJson(
          Map<String, dynamic>.from(
            jsonDecode(value['article'] as String) as Map,
          ),
        ).toDomain();
        final bytes = value['image'];
        result.add(
          SavedArticle(
            article: article,
            savedAt: DateTime.fromMillisecondsSinceEpoch(
              value['saved_at'] as int,
            ),
            thumbnail: bytes is List<int> ? Uint8List.fromList(bytes) : null,
          ),
        );
      } catch (_) {
        // Skip a corrupt record while retaining every other saved story.
      }
    }
    return result..sort((a, b) => b.savedAt.compareTo(a.savedAt));
  }

  @override
  Future<void> save(String userId, Article article) async {
    final key = _key(userId, article.id);
    final record = <String, dynamic>{
      'article': jsonEncode(ArticleDto.fromDomain(article).toJson()),
      'saved_at': DateTime.now().millisecondsSinceEpoch,
    };
    try {
      await box.put(
        key,
        record,
      ); // Text persists even if the image host is offline.
    } catch (_) {
      throw const AppFailure(FailureKind.storage);
    }
    final thumbnail = await _downloadThumbnail(article.imageUrl);
    if (thumbnail != null && box.containsKey(key)) {
      try {
        await box.put(key, {...record, 'image': thumbnail});
      } catch (_) {
        // Saving text succeeded; optional thumbnail failure does not undo it.
      }
    }
  }

  Future<Uint8List?> _downloadThumbnail(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null ||
        !['http', 'https'].contains(uri.scheme) ||
        uri.host.isEmpty) {
      return null;
    }
    final token = CancelToken();
    final deadline = Timer(const Duration(seconds: 6), () => token.cancel());
    try {
      final response = await imageDio.get<ResponseBody>(
        url,
        cancelToken: token,
        options: Options(
          responseType: ResponseType.stream,
          receiveTimeout: const Duration(seconds: 5),
          sendTimeout: const Duration(seconds: 5),
        ),
      );
      final body = response.data;
      if (body == null ||
          !(response.headers.value('content-type') ?? '').startsWith('image/')) {
        return null;
      }
      final bytes = BytesBuilder(copy: false);
      await for (final chunk in body.stream) {
        if (bytes.length + chunk.length > ApiConstants.maxThumbnailBytes) {
          token.cancel();
          return null;
        }
        bytes.add(chunk);
      }
      return bytes.takeBytes();
    } catch (_) {
      return null;
    } finally {
      deadline.cancel();
      // Also release a response stream rejected by content-type or size checks.
      if (!token.isCancelled) token.cancel();
    }
  }

  @override
  Future<void> remove(String userId, int articleId) async {
    try {
      await box.delete(_key(userId, articleId));
    } catch (_) {
      throw const AppFailure(FailureKind.storage);
    }
  }
}
