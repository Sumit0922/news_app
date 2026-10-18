import 'package:hive/hive.dart';

import '../../../core/errors/app_failure.dart';
import '../domain/preferences_repository.dart';

class HivePreferencesRepository implements PreferencesRepository {
  const HivePreferencesRepository(this.box);
  final Box<dynamic> box;
  @override
  ReadingTheme readTheme() {
    final value = box.get('theme');
    return ReadingTheme.values
            .where((theme) => theme.name == value)
            .firstOrNull ??
        ReadingTheme.system;
  }

  @override
  Future<void> saveTheme(ReadingTheme theme) async {
    try {
      await box.put('theme', theme.name);
    } catch (_) {
      throw const AppFailure(FailureKind.storage);
    }
  }
}
