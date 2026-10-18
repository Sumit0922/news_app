abstract final class AppDurations {
  static const fast = Duration(milliseconds: 180);
  static const normal = Duration(milliseconds: 320);
  static const debounce = Duration(milliseconds: 400);
  static const orbit = Duration(milliseconds: 1400);
  static const request = Duration(seconds: 15);
  static const imageFade = Duration(milliseconds: 450);
}

abstract final class ApiConstants {
  static const baseUrl = 'https://api.spaceflightnewsapi.net/v4/';
  static const articles = 'articles/';
  static const pageSize = 20;
  static const maxCachedQueries = 12;
  static const maxThumbnailBytes = 2 * 1024 * 1024;
}
