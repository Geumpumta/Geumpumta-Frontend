import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/provider/repository_provider.dart';
import 'package:geumpumta/repository/email/email_repository.dart';
import 'package:geumpumta/viewmodel/user/user_viewmodel.dart';

final emailViewModelProvider =
    StateNotifierProvider<EmailViewmodel, AsyncValue<void>>((ref) {
      final repo = ref.watch(emailRepositoryProvider);
      return EmailViewmodel(ref, repo);
    });

class EmailViewmodel extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  final EmailRepository _repo;

  EmailViewmodel(this.ref, this._repo) : super(const AsyncLoading());

  Future<void> sendEmailVerification(BuildContext context, String email) async {
    state = const AsyncLoading();
    try {
      final response = await _repo.sendEmailVerification(email);
      state = AsyncData(response);
      Navigator.pushNamed(context, '/signin2');
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<bool> verifyCode(
    BuildContext context,
    String email,
    String code,
  ) async {
    final userState = ref.read(userViewModelProvider);

    if (userState is! AsyncData) return false;

    final user = (userState as AsyncData).value;
    state = const AsyncLoading();
    try {
      final response = await _repo.verifyCode(email, code);
      state = AsyncData(response);
      Navigator.pushNamed(context, '/signin3');
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}
