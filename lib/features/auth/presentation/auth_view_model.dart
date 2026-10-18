import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:orbit_news/core/utils/app_snackbar.dart:.dart';
import '../../../app/providers.dart';
import '../../../core/errors/failure_message.dart';
import '../../../core/utils/validators.dart';
part 'auth_view_model.freezed.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    String? email,
    @Default(false) bool busy,
    String? error,
  }) = _AuthState;
}

final authProvider = NotifierProvider<AuthViewModel, AuthState>(
  AuthViewModel.new,
);

class AuthViewModel extends Notifier<AuthState> {
  @override
  AuthState build() =>
      AuthState(email: ref.watch(sessionRepositoryProvider).restoredEmail());

  Future<void> signIn(
    String email,
    String password, {
    required bool remember,
  }) async {
    if (state.busy) return;

    final validation = Validators.email(email) ?? Validators.password(password);

    if (validation != null) {
      state = state.copyWith(error: validation);
      return;
    }

    state = state.copyWith(busy: true, error: null);

    try {
      final normalized = email.trim().toLowerCase();

      await ref
          .read(sessionRepositoryProvider)
          .signIn(email: normalized, remember: remember);

      if (ref.mounted) {
        state = AuthState(email: normalized);
      }

      showAppSnackbar('Login successful');
    } catch (error) {
      if (ref.mounted) {
        state = state.copyWith(busy: false, error: failureMessage(error));
      }
    }
  }

  Future<void> signOut() async {
    if (state.busy) return;

    state = state.copyWith(busy: true, error: null);

    try {
      await ref.read(sessionRepositoryProvider).signOut();

      if (ref.mounted) {
        state = const AuthState();
      }

      showAppSnackbar('Logout successful');
    } catch (error) {
      if (ref.mounted) {
        state = state.copyWith(busy: false, error: failureMessage(error));
      }
    }
  }
}
