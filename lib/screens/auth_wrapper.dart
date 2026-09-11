import 'package:clothing_app/bloc/auth_bloc.dart';
import 'package:clothing_app/bloc/auth_state.dart';

import 'package:clothing_app/widgets/custom_navigation.dart';
import 'package:clothing_app/widgets/custom_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // LOGIN SUCCESS
        if (state is Authenticated) {
          NotificationService.showLoginSuccess();
        }

        // LOGIN ERROR
        if (state is AuthError) {
          NotificationService.showLoginError(state.message);
        }
      },

      builder: (context, state) {
        // APP STARTING
        if (state is AuthInitial || state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // USER LOGGED IN
        if (state is Authenticated || state is ProfileLoaded) {
          return const CustomNavigation();
        }

        // USER NOT LOGGED IN
        if (state is Unauthenticated) {
          return const LoginScreen();
        }

        // LOGIN ERROR
        if (state is AuthError) {
          return const LoginScreen();
        }

        return const LoginScreen();
      },
    );
  }
}
