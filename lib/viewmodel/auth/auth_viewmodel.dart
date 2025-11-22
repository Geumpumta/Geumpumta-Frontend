import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/userState/user_info_state.dart';
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
      if (!isLogined) {
        debugPrint('$provider 로그인 실패');
        return false;
      }

      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');
      print("로그인 후 accessToken: $accessToken");

      final userInfo =
      await ref.read(userViewModelProvider.notifier).loadUserProfile();

      if (userInfo == null) {
        debugPrint("유저 정보 로드 실패");
        return false;
      }

      ref.read(userInfoStateProvider.notifier).setUser(userInfo);

      final jsonString = jsonEncode(userInfo.toJson());
      await prefs.setString('userInfo', jsonString);
      print("userInfo 저장 완료: $jsonString");

      if (userInfo.userRole == "GUEST") {
        Navigator.pushNamed(context, AppRoutes.signin1);
      } else {
        Navigator.pushNamed(context, AppRoutes.main);
      }

      return true;

    } catch (e, st) {
      debugPrint('$provider 로그인 중 오류: $e\n$st');
      return false;
    } finally {
      state = false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userInfo');
    ref.read(userInfoStateProvider.notifier).clear();
  }

  Future<void> deleteAccount(String accessToken) async {
    debugPrint('계정 삭제');
  }
}
