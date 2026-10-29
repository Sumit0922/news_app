abstract final class AppDurations {
  static const fast = Duration(milliseconds: 180);
  static const normal = Duration(milliseconds: 280);
  static const debounce = Duration(milliseconds: 650);
  static const orbit = Duration(milliseconds: 1400);
  static const request = Duration(seconds: 15);
  static const imageFade = Duration(milliseconds: 250);

  static const feedCache = Duration(minutes: 2);
  static const minimumRefresh = Duration(seconds: 20);
}

abstract final class ApiConstants {
  static const baseUrl = 'https://feeds.bbci.co.uk/';
  static const articles = 'news/rss.xml';

  static const pageSize = 20;
  static const maxCachedQueries = 12;
  static const maxThumbnailBytes = 2 * 1024 * 1024;

  static const cacheNamespace = 'rss_news_v1';
}
