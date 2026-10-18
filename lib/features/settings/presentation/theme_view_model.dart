import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../domain/preferences_repository.dart';

final themeProvider = NotifierProvider<ThemeViewModel, ReadingTheme>(
  ThemeViewModel.new,
);

class ThemeViewModel extends Notifier<ReadingTheme> {
  bool _saving = false;
  @override
  ReadingTheme build() => ref.watch(preferencesRepositoryProvider).readTheme();
  Future<void> setTheme(ReadingTheme value) async {
    if (_saving || value == state) return;
    _saving = true;
    try {
      await ref.read(preferencesRepositoryProvider).saveTheme(value);
      if (ref.mounted) state = value;
    } finally {
      _saving = false;
    }
  }
}
