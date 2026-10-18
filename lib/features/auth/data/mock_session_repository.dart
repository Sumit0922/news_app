import 'package:hive/hive.dart';

import '../../../core/errors/app_failure.dart';
import '../domain/session_repository.dart';

class MockSessionRepository implements SessionRepository {
  const MockSessionRepository(this.box);
  final Box<dynamic> box;
  static const _sessionKey = 'remembered_email';

  @override
  String? restoredEmail() {
    final value = box.get(_sessionKey);
    return value is String && value.isNotEmpty ? value : null;
  }

  @override
  Future<void> signIn({required String email, required bool remember}) async {
    try {
      if (remember) {
        await box.put(_sessionKey, email);
      } else {
        await box.delete(_sessionKey);
      }
    } catch (_) {
      throw const AppFailure(FailureKind.storage);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await box.delete(_sessionKey);
    } catch (_) {
      throw const AppFailure(FailureKind.storage);
    }
  }
}
