import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../app/providers.dart';
import '../../../core/errors/failure_message.dart';
import '../../../core/utils/debouncer.dart';
import '../../auth/presentation/auth_view_model.dart';
import '../domain/article.dart';
import '../domain/news_category.dart';

part 'feed_view_model.freezed.dart';

@freezed
abstract class FeedState with _$FeedState {
  const factory FeedState({
    @Default(<Article>[]) List<Article> articles,
    @Default('') String query,
    @Default(NewsCategory.business) NewsCategory category,
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

// Keep the briefing while navigating between the shell tabs.
// Authentication changes still rebuild and reset this state.
final feedProvider = NotifierProvider<FeedViewModel, FeedState>(
  FeedViewModel.new,
);

class FeedViewModel extends Notifier<FeedState> {
  final _debouncer = Debouncer();

  int _generation = 0;
  int _nextOffset = 0;

  int _activeRefreshGeneration = -1;
  Future<void>? _activeRefresh;

  @override
  FeedState build() {
    final email = ref.watch(authProvider.select((state) => state.email));

    final generation = ++_generation;

    _nextOffset = 0;
    _activeRefresh = null;
    _activeRefreshGeneration = -1;

    ref.onDispose(() {
      _generation++;
      _debouncer.dispose();
    });

    if (email == null) {
      return const FeedState(loading: false);
    }

    final preview = _preview(category: NewsCategory.business, query: '');

    Future.microtask(() {
      if (_isCurrent(generation)) {
        unawaited(refresh(force: false));
      }
    });

    return preview;
  }

  FeedState _preview({required NewsCategory category, required String query}) {
    final cached = ref
        .read(fetchNewsProvider)
        .cached(category: category, query: query);

    return FeedState(
      category: category,
      query: query,
      articles: cached?.page.articles ?? const [],
      loading: cached == null,
      offline: cached != null,
    );
  }

  void selectCategory(NewsCategory category) {
    if (category == state.category) return;

    _debouncer.cancel();
    _generation++;
    _nextOffset = 0;

    state = _preview(category: category, query: state.query);

    unawaited(refresh(force: false));
  }

  void search(String value) {
    final query = value.trim();

    if (query == state.query) return;

    _generation++;
    _nextOffset = 0;

    state = _preview(category: state.category, query: query);

    _debouncer(() {
      if (ref.mounted) {
        unawaited(refresh(force: false));
      }
    });
  }

  void clearSearch() {
    _debouncer.cancel();

    if (state.query.isEmpty) return;

    _generation++;
    _nextOffset = 0;

    state = _preview(category: state.category, query: '');

    unawaited(refresh(force: false));
  }

  Future<void> refresh({bool force = true}) {
    _debouncer.cancel();

    final active = _activeRefresh;

    if (active != null && _activeRefreshGeneration == _generation) {
      return active;
    }

    final generation = ++_generation;

    _activeRefreshGeneration = generation;

    final future = _refresh(generation: generation, force: force);

    _activeRefresh = future;

    return future;
  }

  Future<void> _refresh({required int generation, required bool force}) async {
    final category = state.category;
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
      final result = await ref.read(fetchNewsProvider)(
        category: category,
        query: query,
        forceRefresh: force,
      );

      if (!_isCurrent(generation)) return;

      _nextOffset = result.page.nextOffset;

      state = FeedState(
        category: category,
        query: query,
        articles: _unique(result.page.articles),
        loading: false,
        hasMore: result.page.hasMore,
        offline: result.fromCache,
        cacheWriteFailed: result.cacheWriteFailed,
      );
    } catch (error) {
      if (!_isCurrent(generation)) return;

      state = state.copyWith(
        loading: false,
        refreshing: false,
        error: failureMessage(error),
      );
    } finally {
      if (_activeRefreshGeneration == generation) {
        _activeRefresh = null;
        _activeRefreshGeneration = -1;
      }
    }
  }

  Future<void> loadMore() async {
    if (state.loading ||
        state.refreshing ||
        state.loadingMore ||
        state.offline ||
        state.error != null ||
        !state.hasMore) {
      return;
    }

    final generation = _generation;
    final category = state.category;
    final query = state.query;

    state = state.copyWith(loadingMore: true, pageError: null);

    try {
      final result = await ref.read(fetchNewsProvider)(
        category: category,
        query: query,
        offset: _nextOffset,
      );

      if (!_isCurrent(generation)) return;

      _nextOffset = result.page.nextOffset;

      state = state.copyWith(
        articles: _unique([...state.articles, ...result.page.articles]),
        loadingMore: false,
        hasMore: result.page.hasMore,
      );
    } catch (error) {
      if (!_isCurrent(generation)) return;

      state = state.copyWith(
        loadingMore: false,
        pageError: failureMessage(error),
      );
    }
  }

  bool _isCurrent(int generation) {
    return ref.mounted && generation == _generation;
  }

  List<Article> _unique(List<Article> articles) {
    return {for (final article in articles) article.url: article}.values
        .toList(growable: false);
  }
}
