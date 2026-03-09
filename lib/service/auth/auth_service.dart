import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;

/// 서버가 redirect_uri?error=already_logged_in 으로 보낼 때 던지는 예외
class AlreadyLoggedInException implements Exception {
  @override
  String toString() => 'AlreadyLoggedInException';
}

class OAuthService {
  String get baseUrl => dotenv.env['BASE_URL'] ?? '';

  Future<Map<String, dynamic>?> socialLogin(String provider) async {
    try {
      const redirectUri = 'geumpumta://auth/callback';

      final authUrl =
          '$baseUrl/oauth2/authorization/$provider?redirect_uri=$redirectUri';


      final result = await FlutterWebAuth2.authenticate(
        url: authUrl,
        callbackUrlScheme: 'geumpumta',
      );

      final uri = Uri.parse(result);

      // 서버가 error 쿼리로 리다이렉트한 경우 (중복 로그인 등)
      final errorParam = uri.queryParameters['error'];
      if (errorParam != null) {
        print('OAuth redirect with error: $errorParam, fullUri: $result');
        if (errorParam == 'already_logged_in') {
          throw AlreadyLoggedInException();
        }
      }

      final accessToken =
          uri.queryParameters['accessToken'] ?? uri.queryParameters['access_token'];
      final refreshToken =
          uri.queryParameters['refreshToken'] ?? uri.queryParameters['refresh_token'];

      if (accessToken != null && refreshToken != null) {
        return {
          'accessToken': accessToken,
          'refreshToken': refreshToken,
        };
      }

      final code = uri.queryParameters['code'];
      if (code != null) {
        final tokenData =
        await exchangeCodeForToken(provider, code, redirectUri);
        return tokenData;
      }

      return null;
    } on AlreadyLoggedInException {
      rethrow;
    } catch (e) {
      print('OAuth 로그인 실패: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> exchangeCodeForToken(
      String provider, String code, String redirectUri) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/oauth/token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'provider': provider,
        'code': code,
        'redirect_uri': redirectUri,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('토큰 교환 실패: ${response.body}');
    }
  }
}
