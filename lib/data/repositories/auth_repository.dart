import '../../core/storage/token_storage.dart';
import '../../models/user_model.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final TokenStorage tokenStorage;

  AuthRepository({required this.remoteDataSource, required this.tokenStorage});

  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    final data = await remoteDataSource.login(
      username: username,
      password: password,
    );

    final accessToken = data['accessToken'] as String?;

    final refreshToken = data['refreshToken'] as String?;

    if (accessToken == null || accessToken.isEmpty) {
      throw Exception('Access token not received');
    }

    await tokenStorage.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );

    return UserModel.fromJson(data);
  }

  Future<UserModel> getCurrentUser() {
    return remoteDataSource.getCurrentUser();
  }

  Future<bool> isLoggedIn() async {
    final accessToken = await tokenStorage.getAccessToken();

    return accessToken != null && accessToken.isNotEmpty;
  }

  Future<void> logout() async {
    await tokenStorage.clearTokens();
  }
}
