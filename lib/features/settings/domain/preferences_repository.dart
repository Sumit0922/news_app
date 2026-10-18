enum ReadingTheme { system, light, dark }

abstract interface class PreferencesRepository {
  ReadingTheme readTheme();
  Future<void> saveTheme(ReadingTheme theme);
}
