// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FeedState {

 List<Article> get articles; String get query; NewsCategory get category; bool get loading; bool get refreshing; bool get loadingMore; bool get hasMore; bool get offline; bool get cacheWriteFailed; String? get error; String? get pageError;
/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedStateCopyWith<FeedState> get copyWith => _$FeedStateCopyWithImpl<FeedState>(this as FeedState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FeedState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedState&&const DeepCollectionEquality().equals(other.articles, _this.articles)&&(identical(other.query, _this.query) || other.query == _this.query)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.loading, _this.loading) || other.loading == _this.loading)&&(identical(other.refreshing, _this.refreshing) || other.refreshing == _this.refreshing)&&(identical(other.loadingMore, _this.loadingMore) || other.loadingMore == _this.loadingMore)&&(identical(other.hasMore, _this.hasMore) || other.hasMore == _this.hasMore)&&(identical(other.offline, _this.offline) || other.offline == _this.offline)&&(identical(other.cacheWriteFailed, _this.cacheWriteFailed) || other.cacheWriteFailed == _this.cacheWriteFailed)&&(identical(other.error, _this.error) || other.error == _this.error)&&(identical(other.pageError, _this.pageError) || other.pageError == _this.pageError));
}


@override
int get hashCode {
  final _this = this as FeedState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.articles),_this.query,_this.category,_this.loading,_this.refreshing,_this.loadingMore,_this.hasMore,_this.offline,_this.cacheWriteFailed,_this.error,_this.pageError);
}

@override
String toString() {
  final _this = this as FeedState;
  return 'FeedState(articles: ${_this.articles}, query: ${_this.query}, category: ${_this.category}, loading: ${_this.loading}, refreshing: ${_this.refreshing}, loadingMore: ${_this.loadingMore}, hasMore: ${_this.hasMore}, offline: ${_this.offline}, cacheWriteFailed: ${_this.cacheWriteFailed}, error: ${_this.error}, pageError: ${_this.pageError})';
}


}

/// @nodoc
abstract mixin class $FeedStateCopyWith<$Res>  {
  factory $FeedStateCopyWith(FeedState value, $Res Function(FeedState) _then) = _$FeedStateCopyWithImpl;
@useResult
$Res call({
 List<Article> articles, String query, NewsCategory category, bool loading, bool refreshing, bool loadingMore, bool hasMore, bool offline, bool cacheWriteFailed, String? error, String? pageError
});




}
/// @nodoc
class _$FeedStateCopyWithImpl<$Res>
    implements $FeedStateCopyWith<$Res> {
  _$FeedStateCopyWithImpl(this._self, this._then);

  final FeedState _self;
  final $Res Function(FeedState) _then;

/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? articles = null,Object? query = null,Object? category = null,Object? loading = null,Object? refreshing = null,Object? loadingMore = null,Object? hasMore = null,Object? offline = null,Object? cacheWriteFailed = null,Object? error = freezed,Object? pageError = freezed,}) {
  return _then(FeedState(
articles: null == articles ? _self.articles : articles // ignore: cast_nullable_to_non_nullable
as List<Article>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as NewsCategory,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,refreshing: null == refreshing ? _self.refreshing : refreshing // ignore: cast_nullable_to_non_nullable
as bool,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,offline: null == offline ? _self.offline : offline // ignore: cast_nullable_to_non_nullable
as bool,cacheWriteFailed: null == cacheWriteFailed ? _self.cacheWriteFailed : cacheWriteFailed // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,pageError: freezed == pageError ? _self.pageError : pageError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FeedState].
extension FeedStatePatterns on FeedState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedState value)  $default,){
final _that = this;
switch (_that) {
case _FeedState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedState value)?  $default,){
final _that = this;
switch (_that) {
case _FeedState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Article> articles,  String query,  NewsCategory category,  bool loading,  bool refreshing,  bool loadingMore,  bool hasMore,  bool offline,  bool cacheWriteFailed,  String? error,  String? pageError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedState() when $default != null:
return $default(_that.articles,_that.query,_that.category,_that.loading,_that.refreshing,_that.loadingMore,_that.hasMore,_that.offline,_that.cacheWriteFailed,_that.error,_that.pageError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Article> articles,  String query,  NewsCategory category,  bool loading,  bool refreshing,  bool loadingMore,  bool hasMore,  bool offline,  bool cacheWriteFailed,  String? error,  String? pageError)  $default,) {final _that = this;
switch (_that) {
case _FeedState():
return $default(_that.articles,_that.query,_that.category,_that.loading,_that.refreshing,_that.loadingMore,_that.hasMore,_that.offline,_that.cacheWriteFailed,_that.error,_that.pageError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Article> articles,  String query,  NewsCategory category,  bool loading,  bool refreshing,  bool loadingMore,  bool hasMore,  bool offline,  bool cacheWriteFailed,  String? error,  String? pageError)?  $default,) {final _that = this;
switch (_that) {
case _FeedState() when $default != null:
return $default(_that.articles,_that.query,_that.category,_that.loading,_that.refreshing,_that.loadingMore,_that.hasMore,_that.offline,_that.cacheWriteFailed,_that.error,_that.pageError);case _:
  return null;

}
}

}

/// @nodoc


class _FeedState implements FeedState {
  const _FeedState({ List<Article> articles = const <Article>[], this.query = '', this.category = NewsCategory.business, this.loading = true, this.refreshing = false, this.loadingMore = false, this.hasMore = false, this.offline = false, this.cacheWriteFailed = false, this.error, this.pageError}): _articles = articles;
  

 final  List<Article> _articles;
@override@JsonKey() List<Article> get articles {
  if (_articles is EqualUnmodifiableListView) return _articles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_articles);
}

@override@JsonKey() final  String query;
@override@JsonKey() final  NewsCategory category;
@override@JsonKey() final  bool loading;
@override@JsonKey() final  bool refreshing;
@override@JsonKey() final  bool loadingMore;
@override@JsonKey() final  bool hasMore;
@override@JsonKey() final  bool offline;
@override@JsonKey() final  bool cacheWriteFailed;
@override final  String? error;
@override final  String? pageError;

/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedStateCopyWith<_FeedState> get copyWith => __$FeedStateCopyWithImpl<_FeedState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedState&&const DeepCollectionEquality().equals(other.articles, _articles)&&(identical(other.query, query) || other.query == query)&&(identical(other.category, category) || other.category == category)&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.refreshing, refreshing) || other.refreshing == refreshing)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.offline, offline) || other.offline == offline)&&(identical(other.cacheWriteFailed, cacheWriteFailed) || other.cacheWriteFailed == cacheWriteFailed)&&(identical(other.error, error) || other.error == error)&&(identical(other.pageError, pageError) || other.pageError == pageError));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_articles),query,category,loading,refreshing,loadingMore,hasMore,offline,cacheWriteFailed,error,pageError);
}

@override
String toString() {
    return 'FeedState(articles: $articles, query: $query, category: $category, loading: $loading, refreshing: $refreshing, loadingMore: $loadingMore, hasMore: $hasMore, offline: $offline, cacheWriteFailed: $cacheWriteFailed, error: $error, pageError: $pageError)';
}


}

/// @nodoc
abstract mixin class _$FeedStateCopyWith<$Res> implements $FeedStateCopyWith<$Res> {
  factory _$FeedStateCopyWith(_FeedState value, $Res Function(_FeedState) _then) = __$FeedStateCopyWithImpl;
@override @useResult
$Res call({
 List<Article> articles, String query, NewsCategory category, bool loading, bool refreshing, bool loadingMore, bool hasMore, bool offline, bool cacheWriteFailed, String? error, String? pageError
});




}
/// @nodoc
class __$FeedStateCopyWithImpl<$Res>
    implements _$FeedStateCopyWith<$Res> {
  __$FeedStateCopyWithImpl(this._self, this._then);

  final _FeedState _self;
  final $Res Function(_FeedState) _then;

/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? articles = null,Object? query = null,Object? category = null,Object? loading = null,Object? refreshing = null,Object? loadingMore = null,Object? hasMore = null,Object? offline = null,Object? cacheWriteFailed = null,Object? error = freezed,Object? pageError = freezed,}) {
  return _then(_FeedState(
articles: null == articles ? _self._articles : articles // ignore: cast_nullable_to_non_nullable
as List<Article>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as NewsCategory,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,refreshing: null == refreshing ? _self.refreshing : refreshing // ignore: cast_nullable_to_non_nullable
as bool,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,offline: null == offline ? _self.offline : offline // ignore: cast_nullable_to_non_nullable
as bool,cacheWriteFailed: null == cacheWriteFailed ? _self.cacheWriteFailed : cacheWriteFailed // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,pageError: freezed == pageError ? _self.pageError : pageError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
