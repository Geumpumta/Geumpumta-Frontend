import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:geumpumta/provider/auth/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _storage = FlutterSecureStorage();
final _dio = Dio(BaseOptions(baseUrl: "https://your-api-server.com")); // 서버 api로 바꿔야함

Future<void> kakaoLogin(WidgetRef ref) async {
  await _socialLogin(ref, "kakao");
}

Future<void> googleLogin(WidgetRef ref) async {
  await _socialLogin(ref, "google");
}

Future<void> _socialLogin(WidgetRef ref, String provider) async {
  final redirectUri = "geumpumta://auth/callback";
  final authUrl =
      "https://your-api-server.com/oauth2/authorization/$provider?redirect_uri=$redirectUri"; // 서버 api로 바꿔야함

  final resultUrl = await FlutterWebAuth2.authenticate(
    url: authUrl,
    callbackUrlScheme: "geumpumta",
  );

  final uri = Uri.parse(resultUrl);
  final accessToken = uri.queryParameters["accessToken"] ?? uri.queryParameters["access_token"];
  final refreshToken = uri.queryParameters["refreshToken"] ?? uri.queryParameters["refresh_token"];

  if (accessToken != null && refreshToken != null) {
    await _saveTokens(accessToken, refreshToken);
    await _prefetchUser(ref);
  } else if (uri.queryParameters["code"] != null) {
    final code = uri.queryParameters["code"];
    final response = await _dio.post("/auth/token", data: {
      "provider": provider,
      "code": code,
      "redirectUri": redirectUri,
    });

    await _saveTokens(response.data["accessToken"], response.data["refreshToken"]);
    await _prefetchUser(ref);
  }
}

Future<void> _prefetchUser(WidgetRef ref) async {
  try {
    final accessToken = await _storage.read(key: "accessToken");
    if (accessToken == null) return;

    final response = await _dio.get(
      "/api/user/me",
      options: Options(headers: {"Authorization": "Bearer $accessToken"}),
    );

    ref.read(authProvider.notifier).state = true;
    print("사용자 정보: ${response.data}");
  } catch (e) {
    print("prefetchUser 실패: $e");
  }
}

Future<void> _saveTokens(String accessToken, String refreshToken) async {
  await _storage.write(key: "accessToken", value: accessToken);
  await _storage.write(key: "refreshToken", value: refreshToken);
}

Future<void> logout(WidgetRef ref) async {
  try {
    // 서버에 로그아웃 요청 (선택사항)
    final accessToken = await _storage.read(key: "accessToken");
    if (accessToken != null) {
      try {
        await _dio.post(
          "/api/auth/logout",
          options: Options(headers: {"Authorization": "Bearer $accessToken"}),
        );
      } catch (e) {
        // 서버 요청 실패해도 로컬 로그아웃은 진행
        print("로그아웃 서버 요청 실패: $e");
      }
    }
    
    // 로컬 저장소 삭제
    await _storage.deleteAll();
    // 인증 상태 변경
    ref.read(authProvider.notifier).state = false;
  } catch (e) {
    print("로그아웃 실패: $e");
    rethrow;
  }
}

Future<void> deleteAccount(WidgetRef ref) async {
  try {
    final accessToken = await _storage.read(key: "accessToken");
    if (accessToken == null) {
      throw Exception("인증 토큰이 없습니다.");
    }

    // 서버에 회원탈퇴 요청
    await _dio.delete(
      "/api/user/me",
      options: Options(headers: {"Authorization": "Bearer $accessToken"}),
    );

    // 로컬 저장소 삭제
    await _storage.deleteAll();
    // 인증 상태 변경
    ref.read(authProvider.notifier).state = false;
  } catch (e) {
    print("회원탈퇴 실패: $e");
    rethrow;
  }
}
