import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../repository/auth/auth_repository.dart';

final authViewModelProvider =
ChangeNotifierProvider<AuthViewModel>((ref) => AuthViewModel());

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repo = AuthRepository();
  bool isLoading = false;

  Future<void> loginWithKakao() async {
    await _login('kakao');
  }

  Future<void> loginWithGoogle() async {
    await _login('google');
  }

  Future<void> _login(String provider) async {
    try {
      isLoading = true;
      notifyListeners();

      final success = await _repo.loginWithProvider(provider);
      if (success) {
        print('$provider 로그인 성공!');
        final prefs = await SharedPreferences.getInstance();
        print('AccessToken: ${prefs.getString('accessToken')}');
        print('RefreshToken: ${prefs.getString('refreshToken')}');

        // TODO: 로그인 후 라우팅 or 사용자 정보 요청
      } else {
        print('$provider 로그인 실패');
      }
    } catch (e) {
      print('$provider 로그인 중 오류: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    print('로그아웃 완료');
  }


  Future<void> deleteAccount(String accessToken) async {
    print('계정 삭제');
  }

}
