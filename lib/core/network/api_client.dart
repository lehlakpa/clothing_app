import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../errors/api_exception.dart';
import '../storage/token_storage.dart';

class ApiClient {
  final http.Client client;
  final TokenStorage tokenStorage;

  bool _isRefreshing = false;

  Future<void>? _refreshFuture;

  ApiClient({required this.client, required this.tokenStorage});

  Future<http.Response> get(String url, {bool requiresAuth = true}) async {
    return _send(method: 'GET', url: url, requiresAuth: requiresAuth);
  }

  Future<http.Response> post(
    String url, {
    Map<String, dynamic>? body,
    bool requiresAuth = false,
  }) async {
    return _send(
      method: 'POST',
      url: url,
      body: body,
      requiresAuth: requiresAuth,
    );
  }

  Future<http.Response> _send({
    required String method,
    required String url,
    Map<String, dynamic>? body,
    required bool requiresAuth,
    bool isRetry = false,
  }) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth) {
      final accessToken = await tokenStorage.getAccessToken();

      if (accessToken == null || accessToken.isEmpty) {
        throw const ApiException(
          message: 'Authentication token not found',
          statusCode: 401,
        );
      }

      headers['Authorization'] = 'Bearer $accessToken';
    }

    http.Response response;

    try {
      if (method == 'GET') {
        response = await client.get(Uri.parse(url), headers: headers);
      } else if (method == 'POST') {
        response = await client.post(
          Uri.parse(url),
          headers: headers,
          body: body == null ? null : jsonEncode(body),
        );
      } else {
        throw const ApiException(message: 'Unsupported HTTP method');
      }
    } on TimeoutException {
      throw const ApiException(message: 'Request timed out');
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }

      throw const ApiException(message: 'No internet connection');
    }

    // Token expired.
    if (response.statusCode == 401 && requiresAuth && !isRetry) {
      final refreshed = await _refreshAccessToken();

      if (refreshed) {
        return _send(
          method: method,
          url: url,
          body: body,
          requiresAuth: requiresAuth,
          isRetry: true,
        );
      }

      throw const ApiException(
        message: 'Session expired. Please login again.',
        statusCode: 401,
      );
    }

    return response;
  }

  Future<bool> _refreshAccessToken() async {
    // Another request is already refreshing.
    if (_isRefreshing) {
      if (_refreshFuture != null) {
        try {
          await _refreshFuture;

          final token = await tokenStorage.getAccessToken();

          return token != null && token.isNotEmpty;
        } catch (_) {
          return false;
        }
      }

      return false;
    }

    _isRefreshing = true;

    final completer = Completer<void>();

    _refreshFuture = completer.future;

    try {
      final refreshToken = await tokenStorage.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        return false;
      }

      final response = await client.post(
        Uri.parse(ApiConstants.refresh),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'refreshToken': refreshToken, 'expiresInMins': 30}),
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        await tokenStorage.clearTokens();

        return false;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      final newAccessToken = data['accessToken'] as String?;

      final newRefreshToken = data['refreshToken'] as String?;

      if (newAccessToken == null || newAccessToken.isEmpty) {
        await tokenStorage.clearTokens();

        return false;
      }

      await tokenStorage.saveTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken ?? refreshToken,
      );

      return true;
    } catch (_) {
      await tokenStorage.clearTokens();

      return false;
    } finally {
      _isRefreshing = false;

      if (!completer.isCompleted) {
        completer.complete();
      }

      _refreshFuture = null;
    }
  }

  void dispose() {
    client.close();
  }
}
