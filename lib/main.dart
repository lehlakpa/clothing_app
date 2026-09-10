import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'bloc/auth/auth_bloc.dart';
import 'bloc/auth/auth_event.dart';
import 'bloc/auth/auth_state.dart';

import 'core/network/api_client.dart';
import 'core/storage/token_storage.dart';

import 'data/datasources/auth_remote_data_source.dart';
import 'data/repositories/auth_repository.dart';

import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // HTTP client
  final httpClient = http.Client();

  // Secure token storage
  final tokenStorage = TokenStorage();

  // API client
  final apiClient = ApiClient(client: httpClient, tokenStorage: tokenStorage);

  // Remote data source
  final remoteDataSource = AuthRemoteDataSource(apiClient: apiClient);

  // Repository
  final authRepository = AuthRepository(
    remoteDataSource: remoteDataSource,
    tokenStorage: tokenStorage,
  );

  runApp(MyApp(authRepository: authRepository));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;

  const MyApp({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) =>
          AuthBloc(repository: authRepository)..add(const AuthCheckRequested()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'clothing_app',

        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),

        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        switch (state.status) {
          case AuthStatus.initial:
          case AuthStatus.loading:
            return const SplashScreen();

          case AuthStatus.authenticated:
            return const HomeScreen();

          case AuthStatus.unauthenticated:
          case AuthStatus.failure:
            return const LoginScreen();
        }
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
