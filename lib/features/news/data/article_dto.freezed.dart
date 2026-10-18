// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'article_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ArticleDto {

 int get id; String get title; String get url;@JsonKey(name: 'image_url') String get imageUrl;@JsonKey(name: 'news_site') String get source; String get summary;@JsonKey(name: 'published_at') DateTime get publishedAt;
/// Create a copy of ArticleDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArticleDtoCopyWith<ArticleDto> get copyWith => _$ArticleDtoCopyWithImpl<ArticleDto>(this as ArticleDto, _$identity);

  /// Serializes this ArticleDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ArticleDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArticleDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.url, _this.url) || other.url == _this.url)&&(identical(other.imageUrl, _this.imageUrl) || other.imageUrl == _this.imageUrl)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.summary, _this.summary) || other.summary == _this.summary)&&(identical(other.publishedAt, _this.publishedAt) || other.publishedAt == _this.publishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ArticleDto;
  return Object.hash(runtimeType,_this.id,_this.title,_this.url,_this.imageUrl,_this.source,_this.summary,_this.publishedAt);
}

@override
String toString() {
  final _this = this as ArticleDto;
  return 'ArticleDto(id: ${_this.id}, title: ${_this.title}, url: ${_this.url}, imageUrl: ${_this.imageUrl}, source: ${_this.source}, summary: ${_this.summary}, publishedAt: ${_this.publishedAt})';
}


}

/// @nodoc
abstract mixin class $ArticleDtoCopyWith<$Res>  {
  factory $ArticleDtoCopyWith(ArticleDto value, $Res Function(ArticleDto) _then) = _$ArticleDtoCopyWithImpl;
@useResult
$Res call({
 int id, String title, String url,@JsonKey(name: 'image_url') String imageUrl,@JsonKey(name: 'news_site') String source, String summary,@JsonKey(name: 'published_at') DateTime publishedAt
});




}
/// @nodoc
class _$ArticleDtoCopyWithImpl<$Res>
    implements $ArticleDtoCopyWith<$Res> {
  _$ArticleDtoCopyWithImpl(this._self, this._then);

  final ArticleDto _self;
  final $Res Function(ArticleDto) _then;

/// Create a copy of ArticleDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? url = null,Object? imageUrl = null,Object? source = null,Object? summary = null,Object? publishedAt = null,}) {
  return _then(ArticleDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,publishedAt: null == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ArticleDto].
extension ArticleDtoPatterns on ArticleDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArticleDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArticleDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArticleDto value)  $default,){
final _that = this;
switch (_that) {
case _ArticleDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArticleDto value)?  $default,){
final _that = this;
switch (_that) {
case _ArticleDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String url, @JsonKey(name: 'image_url')  String imageUrl, @JsonKey(name: 'news_site')  String source,  String summary, @JsonKey(name: 'published_at')  DateTime publishedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArticleDto() when $default != null:
return $default(_that.id,_that.title,_that.url,_that.imageUrl,_that.source,_that.summary,_that.publishedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String url, @JsonKey(name: 'image_url')  String imageUrl, @JsonKey(name: 'news_site')  String source,  String summary, @JsonKey(name: 'published_at')  DateTime publishedAt)  $default,) {final _that = this;
switch (_that) {
case _ArticleDto():
return $default(_that.id,_that.title,_that.url,_that.imageUrl,_that.source,_that.summary,_that.publishedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String url, @JsonKey(name: 'image_url')  String imageUrl, @JsonKey(name: 'news_site')  String source,  String summary, @JsonKey(name: 'published_at')  DateTime publishedAt)?  $default,) {final _that = this;
switch (_that) {
case _ArticleDto() when $default != null:
return $default(_that.id,_that.title,_that.url,_that.imageUrl,_that.source,_that.summary,_that.publishedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ArticleDto extends ArticleDto {
  const _ArticleDto({required this.id, required this.title, required this.url, @JsonKey(name: 'image_url') this.imageUrl = '', @JsonKey(name: 'news_site') required this.source, this.summary = '', @JsonKey(name: 'published_at') required this.publishedAt}): super._();
  factory _ArticleDto.fromJson(Map<String, dynamic> json) => _$ArticleDtoFromJson(json);

@override final  int id;
@override final  String title;
@override final  String url;
@override@JsonKey(name: 'image_url') final  String imageUrl;
@override@JsonKey(name: 'news_site') final  String source;
@override@JsonKey() final  String summary;
@override@JsonKey(name: 'published_at') final  DateTime publishedAt;

/// Create a copy of ArticleDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArticleDtoCopyWith<_ArticleDto> get copyWith => __$ArticleDtoCopyWithImpl<_ArticleDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ArticleDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArticleDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.url, url) || other.url == url)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.source, source) || other.source == source)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,title,url,imageUrl,source,summary,publishedAt);
}

@override
String toString() {
    return 'ArticleDto(id: $id, title: $title, url: $url, imageUrl: $imageUrl, source: $source, summary: $summary, publishedAt: $publishedAt)';
}


}

/// @nodoc
abstract mixin class _$ArticleDtoCopyWith<$Res> implements $ArticleDtoCopyWith<$Res> {
  factory _$ArticleDtoCopyWith(_ArticleDto value, $Res Function(_ArticleDto) _then) = __$ArticleDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String url,@JsonKey(name: 'image_url') String imageUrl,@JsonKey(name: 'news_site') String source, String summary,@JsonKey(name: 'published_at') DateTime publishedAt
});




}
/// @nodoc
class __$ArticleDtoCopyWithImpl<$Res>
    implements _$ArticleDtoCopyWith<$Res> {
  __$ArticleDtoCopyWithImpl(this._self, this._then);

  final _ArticleDto _self;
  final $Res Function(_ArticleDto) _then;

/// Create a copy of ArticleDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? url = null,Object? imageUrl = null,Object? source = null,Object? summary = null,Object? publishedAt = null,}) {
  return _then(_ArticleDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,publishedAt: null == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
