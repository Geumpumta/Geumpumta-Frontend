import 'dart:convert';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;

class OAuthService {
  final String baseUrl = 'https://geumpumta.shop:8080';

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
