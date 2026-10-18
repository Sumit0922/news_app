import 'package:hive_flutter/hive_flutter.dart';

import '../errors/app_failure.dart';

class LocalStore {
  LocalStore({
    required this.settings,
    required this.feed,
    required this.bookmarks,
  });
  final Box<dynamic> settings;
  final Box<dynamic> feed;
  final Box<dynamic> bookmarks;

  static Future<LocalStore> open() async {
    try {
      await Hive.initFlutter();
      return LocalStore(
        settings: await Hive.openBox<dynamic>('settings_v1'),
        feed: await Hive.openBox<dynamic>('feed_v1'),
        bookmarks: await Hive.openBox<dynamic>('bookmarks_v1'),
      );
    } catch (_) {
      throw const AppFailure(FailureKind.storage);
    }
  }
}
