import 'dart:io';

import 'package:dio/dio.dart';

import '../../../core/constants/app_config.dart';
import '../../../core/errors/app_failure.dart';
import '../domain/article.dart';
import 'article_dto.dart';

class NewsRemoteSource {
  const NewsRemoteSource(this.dio);
  final Dio dio;

  Future<ArticlePage> fetch({
    required String query,
    required int offset,
  }) async {
    try {
      final response = await dio.get<dynamic>(
        ApiConstants.articles,
        queryParameters: {
          'limit': ApiConstants.pageSize,
          'offset': offset,
          'ordering': '-published_at',
          if (query.isNotEmpty) 'search': query,
        },
      );
      final raw = response.data;
      if (raw is! Map<String, dynamic> ||
          raw['results'] is! List ||
          raw['count'] is! int ||
          !raw.containsKey('next') ||
          (raw['next'] != null && raw['next'] is! String)) {
        throw const AppFailure(FailureKind.invalidResponse);
      }
      final rows = raw['results'] as List<dynamic>;
      final articles = rows
          .map((row) {
            final dto = ArticleDto.fromJson(
              Map<String, dynamic>.from(row as Map),
            );
            final uri = Uri.tryParse(dto.url);
            if (dto.id <= 0 ||
                dto.title.trim().isEmpty ||
                dto.source.trim().isEmpty ||
                uri == null ||
                !['http', 'https'].contains(uri.scheme) ||
                uri.host.isEmpty) {
              throw const AppFailure(FailureKind.invalidResponse);
            }
            return dto.toDomain();
          })
          .toList(growable: false);
      return ArticlePage(
        articles: articles,
        hasMore: raw['next'] != null && rows.isNotEmpty,
        nextOffset: offset + rows.length,
      );
    } on AppFailure {
      rethrow;
    } on DioException catch (error) {
      throw mapDioFailure(error);
    } catch (_) {
      throw const AppFailure(FailureKind.invalidResponse);
    }
  }
}

AppFailure mapDioFailure(DioException error) {
  if (error.error is FormatException || error.error is TypeError) {
    return const AppFailure(FailureKind.invalidResponse);
  }
  if (error.response?.statusCode == 429)
    return const AppFailure(FailureKind.rateLimit);
  return AppFailure(switch (error.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.sendTimeout => FailureKind.timeout,
    DioExceptionType.connectionError => FailureKind.network,
    DioExceptionType.badResponse => FailureKind.server,
    _ =>
      error.error is SocketException
          ? FailureKind.network
          : FailureKind.unknown,
  });
}
