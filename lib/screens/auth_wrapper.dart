import 'package:clothing_app/bloc/auth_bloc.dart';
import 'package:clothing_app/bloc/auth_state.dart';
import 'package:clothing_app/widgets/custom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        // APP STARTING
        if (state is AuthInitial || state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // A successful profile request replaces `Authenticated` with
        // `ProfileLoaded`, so both states must keep the user on Home.
        if (state is Authenticated || state is ProfileLoaded) {
          return const CustomNavigation();
        }

        // User is not logged in
        if (state is Unauthenticated) {
          return const LoginScreen();
        }

        // Login error
        if (state is AuthError) {
          return const LoginScreen();
        }

        return const CustomNavigation();
      },
    );
  }
}
