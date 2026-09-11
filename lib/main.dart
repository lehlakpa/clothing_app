import 'package:clothing_app/bloc/auth_bloc.dart';
import 'package:clothing_app/bloc/auth_event.dart';
import 'package:clothing_app/bloc/product/product_bloc.dart';
import 'package:clothing_app/repository/auth_repository.dart';
import 'package:clothing_app/repository/product_repoproduct_repository.dartsitory.dart';
import 'package:clothing_app/services/product_service.dart';
import 'package:clothing_app/widgets/custom_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/auth_wrapper.dart';
import 'services/api_service.dart';
import 'services/token_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();
  final apiService = ApiService();

  final tokenStorage = TokenStorage();

  final authRepository = AuthRepository(
    apiService: apiService,
    tokenStorage: tokenStorage,
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(authRepository)..add(CheckAuth()),
        ),
        BlocProvider<ProductBloc>(
          create: (_) => ProductBloc(ProductRepository(ProductService())),
        ),
      ],
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
