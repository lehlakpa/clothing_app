import 'package:clothing_app/models/auth_models.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final AuthModel user;

  Authenticated(this.user);
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

class ProfileLoaded extends AuthState {
  final Map<String, dynamic> profile;

  ProfileLoaded(this.profile);
}
