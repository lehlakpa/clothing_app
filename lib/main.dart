import 'package:clothing_app/bloc/auth_bloc.dart';
import 'package:clothing_app/bloc/auth_event.dart';
import 'package:clothing_app/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/auth_wrapper.dart';
import 'services/api_service.dart';
import 'services/token_storage.dart';

void main() {
  final apiService = ApiService();

  final tokenStorage = TokenStorage();

  final authRepository = AuthRepository(
    apiService: apiService,
    tokenStorage: tokenStorage,
  );

  runApp(
    BlocProvider(
      create: (_) => AuthBloc(authRepository)..add(CheckAuth()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Clothing App',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),

      home: const AuthWrapper(),
    );
  }
}
