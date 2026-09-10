import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    print('SAVING ACCESS TOKEN: $accessToken');
    print('SAVING REFRESH TOKEN: $refreshToken');

    await _storage.write(key: accessTokenKey, value: accessToken);

    await _storage.write(key: refreshTokenKey, value: refreshToken);

    print('TOKENS SAVED');
  }

  Future<String?> getAccessToken() async {
    final token = await _storage.read(key: accessTokenKey);

    print('READ ACCESS TOKEN: $token');

    return token;
  }

  Future<String?> getRefreshToken() async {
    final token = await _storage.read(key: refreshTokenKey);

    print('READ REFRESH TOKEN: $token');

    return token;
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: accessTokenKey);

    await _storage.delete(key: refreshTokenKey);

    print('TOKENS CLEARED');
  }
}
