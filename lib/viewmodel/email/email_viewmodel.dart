import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:geumpumta/provider/repository_provider.dart';
import 'package:geumpumta/repository/email/email_repository.dart';

final emailViewModelProvider =
StateNotifierProvider<EmailViewmodel, AsyncValue<void>>((ref) {
  final repo = ref.watch(emailRepositoryProvider);
  return EmailViewmodel(ref, repo);
});

final isSendingProvider = StateProvider<bool>((ref) => false);


class EmailViewmodel extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  final EmailRepository _repo;

  EmailViewmodel(this.ref, this._repo) : super(const AsyncData(null));

  Future<void> sendEmailVerification(
      BuildContext context, String email) async {
    state = const AsyncLoading();
    try {
      final response = await _repo.sendEmailVerification(email);
      state = AsyncData(response);

      await Flushbar(
        message: '인증 메일을 전송했어요!',
        backgroundColor: Colors.green.shade600,
        flushbarPosition: FlushbarPosition.TOP,
        margin: const EdgeInsets.all(10),
        borderRadius: BorderRadius.circular(10),
        duration: const Duration(seconds: 2),
        icon: const Icon(Icons.check_circle, color: Colors.white),
      ).show(context);

      Navigator.pushNamed(context, '/signin2', arguments: email);
    } catch (e, st) {
      state = AsyncError(e, st);

      await Flushbar(
        message: '이메일 전송 실패: ${e.toString()}',
        backgroundColor: Colors.red.shade700,
        flushbarPosition: FlushbarPosition.TOP,
        margin: const EdgeInsets.all(10),
        borderRadius: BorderRadius.circular(10),
        duration: const Duration(seconds: 2),
        icon: const Icon(Icons.error_outline, color: Colors.white),
      ).show(context);
    }
  }

  Future<bool> verifyCode(
      BuildContext context,
      String email,
      String code,
      ) async {
    state = const AsyncLoading();
    try {
      final response = await _repo.verifyCode(email, code);
      state = AsyncData(response);
      if(response){
        await Flushbar(
          message: '인증 성공!',
          backgroundColor: Colors.green.shade600,
          flushbarPosition: FlushbarPosition.TOP,
          margin: const EdgeInsets.all(10),
          borderRadius: BorderRadius.circular(10),
          duration: const Duration(seconds: 2),
          icon: const Icon(Icons.check_circle, color: Colors.white),
        ).show(context);

        Navigator.pushNamed(context, '/signin3');
        return true;
      }
      else{
        throw Exception('인증 코드가 올바르지 않습니다.');
      }
    } catch (e, st) {
      state = AsyncError(e, st);

      await Flushbar(
        message: '인증 실패: ${e.toString()}',
        backgroundColor: Colors.red.shade700,
        flushbarPosition: FlushbarPosition.TOP,
        margin: const EdgeInsets.all(10),
        borderRadius: BorderRadius.circular(10),
        duration: const Duration(seconds: 2),
        icon: const Icon(Icons.error_outline, color: Colors.white),
      ).show(context);

      return false;
    }
  }
}
