import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/network/dio_factory.dart';
import '../core/storage/local_store.dart';
import '../features/auth/data/mock_session_repository.dart';
import '../features/auth/domain/session_repository.dart';
import '../features/news/data/bookmark_repository_impl.dart';
import '../features/news/data/news_local_source.dart';
import '../features/news/data/news_remote_source.dart';
import '../features/news/data/news_repository_impl.dart';
import '../features/news/domain/fetch_news.dart';
import '../features/news/domain/news_repository.dart';
import '../features/settings/data/hive_preferences_repository.dart';
import '../features/settings/domain/preferences_repository.dart';

final localStoreInitializationProvider = FutureProvider<LocalStore>(
      (ref) => LocalStore.open(),
);

final localStoreProvider = Provider<LocalStore>(
      (ref) => ref.watch(localStoreInitializationProvider).requireValue,
);

final dioProvider = Provider<Dio>((ref) {
  final dio = createNewsDio();

  ref.onDispose(() => dio.close(force: true));

  return dio;
});

final newsRepositoryProvider = Provider<NewsRepository>(
      (ref) => NewsRepositoryImpl(
    remote: NewsRemoteSource(ref.watch(dioProvider)),
    local: NewsLocalSource(ref.watch(localStoreProvider).feed),
  ),
);

final fetchNewsProvider = Provider<FetchNews>(
      (ref) => FetchNews(ref.watch(newsRepositoryProvider)),
);

final bookmarkRepositoryProvider = Provider<BookmarkRepository>(
      (ref) => BookmarkRepositoryImpl(
    box: ref.watch(localStoreProvider).bookmarks,
    imageDio: ref.watch(dioProvider),
  ),
);

final sessionRepositoryProvider = Provider<SessionRepository>(
      (ref) => MockSessionRepository(
    ref.watch(localStoreProvider).settings,
  ),
);

final preferencesRepositoryProvider = Provider<PreferencesRepository>(
      (ref) => HivePreferencesRepository(
    ref.watch(localStoreProvider).settings,
  ),
);