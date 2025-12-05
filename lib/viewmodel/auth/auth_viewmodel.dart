import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/entity/user/user.dart';
import '../../provider/userState/user_info_state.dart';
import '../../provider/repository_provider.dart';
import '../../repository/auth/auth_repository.dart';
import '../../repository/user/user_repository.dart';
import '../../viewmodel/user/user_viewmodel.dart';
import '../../routes/app_routes.dart';

final authViewModelProvider = StateNotifierProvider<AuthViewModel, bool>(
  (ref) => AuthViewModel(ref),
);

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
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('로그인에 실패했습니다. 다시 시도해주세요.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return false;
      }

      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');
      print("로그인 후 accessToken: $accessToken");

      // JWT 토큰에서 WITHDRAWN 필드 확인
      bool isWithdrawn = false;
      if (accessToken != null && accessToken.isNotEmpty) {
        try {
          isWithdrawn = _checkIfWithdrawnFromToken(accessToken);
          if (isWithdrawn) {
            debugPrint("회원탈퇴 상태 감지됨 (토큰에서 확인)");
          }
        } catch (e) {
          debugPrint("토큰 디코딩 실패: $e");
        }
      }

      User? userInfo;
      
      // 회원탈퇴 상태인 경우 바로 복구 다이얼로그 표시
      if (isWithdrawn) {
        if (context.mounted) {
          final shouldRestore = await _showRestoreAccountDialog(context);
          if (shouldRestore == true) {
            // 계정 복구 시도
            debugPrint('복구 다이얼로그에서 복구하기 선택됨');
            final restored = await _restoreAccount(context);
            debugPrint('복구 결과: $restored');
            if (restored) {
              // 복구 성공 시 잠시 대기 후 다시 프로필 로드
              await Future.delayed(const Duration(milliseconds: 500));
              try {
                debugPrint('복구 후 프로필 로드 시도');
                userInfo = await ref
                    .read(userViewModelProvider.notifier)
                    .loadUserProfile();
                debugPrint('복구 후 프로필 로드 성공: ${userInfo != null}');
              } on UserProfileException catch (e) {
                debugPrint("복구 후 프로필 로드 실패 (UserProfileException): ${e.message}");
                if (context.mounted) {
                  await Flushbar(
                    message: '프로필을 불러올 수 없습니다: ${e.message}',
                    backgroundColor: Colors.red.shade700,
                    flushbarPosition: FlushbarPosition.TOP,
                    margin: const EdgeInsets.all(10),
                    borderRadius: BorderRadius.circular(10),
                    duration: const Duration(seconds: 2),
                    icon: const Icon(Icons.error_outline, color: Colors.white),
                  ).show(context);
                }
                return false;
              } catch (e, stackTrace) {
                debugPrint("복구 후 프로필 로드 실패: $e");
                debugPrint('스택 트레이스: $stackTrace');
                if (context.mounted) {
                  await Flushbar(
                    message: '프로필을 불러올 수 없습니다: ${e.toString()}',
                    backgroundColor: Colors.red.shade700,
                    flushbarPosition: FlushbarPosition.TOP,
                    margin: const EdgeInsets.all(10),
                    borderRadius: BorderRadius.circular(10),
                    duration: const Duration(seconds: 2),
                    icon: const Icon(Icons.error_outline, color: Colors.white),
                  ).show(context);
                }
                return false;
              }
            } else {
              debugPrint('계정 복구 실패로 인해 로그인 중단');
              return false;
            }
          } else {
            debugPrint('복구 다이얼로그에서 취소 선택됨');
            return false;
          }
        } else {
          return false;
        }
      } else {
        // 일반적인 프로필 로드 시도
        try {
          userInfo = await ref
              .read(userViewModelProvider.notifier)
              .loadUserProfile();
        } on UserProfileException catch (e) {
          // 회원탈퇴 관련 에러 코드 확인
          if (e.code == 'WITHDRAWN' || e.code == '5001' || e.message.contains('탈퇴')) {
            // 회원탈퇴 상태인 경우 복구 다이얼로그 표시
            if (context.mounted) {
              final shouldRestore = await _showRestoreAccountDialog(context);
              if (shouldRestore == true) {
                // 계정 복구 시도
                final restored = await _restoreAccount(context);
                if (restored) {
                  // 복구 성공 시 다시 프로필 로드
                  userInfo = await ref
                      .read(userViewModelProvider.notifier)
                      .loadUserProfile();
                } else {
                  return false;
                }
              } else {
                return false;
              }
            } else {
              return false;
            }
          } else {
            // 다른 에러인 경우
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(e.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
            return false;
          }
        } catch (e) {
          debugPrint("유저 정보 로드 실패: $e");
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('계정 정보를 불러올 수 없습니다.'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return false;
        }
      }

      if (userInfo == null) {
        debugPrint("유저 정보 로드 실패");
        return false;
      }

      ref.read(userInfoStateProvider.notifier).setUser(userInfo);

      final jsonString = jsonEncode(userInfo.toJson());
      await prefs.setString('userInfo', jsonString);
      debugPrint("userInfo 저장 완료: $jsonString");

      if (userInfo.userRole == "GUEST") {
        Navigator.pushNamed(context, AppRoutes.signin1);
      } else {
        Navigator.pushNamed(context, AppRoutes.main);
      }

      return true;
    } catch (e, st) {
      debugPrint('$provider 로그인 중 오류: $e\n$st');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('로그인 중 오류가 발생했습니다: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    } finally {
      state = false;
    }
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userInfo');
    ref.read(userInfoStateProvider.notifier).clear();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  Future<void> deleteAccount(String accessToken) async {
    try {
      debugPrint('deleteAccount 시작');
      final userRepository = ref.read(userRepositoryProvider);
      final response = await userRepository.withdrawUser();
      debugPrint('deleteAccount 응답: success=${response.success}, message=${response.message}');
      
      // 회원탈퇴 성공 여부와 관계없이 모든 데이터 삭제
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      ref.read(userInfoStateProvider.notifier).clear();
      debugPrint('회원탈퇴: 로컬 데이터 삭제 완료');
      
      if (!response.success) {
        throw Exception(response.message ?? '회원탈퇴에 실패했습니다.');
      }
    } catch (e) {
      debugPrint('회원탈퇴 중 오류: $e');
      // 에러가 발생해도 로컬 데이터는 이미 삭제되었으므로 rethrow
      rethrow;
    }
  }

  Future<bool?> _showRestoreAccountDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '계정 복구',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '탈퇴한 계정입니다.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 12),
              Text(
                '계정을 복구하시겠습니까?',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                '취소',
                style: TextStyle(
                  color: Color(0xFF999999),
                  fontSize: 16,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                '복구하기',
                style: TextStyle(
                  color: Color(0xFF0BAEFF),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _restoreAccount(BuildContext context) async {
    try {
      debugPrint('계정 복구 시작');
      final userRepository = ref.read(userRepositoryProvider);
      final response = await userRepository.restoreUser();
      
      debugPrint('계정 복구 응답: success=${response.success}, msg=${response.msg}, code=${response.code}');
      
      if (response.success) {
        debugPrint('계정 복구 성공');
        if (context.mounted) {
          await Flushbar(
            message: '계정이 복구되었습니다.',
            backgroundColor: Colors.green.shade600,
            flushbarPosition: FlushbarPosition.TOP,
            margin: const EdgeInsets.all(10),
            borderRadius: BorderRadius.circular(10),
            duration: const Duration(seconds: 2),
            icon: const Icon(Icons.check_circle, color: Colors.white),
          ).show(context);
        }
        return true;
      } else {
        debugPrint('계정 복구 실패: ${response.msg}');
        if (context.mounted) {
          await Flushbar(
            message: response.msg ?? '계정 복구에 실패했습니다.',
            backgroundColor: Colors.red.shade700,
            flushbarPosition: FlushbarPosition.TOP,
            margin: const EdgeInsets.all(10),
            borderRadius: BorderRadius.circular(10),
            duration: const Duration(seconds: 2),
            icon: const Icon(Icons.error_outline, color: Colors.white),
          ).show(context);
        }
        return false;
      }
    } catch (e, stackTrace) {
      debugPrint('계정 복구 중 예외 발생: $e');
      debugPrint('스택 트레이스: $stackTrace');
      if (context.mounted) {
        await Flushbar(
          message: '계정 복구 중 오류가 발생했습니다: ${e.toString()}',
          backgroundColor: Colors.red.shade700,
          flushbarPosition: FlushbarPosition.TOP,
          margin: const EdgeInsets.all(10),
          borderRadius: BorderRadius.circular(10),
          duration: const Duration(seconds: 3),
          icon: const Icon(Icons.error_outline, color: Colors.white),
        ).show(context);
      }
      return false;
    }
  }

  /// JWT 토큰에서 WITHDRAWN 필드 확인
  bool _checkIfWithdrawnFromToken(String token) {
    try {
      // JWT는 header.payload.signature 형태
      final parts = token.split('.');
      if (parts.length != 3) {
        return false;
      }

      // payload 부분 디코딩
      final payload = parts[1];
      // base64url 디코딩 (패딩 추가)
      String normalized = payload.replaceAll('-', '+').replaceAll('_', '/');
      switch (normalized.length % 4) {
        case 1:
          normalized += '===';
          break;
        case 2:
          normalized += '==';
          break;
        case 3:
          normalized += '=';
          break;
      }

      final decoded = utf8.decode(base64Decode(normalized));
      final payloadMap = jsonDecode(decoded) as Map<String, dynamic>;
      
      // WITHDRAWN 필드 확인
      final withdrawn = payloadMap['WITHDRAWN'];
      return withdrawn == true || withdrawn == 'true';
    } catch (e) {
      debugPrint('토큰 디코딩 오류: $e');
      return false;
    }
  }
}
