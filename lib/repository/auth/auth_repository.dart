import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../service/auth/google_auth_service.dart';
import '../../service/auth/kakao_auth_service.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    kakaoService: KakaoAuthService(),
    googleService: GoogleAuthService(),
  );
});

class AuthRepository {
  final KakaoAuthService kakaoService;
  final GoogleAuthService googleService;

  AuthRepository({
    required this.kakaoService,
    required this.googleService,
  });

  Future<void> loginWithKakao() async {
    await kakaoService.signIn();
  }

  Future<void> loginWithGoogle() async {
    await googleService.signIn();
  }
}
