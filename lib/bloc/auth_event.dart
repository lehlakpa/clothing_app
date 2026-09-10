abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String username;
  final String password;

  LoginRequested({required this.username, required this.password});
}

class CheckAuth extends AuthEvent {}

class LogoutRequested extends AuthEvent {}

class GetProfileRequested extends AuthEvent {}
