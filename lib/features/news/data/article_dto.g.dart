// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ArticleDto _$ArticleDtoFromJson(Map<String, dynamic> json) => _ArticleDto(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  url: json['url'] as String,
  imageUrl: json['image_url'] as String? ?? '',
  source: json['news_site'] as String,
  summary: json['summary'] as String? ?? '',
  publishedAt: DateTime.parse(json['published_at'] as String),
);

Map<String, dynamic> _$ArticleDtoToJson(_ArticleDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'url': instance.url,
      'image_url': instance.imageUrl,
      'news_site': instance.source,
      'summary': instance.summary,
      'published_at': instance.publishedAt.toIso8601String(),
    };
