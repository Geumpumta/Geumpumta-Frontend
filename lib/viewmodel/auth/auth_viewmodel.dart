import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../repository/auth/auth_repository.dart';
import '../../viewmodel/user/user_viewmodel.dart';
import '../../routes/app_routes.dart';

final authViewModelProvider =
StateNotifierProvider<AuthViewModel, bool>((ref) => AuthViewModel(ref));

class AuthViewModel extends StateNotifier<bool> {
  final Ref ref;
  final AuthRepository _repo = AuthRepository();

  AuthViewModel(this.ref) : super(false);

  Future<void> loginWithKakao(BuildContext context) async {
    await _login(context, 'kakao');
  }

  Future<void> loginWithGoogle(BuildContext context) async {
    await _login(context, 'google');
  }

  Future<void> loginWithApple(BuildContext context) async {
    await _login(context, 'apple');
  }

  Future<bool> _login(BuildContext context, String provider) async {
    try {
      state = true;

      final isLogined = await _repo.loginWithProvider(provider);
      if (isLogined) {

        final prefs = await SharedPreferences.getInstance();
        final accessToken = prefs.getString('accessToken');
        print(accessToken);
        await ref.read(userViewModelProvider.notifier).loadUserProfile();

        final userState = ref.read(userViewModelProvider);
        userState.when(
          data: (user) {
            if (user.userRole == 'GUEST') {
              Navigator.pushNamed(context, AppRoutes.signin1);
            } else {
              Navigator.pushNamed(context, AppRoutes.main);
            }
          },
          loading: () => debugPrint('프로필 로딩중'),
          error: (e, _) => debugPrint('프로필 로드 실패: $e'),
        );

        return true;
      } else {
        debugPrint('$provider 로그인 실패');
        return false;
      }
    } catch (e, st) {
      debugPrint('$provider 로그인 중 오류: $e\n$st');
      return false;
    } finally {
      state = false;
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    debugPrint('로그아웃 완료');
  }

  Future<void> deleteAccount(String accessToken) async {
    debugPrint('계정 삭제');
  }
}
