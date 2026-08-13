import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'auth_change_notifier.dart';
import 'auth_user.dart';

/// Thrown for expected auth failures so the UI can show a friendly message.
class AuthException implements Exception {
  const AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  static const _tokenKey = 'auth_token';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static String get _baseUrl {
    const configuredUrl = String.fromEnvironment('API_BASE_URL');
    if (configuredUrl.isNotEmpty) {
      return '${configuredUrl.replaceFirst(RegExp(r'/+$'), '')}/api';
    }
    if (kIsWeb) return 'http://192.168.18.209:8000/api';
    if (Platform.isAndroid) return 'http://192.168.18.209:8000/api';
    return 'http://192.168.18.209:8000/api';
  }

  Future<String?> get token => _storage.read(key: _tokenKey);

  /// Reads any stored session on app start and updates global auth state.
  /// Returns the restored user, or null when there is no valid session.
  Future<AuthUser?> restoreSession() async {
    final storedToken = await _storage.read(key: _tokenKey);
    if (storedToken == null || storedToken.isEmpty) return null;

    try {
      final user = await _fetchCurrentUser(storedToken);
      AuthChangeNotifier.instance.setLoggedIn(user);
      return user;
    } on AuthException {
      // Token is invalid or expired: clear it so the user re-authenticates.
      await _storage.delete(key: _tokenKey);
      return null;
    } catch (_) {
      // Network error at startup: keep the token, treat as logged out for now.
      return null;
    }
  }

  Future<AuthUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _post('/auth/register', {
      'name': name,
      'email': email,
      'password': password,
    });
    return _handleAuthResponse(response);
  }

  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    final response = await _post('/auth/login', {
      'email': email,
      'password': password,
    });
    return _handleAuthResponse(response);
  }

  Future<void> forgotPassword(String email) async {
    final response = await _post('/auth/forgot-password', {'email': email});
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw AuthException(_errorMessage(response, 'Unable to send reset code.'));
    }
  }

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    final response = await _post('/auth/reset-password', {
      'email': email,
      'otp': otp,
      'new_password': newPassword,
    });
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw AuthException(
        _errorMessage(response, 'Invalid or expired reset code.'),
      );
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
    AuthChangeNotifier.instance.setLoggedOut();
  }

  Future<Uint8List?> getProfileImage() async {
    final storedToken = await _storage.read(key: _tokenKey);
    if (storedToken == null || storedToken.isEmpty) return null;

    final response = await http.get(
      Uri.parse('$_baseUrl/auth/me/profile-image'),
      headers: {'Authorization': 'Bearer $storedToken'},
    );
    if (response.statusCode == 200) return response.bodyBytes;
    if (response.statusCode == 404) return null;
    throw AuthException('Unable to load profile image.');
  }

  Future<void> saveProfileImage(Uint8List bytes, String mimeType) async {
    final storedToken = await _storage.read(key: _tokenKey);
    if (storedToken == null || storedToken.isEmpty) {
      throw const AuthException('Please sign in to save a profile image.');
    }

    final request = http.MultipartRequest(
      'PUT',
      Uri.parse('$_baseUrl/auth/me/profile-image'),
    );
    request.headers['Authorization'] = 'Bearer $storedToken';
    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: 'profile.jpg',
        contentType: MediaType.parse(mimeType),
      ),
    );
    final response = await request.send();
    if (response.statusCode != 200) {
      throw AuthException('Unable to save profile image.');
    }
  }

  Future<void> deleteProfileImage() async {
    final storedToken = await _storage.read(key: _tokenKey);
    if (storedToken == null || storedToken.isEmpty) {
      throw const AuthException('Please sign in to remove a profile image.');
    }

    final response = await http.delete(
      Uri.parse('$_baseUrl/auth/me/profile-image'),
      headers: {'Authorization': 'Bearer $storedToken'},
    );
    if (response.statusCode != 204) {
      throw AuthException('Unable to remove profile image.');
    }
  }

  Future<AuthUser> _fetchCurrentUser(String storedToken) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/auth/me'),
      headers: {'Authorization': 'Bearer $storedToken'},
    );
    if (response.statusCode == 200) {
      return AuthUser.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }
    throw const AuthException('Session expired.');
  }

  Future<http.Response> _post(String path, Map<String, dynamic> body) {
    return http.post(
      Uri.parse('$_baseUrl$path'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
  }

  Future<AuthUser> _handleAuthResponse(http.Response response) async {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final accessToken = data['access_token'] as String;
      final user = AuthUser.fromJson(data['user'] as Map<String, dynamic>);
      await _storage.write(key: _tokenKey, value: accessToken);
      AuthChangeNotifier.instance.setLoggedIn(user);
      return user;
    }
    throw AuthException(_errorMessage(response, 'Authentication failed.'));
  }

  String _errorMessage(http.Response response, String fallback) {
    try {
      final data = jsonDecode(response.body);
      if (data is Map<String, dynamic> && data['detail'] is String) {
        return data['detail'] as String;
      }
    } catch (_) {
      // Body was not JSON; fall through to the default message.
    }
    return fallback;
  }
}
