// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bookmark_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BookmarkState {

 List<SavedArticle> get articles; Set<int> get busyIds;
/// Create a copy of BookmarkState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookmarkStateCopyWith<BookmarkState> get copyWith => _$BookmarkStateCopyWithImpl<BookmarkState>(this as BookmarkState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BookmarkState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookmarkState&&const DeepCollectionEquality().equals(other.articles, _this.articles)&&const DeepCollectionEquality().equals(other.busyIds, _this.busyIds));
}


@override
int get hashCode {
  final _this = this as BookmarkState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.articles),const DeepCollectionEquality().hash(_this.busyIds));
}

@override
String toString() {
  final _this = this as BookmarkState;
  return 'BookmarkState(articles: ${_this.articles}, busyIds: ${_this.busyIds})';
}


}

/// @nodoc
abstract mixin class $BookmarkStateCopyWith<$Res>  {
  factory $BookmarkStateCopyWith(BookmarkState value, $Res Function(BookmarkState) _then) = _$BookmarkStateCopyWithImpl;
@useResult
$Res call({
 List<SavedArticle> articles, Set<int> busyIds
});




}
/// @nodoc
class _$BookmarkStateCopyWithImpl<$Res>
    implements $BookmarkStateCopyWith<$Res> {
  _$BookmarkStateCopyWithImpl(this._self, this._then);

  final BookmarkState _self;
  final $Res Function(BookmarkState) _then;

/// Create a copy of BookmarkState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? articles = null,Object? busyIds = null,}) {
  return _then(BookmarkState(
articles: null == articles ? _self.articles : articles // ignore: cast_nullable_to_non_nullable
as List<SavedArticle>,busyIds: null == busyIds ? _self.busyIds : busyIds // ignore: cast_nullable_to_non_nullable
as Set<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [BookmarkState].
extension BookmarkStatePatterns on BookmarkState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookmarkState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookmarkState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookmarkState value)  $default,){
final _that = this;
switch (_that) {
case _BookmarkState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookmarkState value)?  $default,){
final _that = this;
switch (_that) {
case _BookmarkState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SavedArticle> articles,  Set<int> busyIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookmarkState() when $default != null:
return $default(_that.articles,_that.busyIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SavedArticle> articles,  Set<int> busyIds)  $default,) {final _that = this;
switch (_that) {
case _BookmarkState():
return $default(_that.articles,_that.busyIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SavedArticle> articles,  Set<int> busyIds)?  $default,) {final _that = this;
switch (_that) {
case _BookmarkState() when $default != null:
return $default(_that.articles,_that.busyIds);case _:
  return null;

}
}

}

/// @nodoc


class _BookmarkState implements BookmarkState {
  const _BookmarkState({ List<SavedArticle> articles = const <SavedArticle>[],  Set<int> busyIds = const <int>{}}): _articles = articles,_busyIds = busyIds;
  

 final  List<SavedArticle> _articles;
@override@JsonKey() List<SavedArticle> get articles {
  if (_articles is EqualUnmodifiableListView) return _articles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_articles);
}

 final  Set<int> _busyIds;
@override@JsonKey() Set<int> get busyIds {
  if (_busyIds is EqualUnmodifiableSetView) return _busyIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_busyIds);
}


/// Create a copy of BookmarkState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookmarkStateCopyWith<_BookmarkState> get copyWith => __$BookmarkStateCopyWithImpl<_BookmarkState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookmarkState&&const DeepCollectionEquality().equals(other.articles, _articles)&&const DeepCollectionEquality().equals(other.busyIds, _busyIds));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_articles),const DeepCollectionEquality().hash(_busyIds));
}

@override
String toString() {
    return 'BookmarkState(articles: $articles, busyIds: $busyIds)';
}


}

/// @nodoc
abstract mixin class _$BookmarkStateCopyWith<$Res> implements $BookmarkStateCopyWith<$Res> {
  factory _$BookmarkStateCopyWith(_BookmarkState value, $Res Function(_BookmarkState) _then) = __$BookmarkStateCopyWithImpl;
@override @useResult
$Res call({
 List<SavedArticle> articles, Set<int> busyIds
});




}
/// @nodoc
class __$BookmarkStateCopyWithImpl<$Res>
    implements _$BookmarkStateCopyWith<$Res> {
  __$BookmarkStateCopyWithImpl(this._self, this._then);

  final _BookmarkState _self;
  final $Res Function(_BookmarkState) _then;

/// Create a copy of BookmarkState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? articles = null,Object? busyIds = null,}) {
  return _then(_BookmarkState(
articles: null == articles ? _self._articles : articles // ignore: cast_nullable_to_non_nullable
as List<SavedArticle>,busyIds: null == busyIds ? _self._busyIds : busyIds // ignore: cast_nullable_to_non_nullable
as Set<int>,
  ));
}


}

// dart format on
