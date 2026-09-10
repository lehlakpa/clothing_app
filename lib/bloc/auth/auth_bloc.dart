import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/errors/api_exception.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc({required this.repository}) : super(const AuthState()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);

    on<LoginRequested>(_onLoginRequested);

    on<ProfileRequested>(_onProfileRequested);

    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));

    try {
      final loggedIn = await repository.isLoggedIn();

      if (!loggedIn) {
        emit(
          state.copyWith(status: AuthStatus.unauthenticated, clearUser: true),
        );

        return;
      }

      final user = await repository.getCurrentUser();

      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          clearError: true,
        ),
      );
    } catch (e) {
      await repository.logout();

      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          clearUser: true,
          errorMessage: _getErrorMessage(e),
        ),
      );
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));

    try {
      final user = await repository.login(
        username: event.username,
        password: event.password,
      );

      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: _getErrorMessage(e),
        ),
      );
    }
  }

  Future<void> _onProfileRequested(
    ProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final user = await repository.getCurrentUser();

      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          clearError: true,
        ),
      );
    } catch (e) {
      final message = _getErrorMessage(e);

      if (e is ApiException && e.statusCode == 401) {
        await repository.logout();

        emit(
          state.copyWith(
            status: AuthStatus.unauthenticated,
            clearUser: true,
            errorMessage: message,
          ),
        );

        return;
      }

      emit(
        state.copyWith(status: AuthStatus.authenticated, errorMessage: message),
      );
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await repository.logout();

    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  String _getErrorMessage(Object error) {
    if (error is ApiException) {
      return error.message;
    }

    return 'Something went wrong. Please try again.';
  }
}
