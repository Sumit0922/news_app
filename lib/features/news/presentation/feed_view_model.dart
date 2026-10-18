import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../app/providers.dart';
import '../../../core/errors/failure_message.dart';
import '../../../core/utils/debouncer.dart';
import '../../auth/presentation/auth_view_model.dart';
import '../domain/article.dart';

part 'feed_view_model.freezed.dart';

@freezed
abstract class FeedState with _$FeedState {
  const factory FeedState({
    @Default(<Article>[]) List<Article> articles,
    @Default('') String query,
    @Default(true) bool loading,
    @Default(false) bool refreshing,
    @Default(false) bool loadingMore,
    @Default(false) bool hasMore,
    @Default(false) bool offline,
    @Default(false) bool cacheWriteFailed,
    String? error,
    String? pageError,
  }) = _FeedState;
}

final feedProvider = NotifierProvider.autoDispose<FeedViewModel, FeedState>(
  FeedViewModel.new,
);

class FeedViewModel extends Notifier<FeedState> {
  final _debouncer = Debouncer();
  int _generation = 0;
  int _nextOffset = 0;

  @override
  FeedState build() {
    ref.watch(authProvider.select((state) => state.email));
    final generation = ++_generation;
    ref.onDispose(() {
      _generation++;
      _debouncer.dispose();
    });
    Future.microtask(() {
      if (ref.mounted && generation == _generation) unawaited(refresh());
    });
    return const FeedState();
  }

  void search(String query) {
    if (query.trim() == state.query) return;
    _generation++; // Invalidate the previous request immediately, before debounce.
    _nextOffset = 0;
    state = FeedState(query: query.trim());
    _debouncer(() => unawaited(refresh()));
  }

  Future<void> refresh() async {
    _debouncer.cancel();
    final generation = ++_generation;
    final query = state.query;
    final hasContent = state.articles.isNotEmpty;
    state = state.copyWith(
      loading: !hasContent,
      refreshing: hasContent,
      loadingMore: false,
      error: null,
      pageError: null,
    );
    try {
      final result = await ref.read(fetchNewsProvider)(query: query);
      if (!ref.mounted || generation != _generation) return;
      _nextOffset = result.page.nextOffset;
      state = FeedState(
        query: query,
        articles: _unique(result.page.articles),
        loading: false,
        hasMore: result.page.hasMore,
        offline: result.fromCache,
        cacheWriteFailed: result.cacheWriteFailed,
      );
    } catch (error) {
      if (!ref.mounted || generation != _generation) return;
      state = state.copyWith(
        loading: false,
        refreshing: false,
        error: failureMessage(error),
      );
    }
  }

  Future<void> loadMore() async {
    if (state.loading ||
        state.refreshing ||
        state.loadingMore ||
        !state.hasMore ||
        state.offline) {
      return;
    }
    final generation = _generation;
    final query = state.query;
    state = state.copyWith(loadingMore: true, pageError: null);
    try {
      final result = await ref.read(fetchNewsProvider)(
        query: query,
        offset: _nextOffset,
      );
      if (!ref.mounted || generation != _generation) return;
      _nextOffset = result.page.nextOffset;
      state = state.copyWith(
        articles: _unique([...state.articles, ...result.page.articles]),
        loadingMore: false,
        hasMore: result.page.hasMore,
        pageError: null,
      );
    } catch (error) {
      if (!ref.mounted || generation != _generation) return;
      state = state.copyWith(
        loadingMore: false,
        pageError: failureMessage(error),
      );
    }
  }

  List<Article> _unique(List<Article> values) =>
      {for (final value in values) value.id: value}.values.toList();
}
