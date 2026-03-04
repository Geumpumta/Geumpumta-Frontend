import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/models/dto/user/complete_registration_response_dto.dart';

import '../../models/entity/user/user.dart';
import '../../provider/repository_provider.dart';
import '../../provider/userState/user_info_state.dart';
import '../../repository/user/user_repository.dart';
import '../../widgets/error_dialog/error_dialog.dart';

final userViewModelProvider = StateNotifierProvider<UserViewModel, void>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return UserViewModel(repo, ref);
});

class UserViewModel extends StateNotifier<void> {
  final UserRepository _repo;
  final Ref ref;

  UserViewModel(this._repo, this.ref) : super(const AsyncLoading());

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

  Future<User?> updateUserInfo() async {
    try {
      final user = await _repo.getUserProfile();

      if (user != null) {
        ref.read(userInfoStateProvider.notifier).setUser(user);
      }

      return user;
    } catch (e) {
      debugPrint("updateUserInfo() 실패: $e");
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

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/main',
        (route) => false,
        arguments: {'checkUnnotifiedBadgesOnEnter': true},
      );
      unawaited(updateUserInfo());

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
