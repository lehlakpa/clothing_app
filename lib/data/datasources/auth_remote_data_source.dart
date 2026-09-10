import 'dart:convert';

import '../../core/constants/api_constants.dart';
import '../../core/errors/api_exception.dart';
import '../../core/network/api_client.dart';
import '../../models/user_model.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSource({required this.apiClient});

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final response = await apiClient.post(
      ApiConstants.login,
      requiresAuth: false,
      body: {'username': username, 'password': password, 'expiresInMins': 30},
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    }

    throw ApiException(
      message: data['message'] ?? 'Login failed',
      statusCode: response.statusCode,
    );
  }

  Future<UserModel> getCurrentUser() async {
    final response = await apiClient.get(ApiConstants.me, requiresAuth: true);

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return UserModel.fromJson(data);
    }

    throw ApiException(
      message: data['message'] ?? 'Unable to load profile',
      statusCode: response.statusCode,
    );
  }
}
