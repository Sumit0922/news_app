enum FailureKind {
  network,
  timeout,
  invalidResponse,
  server,
  rateLimit,
  storage,
  unknown,
}

class AppFailure implements Exception {
  const AppFailure(this.kind);
  final FailureKind kind;
  @override
  String toString() => 'AppFailure($kind)';
}
