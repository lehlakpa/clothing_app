import 'package:clothing_app/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthInitial()) {
    // LOGIN
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());

      try {
        final user = await repository.login(
          username: event.username,
          password: event.password,
        );
        print('AUTHENTICATED');
        print('LOGIN SUCCESS');
        print('Access Token: ${user.accessToken}');
        print('Refresh Token: ${user.refreshToken}');

        emit(Authenticated(user));
      } catch (e) {
        print('LOGIN ERROR: $e');

        emit(AuthError(e.toString()));
      }
    });

    // CHECK LOGIN WHEN APP STARTS
    on<CheckAuth>((event, emit) async {
      emit(AuthLoading());

      try {
        final accessToken = await repository.getAccessToken();

        if (accessToken != null && accessToken.isNotEmpty) {
          print('TOKEN FOUND');

          // We already have token
          emit(Authenticated(repository.createUserFromToken(accessToken)));
        } else {
          print('NO TOKEN FOUND');

          emit(Unauthenticated());
        }
      } catch (e) {
        print('CHECK AUTH ERROR: $e');

        emit(Unauthenticated());
      }
    });
    on<GetProfileRequested>((event, emit) async {
      try {
        final profile = await repository.getProfile();

        emit(ProfileLoaded(profile));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    // LOGOUT
    on<LogoutRequested>((event, emit) async {
      await repository.logout();

      emit(Unauthenticated());
    });
  }
}
