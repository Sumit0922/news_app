import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/article.dart';

part 'article_dto.freezed.dart';
part 'article_dto.g.dart';

@freezed
abstract class ArticleDto with _$ArticleDto {
  const ArticleDto._();
  const factory ArticleDto({
    required int id,
    required String title,
    required String url,
    @JsonKey(name: 'image_url') @Default('') String imageUrl,
    @JsonKey(name: 'news_site') required String source,
    @Default('') String summary,
    @JsonKey(name: 'published_at') required DateTime publishedAt,
  }) = _ArticleDto;
  factory ArticleDto.fromJson(Map<String, dynamic> json) =>
      _$ArticleDtoFromJson(json);
  factory ArticleDto.fromDomain(Article value) => ArticleDto(
    id: value.id,
    title: value.title,
    url: value.url,
    imageUrl: value.imageUrl,
    source: value.source,
    summary: value.summary,
    publishedAt: value.publishedAt,
  );
  Article toDomain() => Article(
    id: id,
    title: title,
    url: url,
    imageUrl: imageUrl,
    source: source,
    summary: summary,
    publishedAt: publishedAt,
  );
}
