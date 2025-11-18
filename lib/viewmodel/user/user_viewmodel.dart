import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/models/dto/user/get_user_info_response_dto.dart';

import '../../models/entity/user/user.dart';
import '../../provider/repository_provider.dart';
import '../../repository/user/user_repository.dart';

final userViewModelProvider =
    StateNotifierProvider<UserViewModel, AsyncValue<User>>((ref) {
      final repo = ref.watch(userRepositoryProvider);
      return UserViewModel(repo);
    });

class UserViewModel extends StateNotifier<AsyncValue<User>> {
  final UserRepository _repo;
  AsyncValue<void> registrationState = const AsyncData(null);

  UserViewModel(this._repo) : super(const AsyncLoading());

  Future<User?> loadUserProfile() async {
    state = const AsyncLoading();
    try {
      final user = await _repo.getUserProfile();
      state = AsyncData(user);
      return user;
    } catch (e, st) {
      state = AsyncError(e, st);
      return null;
    }
  }

  Future<void> completeRegistration(
    BuildContext context,
    String email,
    String studentId,
    String department,
  ) async {
    registrationState = const AsyncLoading();
    try {
      await _repo.completeRegistration(email, studentId, department);
      registrationState = AsyncData(null);
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

    } catch (e, st) {
      registrationState = AsyncError(e, st);
    }
  }
}
