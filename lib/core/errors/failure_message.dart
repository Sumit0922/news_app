import 'app_failure.dart';
import '../constants/app_strings.dart';

String failureMessage(Object error) => switch (error) {
  AppFailure(kind: FailureKind.network) => AppStrings.noInternet,
  AppFailure(kind: FailureKind.timeout) => AppStrings.timeout,
  AppFailure(kind: FailureKind.invalidResponse) => AppStrings.invalidResponse,
  AppFailure(kind: FailureKind.server) => AppStrings.serverError,
  AppFailure(kind: FailureKind.rateLimit) => AppStrings.rateLimit,
  AppFailure(kind: FailureKind.storage) => AppStrings.storageError,
  _ => AppStrings.unknownError,
};
