import '../constants/app_strings.dart';
import 'app_failure.dart';

String failureMessage(Object error) {
  return switch (error) {
    AppFailure(kind: FailureKind.network) => AppStrings.noInternet,
    AppFailure(kind: FailureKind.timeout) => AppStrings.timeout,
    AppFailure(kind: FailureKind.invalidResponse) => AppStrings.invalidResponse,
    AppFailure(kind: FailureKind.server) => AppStrings.serverError,
    AppFailure(kind: FailureKind.rateLimit) => AppStrings.rateLimit,
    AppFailure(kind: FailureKind.storage) => AppStrings.storageError,
    AppFailure(kind: FailureKind.configuration) =>
      'The news source is not configured correctly.',
    AppFailure(kind: FailureKind.unauthorized) =>
      'This news source is currently unavailable.',
    _ => AppStrings.unknownError,
  };
}
