import 'dart:async';

import '../constants/app_config.dart';

class Debouncer {
  Debouncer({this.delay = AppDurations.debounce});
  final Duration delay;
  Timer? _timer;
  void call(void Function() callback) {
    _timer?.cancel();
    _timer = Timer(delay, callback);
  }

  void cancel() => _timer?.cancel();
  void dispose() => cancel();
}
