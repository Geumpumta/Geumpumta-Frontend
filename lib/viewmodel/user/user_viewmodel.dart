import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/models/dto/user/complete_registration_response_dto.dart';

import '../../models/entity/user/user.dart';
import '../../provider/repository_provider.dart';
import '../../repository/user/user_repository.dart';
import '../../widgets/error_dialog/error_dialog.dart';

final userViewModelProvider =
StateNotifierProvider<UserViewModel, void>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return UserViewModel(repo);
});


class UserViewModel extends StateNotifier<void> {
  final UserRepository _repo;

  UserViewModel(this._repo) : super(const AsyncLoading());

  Future<User?> loadUserProfile() async {
    try {
      final user = await _repo.getUserProfile();
      return user;
    } on UserProfileException {
      // UserProfileException은 그대로 전달
      rethrow;
    } catch (e, st) {
      return null;
    }
  }

  Future<CompleteRegistrationResponseDto?> completeRegistration(
    BuildContext context,
    String email,
    String studentId,
    String department,
  ) async {
    try {
      final response = await _repo.completeRegistration(
        email,
        studentId,
        department,
      );

      if (!response.success) {
        ErrorDialog.show(context, response.msg ?? "회원가입에 실패했어요.");
        return response;
      }

      await Flushbar(
        message: '계정 생성 완료!',
        backgroundColor: Colors.green.shade600,
        flushbarPosition: FlushbarPosition.TOP,
        margin: const EdgeInsets.all(10),
        borderRadius: BorderRadius.circular(10),
        duration: const Duration(seconds: 2),
        icon: const Icon(Icons.check_circle, color: Colors.white),
      ).show(context);

      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);

      return response;
    } on DioException catch (e) {
      final data = e.response?.data;

      final serverMsg =
          data?['message'] ?? data?['msg'] ?? "회원가입 중 오류가 발생했습니다.";

      ErrorDialog.show(context, serverMsg);

      return CompleteRegistrationResponseDto(
        success: false,
        data: null,
        code: data?['code'],
        msg: serverMsg,
      );
    } catch (e) {
      ErrorDialog.show(context, "뭔가 잘못된 거 같아요.\n${e.toString()}");

      return CompleteRegistrationResponseDto(
        success: false,
        data: null,
        code: null,
        msg: e.toString(),
      );
    }
  }
}
