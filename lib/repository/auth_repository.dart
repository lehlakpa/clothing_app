import 'package:clothing_app/models/auth_models.dart';

import '../services/api_service.dart';
import '../services/token_storage.dart';

class AuthRepository {
  final ApiService apiService;
  final TokenStorage tokenStorage;

  AuthRepository({required this.apiService, required this.tokenStorage});

  Future<AuthModel> login({
    required String username,
    required String password,
  }) async {
    final data = await apiService.login(username: username, password: password);

    print('LOGIN API RESPONSE: $data');

    final authModel = AuthModel.fromJson(data);

    await tokenStorage.saveTokens(
      accessToken: authModel.accessToken,
      refreshToken: authModel.refreshToken,
    );

    return authModel;
  }

  // CHECK ACCESS TOKEN
  Future<String?> getAccessToken() async {
    return await tokenStorage.getAccessToken();
  }

  Future<Map<String, dynamic>> getProfile() async {
    final accessToken = await tokenStorage.getAccessToken();

    if (accessToken == null || accessToken.isEmpty) {
      throw Exception('Access token not found');
    }

    return await apiService.getProfile(accessToken);
  }
  // // GET PROFILE
  // Future<Map<String, dynamic>> getProfile() async {
  //   String? accessToken = await tokenStorage.getAccessToken();

  //   if (accessToken == null) {
  //     throw Exception('No access token');
  //   }

  //   try {
  //     return await apiService.getProfile(accessToken);
  //   } catch (e) {
  //     // Access token might have expired.
  //     final refreshToken = await tokenStorage.getRefreshToken();

  //     if (refreshToken == null) {
  //       throw Exception('No refresh token');
  //     }

  //     // Get new access token
  //     final data = await apiService.refreshToken(refreshToken);

  //     final newAccessToken = data['accessToken'];

  //     final newRefreshToken = data['refreshToken'] ?? refreshToken;

  //     // Save new tokens
  //     await tokenStorage.saveTokens(
  //       accessToken: newAccessToken,
  //       refreshToken: newRefreshToken,
  //     );

  //     // Try profile again
  //     return await apiService.getProfile(newAccessToken);
  //   }
  // }

  // LOGOUT
  Future<void> logout() async {
    await tokenStorage.clearTokens();
  }

  AuthModel createUserFromToken(String token) {
    return AuthModel(
      accessToken: token,
      refreshToken: '',
      id: 0,
      username: '',
      email: '',
      firstName: '',
      lastName: '',
    );
  }
}
