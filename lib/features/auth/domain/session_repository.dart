abstract interface class SessionRepository {
  String? restoredEmail();
  Future<void> signIn({required String email, required bool remember});
  Future<void> signOut();
}
