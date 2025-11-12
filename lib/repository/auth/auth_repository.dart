import 'package:shared_preferences/shared_preferences.dart';

import '../../service/auth/auth_service.dart';

class AuthRepository {
  final OAuthService _oauthService = OAuthService();

  Future<bool> loginWithProvider(String provider) async {
    final tokens = await _oauthService.socialLogin(provider);
    if (tokens == null) return false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', tokens['accessToken']);
    await prefs.setString('refreshToken', tokens['refreshToken']);
    return true;
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> updateTokens(
    String newAccessToken, [
    String? newRefreshToken,
  ]) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('accessToken', newAccessToken);

    if (newRefreshToken != null) {
      await prefs.setString('refreshToken', newRefreshToken);
    }

    print('토큰 갱신 완료: AccessToken 업데이트됨');
  }
}
